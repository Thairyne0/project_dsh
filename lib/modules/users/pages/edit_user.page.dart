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
import '../../../utils/models/city.model.dart';
import '../modules/role_permission/models/role.model.dart';
import '../viewmodels/user.viewmodel.dart';

class EditUserPage extends StatefulWidget {
  EditUserPage({super.key, required this.id});

  final String id;

  @override
  createState() => EditUserPageState();
}

class EditUserPageState extends State<EditUserPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final List<String> gender = ["M", "F","Non specificato"];
    final appState = context.read<AppState>();
    return ViewModelBuilder<UserViewModel>.reactive(
        viewModelBuilder: () => UserViewModel(context, VMType.edit, widget.id),
        onViewModelReady: (vm) async => await vm.initialize(pageActions: [
              PageAction(
                  title: "Salva",
                  isMain: true,
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      await vm.updateUser(widget.id);
                      context.read<AppState>().markForRefresh();
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
                            contentMargin: EdgeInsets.symmetric(horizontal: Sizes.padding),
                            child: Column(
                              children: [
                                ResponsiveGrid(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  gridSpacing: Sizes.padding,
                                  children: [
                                    ResponsiveGridItem(
                                      lg: 33,
                                      xs: 100,
                                      child: CLTextField(
                                        controller: vm.firstNameTEC,
                                        labelText: "Nome",
                                        capitalize: true,
                                        validators: [Validators.required],
                                      ),
                                    ),
                                    ResponsiveGridItem(
                                      lg: 33,
                                      xs: 100,
                                      child: CLTextField(controller: vm.lastNameTEC, labelText: "Cognome", validators: [Validators.required],capitalize: true,),
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
                                        valueToShow: (item) => item,
                                        onSelectItem: (item) {
                                          vm.selectedGender = item;
                                        },
                                        hint: "Seleziona un genere",
                                        selectedValues: vm.selectedGender,
                                        itemBuilder: (context, item) => Text(item),
                                      ),
                                    ),

                                    ResponsiveGridItem(
                                      lg: 33,
                                      xs: 100,
                                      child: CLTextField.date(
                                        controller: vm.birthDateTEC,
                                        labelText: "Data di nascita",
                                        validators: [Validators.required],
                                        onDateTimeSelected: (date) {
                                          vm.selectedDate = date;
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
                                            valueToShow: (item) => item.name,
                                            selectedValues: vm.selectedCity, // o selectedValue se la tua API lo prevede
                                            onSelectItem: (item) {
                                              setState(() {
                                                vm.selectedCity = item;

                                                // ⚠️ Nuova lista, niente clear/addAll sulla stessa istanza
                                                vm.zips = (item?.zips ?? const <String>[]).toList();

                                                // Reset della selezione CAP
                                                vm.selectedZip = null;
                                              });
                                            },
                                            hint: "Residenza",
                                            itemBuilder: (context, item) => Text(item.name),
                                          ),
                                        ],
                                      ),
                                    ),

                                    ResponsiveGridItem(
                                      lg: 33,
                                      xs: 100,
                                      child: CLDropdown<String>.singleSync(
                                        // 🔑 Forza il rebuild quando cambia la city
                                        key: ValueKey(vm.selectedCity?.name ?? 'no-city'),
                                        items: vm.zips, // è una NUOVA lista ad ogni cambio city
                                        validators: [Validators.required],
                                        valueToShow: (zip) => zip,
                                        onSelectItem: (zip) {
                                          setState(() {
                                            vm.selectedZip = zip;
                                          });
                                        },
                                        selectedValues: vm.selectedZip, // o selectedValue se la tua API lo prevede
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
                                        validators: [Validators.required, Validators.email],
                                        isEnabled: false,
                                      ),
                                    ),
                                    ResponsiveGridItem(
                                      lg: 33,
                                      xs: 100,
                                      child: CLTextField(controller: vm.phoneTEC, labelText: "Telefono", validators: [Validators.required]),
                                    ),
                                    ResponsiveGridItem(lg: 33,xs: 100),
                                    ResponsiveGridItem(
                                      lg: 100,
                                      xs: 100,
                                      child: Column(
                                        children: [
                                          CLDropdown<Role>.singleAsync(
                                            validators: [Validators.required],
                                            searchCallback: vm.getAllRole,
                                            searchColumn: "name",
                                            valueToShow: (item) {
                                              return item.name;
                                            },
                                            selectedValues: vm.selectedRole,
                                            onSelectItem: (item) {
                                              vm.selectedRole = item;
                                            },
                                            hint: "Ruolo",
                                            itemBuilder: (context, item) {
                                              return Text(item.name);
                                            },
                                          ),
                                        ],
                                      ),
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
