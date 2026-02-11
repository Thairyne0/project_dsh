import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:project_dsh/ui/widgets/cl_responsive_grid/flutter_responsive_flex_grid.dart';
import 'package:project_dsh/ui/widgets/cl_text_field.widget.dart';
import '../../../../ui/layout/constants/sizes.constant.dart';
import '../../../../ui/widgets/cl_container.widget.dart';
import '../../../../ui/widgets/cl_dropdown/cl_dropdown.dart';
import '../../../../ui/widgets/loading.widget.dart';
import '../../../../ui/widgets/textfield_validator.dart';
import '../../../../utils/base.viewmodel.dart';
import '../../../../utils/models/pageaction.model.dart';
import '../../../../utils/providers/appstate.util.provider.dart';
import '../../../ui/cl_theme.dart';
import '../../../utils/models/city.model.dart';
import '../modules/role_permission/models/role.model.dart';
import '../viewmodels/user.viewmodel.dart';

class NewUserPage extends StatefulWidget {
  const NewUserPage({Key? key}) : super(key: key);

  @override
  createState() => NewUserPageState();
}

class NewUserPageState extends State<NewUserPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final List<String> gender = ["M", "F", "Non specificato"];
    final appState = context.read<AppState>();
    return ViewModelBuilder<UserViewModel>.reactive(
        viewModelBuilder: () => UserViewModel(context, VMType.create, null),
        onViewModelReady: (vm) async => await vm.initialize(pageActions: [
              PageAction(
                  title: "Salva",
                  isMain: true,
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      await vm.createUser();
                      appState.refreshList.add(true);
                      context.pop();
                    }
                  }),
            ]),
        builder: (context, vm, child) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(),
            child: vm.isBusy
                ? const LoadingWidget()
                : CustomScrollView(
                slivers: [
            SliverPadding(
            padding: const EdgeInsets.only(top: Sizes.headerOffset),
            sliver: SliverToBoxAdapter(
              child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          CLContainer(
                            contentMargin: const EdgeInsets.symmetric(horizontal: Sizes.padding),
                            child: Column(
                              children: [
                                ResponsiveGrid(
                                  gridSpacing: Sizes.padding,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    ResponsiveGridItem(
                                      lg: 33,
                                      xs: 100,
                                      child: CLTextField(
                                        controller: vm.firstNameTEC,
                                        labelText: "Nome",
                                        capitalize: true,
                                        validators: [Validators.required],
                                        isRequired: true,
                                      ),
                                    ),
                                    ResponsiveGridItem(
                                      lg: 33,
                                      xs: 100,
                                      child: CLTextField(controller: vm.lastNameTEC, labelText: "Cognome", validators: [Validators.required], isRequired: true,capitalize: true,),
                                    ),
                                    ResponsiveGridItem(
                                      lg: 33,
                                      xs: 100,
                                      child: CLDropdown<String>.singleSync(
                                        validators: [Validators.required],
                                        items: gender,
                                        searchCallback: (value) async {
                                          return gender.where((item) => item.toLowerCase().contains(value.toLowerCase())).toList();
                                        },
                                        valueToShow: (item) {
                                          return item;
                                        },
                                        onSelectItem: (item) {
                                          vm.selectedGender = item;
                                        },
                                        hint: "Seleziona un genere",
                                        itemBuilder: (context, item) {
                                          return Text(item);
                                        },
                                      ),
                                    ),
                                    ResponsiveGridItem(
                                      lg: 33,
                                      xs: 100,
                                      child: CLTextField.date(
                                        labelText: "Data di nascita",
                                        controller: vm.birthDateTEC,
                                        isRequired: true,
                                        validators: [Validators.required],
                                        onDateTimeSelected: (picked) {
                                          vm.selectedDate = picked;
                                        },
                                      ),
                                    ),
                                    ResponsiveGridItem(
                                      lg: 33,
                                      xs: 100,
                                      child: Column(
                                        children: [
                                          CLDropdown<City>.singleAsync(
                                            validators: [Validators.required],
                                            searchCallback: vm.getAllCity,
                                            searchColumn: "name",
                                            valueToShow: (item) => item.modelIdentifier,
                                            selectedValues: vm.selectedCity,
                                            onSelectItem: (item) {
                                              setState(() {
                                                vm.selectedCity = item;

                                                // ⚠️ Crea una nuova lista per forzare il rebuild
                                                vm.zips = (item?.zips ?? const <String>[]).toList();

                                                // Reset CAP selezionato
                                                vm.selectedZip = null;
                                              });
                                            },
                                            hint: "Residenza",
                                            itemBuilder: (context, item) =>
                                                Text(item.modelIdentifier, style: CLTheme.of(context).bodyText),
                                          ),
                                        ],
                                      ),
                                    ),

                                    ResponsiveGridItem(
                                      lg: 33,
                                      xs: 100,
                                      child: CLDropdown<String>.singleSync(
                                        // 🔑 Forza rebuild ogni volta che cambia la city
                                        key: ValueKey(vm.selectedCity?.modelIdentifier ?? 'no-city'),
                                        items: vm.zips,
                                        searchCallback: (value) async {
                                          return vm.selectedCity?.zips
                                              .where((item) =>
                                              item.toLowerCase().contains(value.toLowerCase()))
                                              .toList() ??
                                              [];
                                        },
                                        validators: [Validators.required],
                                        valueToShow: (zip) => zip,
                                        onSelectItem: (zip) {
                                          setState(() {
                                            vm.selectedZip = zip;
                                          });
                                        },
                                        selectedValues: vm.selectedZip,
                                        hint: "CAP",
                                        itemBuilder: (context, item) => Text(item),
                                      ),
                                    ),

                                    ResponsiveGridItem(
                                      lg: 33,
                                      xs: 100,
                                      child: CLTextField(
                                          controller: vm.emailTEC,
                                          labelText: "Email",
                                          inputType: TextInputType.emailAddress,
                                          validators: [Validators.required, Validators.email],
                                          isRequired: true),
                                    ),
                                    ResponsiveGridItem(
                                      lg: 33,
                                      xs: 100,
                                      child: CLTextField(controller: vm.phoneTEC, labelText: "Telefono", validators: [Validators.required], isRequired: true),
                                    ),
                                    ResponsiveGridItem(lg: 33, xs: 100),
                                    ResponsiveGridItem(
                                        lg: 25,
                                        xs: 100,
                                        child: Column(
                                          children: [
                                            CLDropdown<Role>.singleAsync(
                                              validators: [Validators.required],
                                              searchCallback: vm.getAllRole,
                                              searchColumn: "name",
                                              valueToShow: (item) {
                                                return item.modelIdentifier;
                                              },
                                              onSelectItem: (item) {
                                                vm.selectedRole = item;
                                              },
                                              hint: "Seleziona un Ruolo",
                                              itemBuilder: (context, item) {
                                                return Text(item.modelIdentifier);
                                              },
                                            ),
                                          ],
                                        )),
                                    ResponsiveGridItem(
                                      lg: 100,
                                      xs: 100,
                                      child: CLTextField.password(
                                          controller: vm.passwordTEC,
                                          labelText: "Password",
                                          validators: [Validators.required, Validators.strongPassword, (value) => Validators.minLength(value, 6)],
                                          isRequired: true),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
          )]));
        });
  }
}

extension MyExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this[1].toLowerCase()}";
  }
}
