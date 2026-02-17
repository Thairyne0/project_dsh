import 'package:provider/provider.dart';
import 'package:project_dsh/ui/widgets/buttons/cl_button.widget.dart';
import 'package:project_dsh/ui/widgets/loading.widget.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:stacked/stacked.dart';
import 'package:project_dsh/utils/extension.util.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:intl/intl.dart';
import '../../../../../ui/cl_theme.dart';
import '../../../../../ui/layout/constants/sizes.constant.dart';
import '../../../../../ui/widgets/paged_datatable/paged_datatable.dart';
import '../../../../../utils/base.viewmodel.dart';
import '../models/user.model.dart';
import '../../../utils/providers/appstate.util.provider.dart';
import '../../../utils/providers/authstate.util.provider.dart';
import '../constants/permission_slug.dart';
import '../constants/users_routes.constants.dart';
import '../viewmodels/user.viewmodel.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final authState = Provider.of<AuthState>(context);
    return ViewModelBuilder<UserViewModel>.reactive(
        viewModelBuilder: () => UserViewModel(context, VMType.list, null),
        onViewModelReady: (vm) async => await vm.initialize(),
        builder: (context, vm, child) {
          if (appState.shouldRefresh) {
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              await vm.initialize();
              appState.reset();
            });
          }
          return vm.isBusy
              ? LoadingWidget()
              : CustomScrollView(
              slivers: [
          SliverPadding(
          padding: const EdgeInsets.only(top: Sizes.headerOffset),
          sliver: SliverToBoxAdapter(
          child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: Sizes.padding),
                        child: PagedDataTable<String, String, User>(
                          rowsSelectable: false,
                          idGetter: (user) => user.id,
                          controller: vm.userTableController,
                          refreshListener: appState.refreshList,
                          fetchPage: vm.getAllUser,
                          initialPage: "1",
                          initialPageSize: 25,
                          onItemTap: (item) {
                            if (authState.hasPermission(PermissionSlugs.dettaglioUtente)) {
                              context.customGoNamed(UserRoutes.viewUser.name, params: {"id": item.id}, replacedRouteName: item.modelIdentifier);
                            }
                          },
                          actionsBuilder: (item) => [
                            /*TableAction<User>(
                                content: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  hoverColor: Colors.transparent,
                                  leading: Icon(Icons.remove_red_eye_rounded, size: Sizes.medium, color: CLTheme.of(context).primaryText),
                                  title: Text("Dettaglio", style: CLTheme.of(context).bodyText),
                                  trailing: const Icon(Icons.arrow_forward_ios_rounded, size: Sizes.small),
                                ),
                                onTap: (item) {
                                  context.customGoNamed(UserRoutes.viewUser.name, params: {"id": item.id}, replacedRouteName: item.modelIdentifier);
                                },
                              ),*/
                            if (authState.hasPermission(PermissionSlugs.updateUtenti))
                              TableAction<User>(
                                content: Row(
                                  children: [Icon(Icons.edit, size: Sizes.medium, color: CLTheme.of(context).primaryText),SizedBox(width: 8),
                                 Text("Modifica", style: CLTheme.of(context).bodyText),],

                                ),
                                onTap: (item) {
                                  context.customGoNamed(UserRoutes.editUser.name, params: {"id": item.id}, replacedRouteName: item.modelIdentifier);
                                },
                              ),
                            /*if (authState.hasPermission(PermissionSlugs.rimozioneUtenti))
                                TableAction<User>(
                                  content: ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    hoverColor: Colors.transparent,
                                    leading: Icon(Icons.delete, size: Sizes.medium, color: CLTheme.of(context).primaryText),
                                    title: Text("Elimina", style: CLTheme.of(context).bodyText),
                                    trailing: Icon(Icons.arrow_forward_ios_rounded, size: Sizes.small, color: CLTheme.of(context).primaryText),
                                  ),
                                  onTap: (item) {
                                    vm.deleteUser(item.id);
                                    appState.refreshList.add(true);
                                  },
                                )*/
                          ],
                          columns: [
                            TableColumn(
                                id: "userData:firstName",
                                title: const Text("Nome"),
                                sortable: true,
                                cellBuilder: (item) => Text(
                                      item.userData.firstName.toString(),
                                      style: CLTheme.of(context).bodyText,
                                    ),
                                sizeFactor: .15,
                                isMain: false),
                            TableColumn(
                              id: "userData:lastName",
                              title: const Text("Cognome"),
                              sortable: true,
                              cellBuilder: (item) => Text(item.userData.lastName.toString()),
                              sizeFactor: .1,
                            ),
                            TableColumn(
                              id: "email",
                              title: const Text("Email"),
                              sortable: true,
                              cellBuilder: (item) => Text(item.email.toString()),
                              sizeFactor: .2,
                            ),
                            TableColumn(
                              id: "userData:cityOfResidence:name",
                              title: const Text("Città di residenza"),
                              sortable: true,
                              cellBuilder: (item) => Text(item.userData.cityOfResidence.name.toString()),
                              sizeFactor: .15,
                            ),
                            TableColumn(
                              id: "generalPolicyAcceptance",
                              title: const Text("Privacy Generale"),
                              sortable: true,
                              cellBuilder: (item) => Icon(
                                item.generalPolicyAcceptance == true ? Icons.check_circle : Icons.cancel,
                                color: item.generalPolicyAcceptance == true ? Colors.green : Colors.red,
                                size: 20,
                              ),
                              sizeFactor: .1,
                            ),
                            TableColumn(
                              id: "photoPolicyAcceptance",
                              title: const Text("Privacy Foto"),
                              sortable: true,
                              cellBuilder: (item) => Icon(
                                item.photoPolicyAcceptance == true ? Icons.check_circle : Icons.cancel,
                                color: item.photoPolicyAcceptance == true ? Colors.green : Colors.red,
                                size: 20,
                              ),
                              sizeFactor: .1,
                            ),
                            TableColumn(
                              id: "marketingPolicyAcceptance",
                              title: const Text("Privacy Marketing"),
                              sortable: true,
                              cellBuilder: (item) => Icon(
                                item.marketingPolicyAcceptance == true ? Icons.check_circle : Icons.cancel,
                                color: item.marketingPolicyAcceptance == true ? Colors.green : Colors.red,
                                size: 20,
                              ),
                              sizeFactor: .1,
                            ),
                            TableColumn(
                              id: "newsletterPolicyAcceptance",
                              title: const Text("Privacy Newsletter"),
                              sortable: true,
                              cellBuilder: (item) => Icon(
                                item.newsletterPolicyAcceptance == true ? Icons.check_circle : Icons.cancel,
                                color: item.newsletterPolicyAcceptance == true ? Colors.green : Colors.red,
                                size: 20,
                              ),
                              sizeFactor: .1,
                            ),

                          ],
                          mainFilter: TextTableFilter(
                            id: "userData:firstName || userData:lastName",
                            title: "Nome o Cognome",
                            isMainFilter: true,
                            chipFormatter: (text) => text,
                          ),
                          extraFilters: [
                        TextTableFilter(
                          id: "userData:cityOfResidence:name",
                          title: "Città di residenza",
                          chipFormatter: (text) => text,
                        ),
                      ],
                          mainMenus: [
                            if (authState.hasPermission(PermissionSlugs.creazioneUtenti))
                              CLButton.primary(
                                icon: Icons.add,
                                text: ResponsiveBreakpoints.of(context).isDesktop ? "Aggiungi Nuovo" : "",
                                onTap: () {
                                  context.customGoNamed(UserRoutes.newUser.name);
                                },
                                context: context,
                              ),
                            if (authState.hasPermission(PermissionSlugs.creazioneUtenti))
                              SizedBox(width: Sizes.padding),
                            CLButton.secondary(
                              icon: Icons.download,
                              text: ResponsiveBreakpoints.of(context).isDesktop ? "Export Utenti" : "",
                              onTap: () async {
                                await _showExportDialog(context, vm);
                              },
                              context: context,
                            ),
                          ],
                          extraMenus: [],
                        ),
                      )
                    ],
                  ),
                ))]);
        });
  }

  Future<void> _showExportDialog(BuildContext context, UserViewModel vm) async {
    bool photoFilter = false;
    bool marketingFilter = false;
    bool newsletterFilter = false;
    DateTimeRange? dateRange;
    final formKey = GlobalKey<FormState>();

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: CLTheme.of(context).secondaryBackground,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: [
                  Icon(Icons.filter_list, color: CLTheme.of(context).primaryText, size: 28),
                  SizedBox(width: 12),
                  Text('Seleziona filtri export', style: CLTheme.of(context).title),
                ],
              ),
              content: SizedBox(
                width: 450,
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Seleziona i consensi da filtrare:',
                        style: CLTheme.of(context).bodyText.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Lascia vuoto per scaricare tutti gli utenti',
                        style: CLTheme.of(context).bodyText.copyWith(
                          fontSize: 12,
                          color: CLTheme.of(context).secondaryText,
                        ),
                      ),
                      SizedBox(height: 24),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: CLTheme.of(context).alternate,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            CheckboxListTile(
                              title: Text('Privacy Foto', style: CLTheme.of(context).bodyText),
                              subtitle: Text(
                                'Utenti che hanno accettato il consenso foto',
                                style: CLTheme.of(context).bodyText.copyWith(
                                  fontSize: 11,
                                  color: CLTheme.of(context).secondaryText,
                                ),
                              ),
                              value: photoFilter,
                              onChanged: (value) {
                                setState(() {
                                  photoFilter = value ?? false;
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                              activeColor: CLTheme.of(context).primary,
                            ),
                            Divider(height: 1, color: CLTheme.of(context).alternate),
                            CheckboxListTile(
                              title: Text('Privacy Marketing', style: CLTheme.of(context).bodyText),
                              subtitle: Text(
                                'Utenti che hanno accettato il consenso marketing',
                                style: CLTheme.of(context).bodyText.copyWith(
                                  fontSize: 11,
                                  color: CLTheme.of(context).secondaryText,
                                ),
                              ),
                              value: marketingFilter,
                              onChanged: (value) {
                                setState(() {
                                  marketingFilter = value ?? false;
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                              activeColor: CLTheme.of(context).primary,
                            ),
                            Divider(height: 1, color: CLTheme.of(context).alternate),
                            CheckboxListTile(
                              title: Text('Privacy Newsletter', style: CLTheme.of(context).bodyText),
                              subtitle: Text(
                                'Utenti che hanno accettato il consenso newsletter',
                                style: CLTheme.of(context).bodyText.copyWith(
                                  fontSize: 11,
                                  color: CLTheme.of(context).secondaryText,
                                ),
                              ),
                              value: newsletterFilter,
                              onChanged: (value) {
                                setState(() {
                                  newsletterFilter = value ?? false;
                                });
                              },
                              controlAffinity: ListTileControlAffinity.leading,
                              activeColor: CLTheme.of(context).primary,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24),
                      Text(
                        'Periodo di registrazione:',
                        style: CLTheme.of(context).bodyText.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 8),
                      DateRangePickerField(
                        initialValue: dateRange,
                        onChanged: (newValue) {
                          setState(() {
                            dateRange = newValue;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                CLButton.secondary(
                  text: 'Annulla',
                  onTap: () {
                    Navigator.of(dialogContext).pop();
                  },
                  context: context,
                ),
                SizedBox(width: 8),
                CLButton.primary(
                  icon: Icons.download,
                  text: 'Scarica Excel',
                  onTap: () {
                    formKey.currentState?.save();
                    Navigator.of(dialogContext).pop({
                      'photoFilter': photoFilter,
                      'marketingFilter': marketingFilter,
                      'newsletterFilter': newsletterFilter,
                      'dateRange': dateRange,
                    });
                  },
                  context: context,
                ),
              ],
            );
          },
        );
      },
    );

    if (result != null) {
      await vm.downloadUsersExcel(
        photoFilter: result['photoFilter'] ?? false,
        marketingFilter: result['marketingFilter'] ?? false,
        newsletterFilter: result['newsletterFilter'] ?? false,
        dateRange: result['dateRange'] as DateTimeRange?,
      );
    }
  }
}

class DateRangePickerField extends StatefulWidget {
  final DateTimeRange? initialValue;
  final Function(DateTimeRange?) onChanged;

  const DateRangePickerField({
    super.key,
    this.initialValue,
    required this.onChanged,
  });

  @override
  State<DateRangePickerField> createState() => _DateRangePickerFieldState();
}

class _DateRangePickerFieldState extends State<DateRangePickerField> {
  final TextEditingController _textController = TextEditingController();
  DateTimeRange? _currentValue;
  final DateFormat _dateFormat = DateFormat.yMd();

  @override
  void initState() {
    super.initState();
    _currentValue = widget.initialValue;
    if (_currentValue != null) {
      _textController.text = _formatDateRange(_currentValue!);
    }
  }

  String _formatDateRange(DateTimeRange range) {
    return "${_dateFormat.format(range.start)} - ${_dateFormat.format(range.end)}";
  }

  Future<void> _showDatePicker() async {
    final results = await showCalendarDatePicker2Dialog(
      context: context,
      config: CalendarDatePicker2WithActionButtonsConfig(
        calendarType: CalendarDatePicker2Type.range,
        firstDate: DateTime(2020),
        lastDate: DateTime.now(),
        currentDate: _currentValue?.start,
      ),
      dialogSize: const Size(496.0, 346.0),
    );

    if (results != null && results.isNotEmpty) {
      // Gestisci sia il caso di range completo che di selezione singola
      DateTime startDate = results.first!;
      DateTime endDate = results.length > 1 && results.last != null
          ? results.last!
          : results.first!; // Se è stata selezionata solo una data, usa la stessa per inizio e fine

      final newRange = DateTimeRange(
        start: startDate,
        end: endDate,
      );

      if (mounted) {
        setState(() {
          _currentValue = newRange;
          _textController.text = _formatDateRange(newRange);
        });

        widget.onChanged(newRange);
      }
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _textController,
      readOnly: true,
      decoration: InputDecoration(
        labelText: "Seleziona periodo",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        suffixIcon: IconButton(
          icon: Icon(Icons.calendar_today),
          onPressed: _showDatePicker,
        ),
      ),
      onTap: _showDatePicker,
    );
  }
}

