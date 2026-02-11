import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import '../../../ui/layout/constants/sizes.constant.dart';
import '../../../ui/widgets/cl_container.widget.dart';
import '../../../ui/widgets/cl_dropdown/cl_dropdown.dart';
import '../../../ui/widgets/cl_file_picker.widget.dart';
import '../../../ui/widgets/cl_responsive_grid/flutter_responsive_flex_grid.dart';
import '../../../ui/widgets/cl_text_field.widget.dart';
import '../../../ui/widgets/loading.widget.dart';
import '../../../ui/widgets/textfield_validator.dart';
import '../../../utils/base.viewmodel.dart';
import '../../../utils/models/city.model.dart';
import '../../../utils/models/pageaction.model.dart';
import '../../../utils/providers/appstate.util.provider.dart';
import '../viewmodels/profile.viewmodel.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key, required this.id});

  final String id;

  @override
  State<EditProfilePage> createState() => EditProfilePageState();
}

class EditProfilePageState extends State<EditProfilePage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  bool imageAvailable = false;

  @override
  Widget build(BuildContext context) {
    final List<String> gender = ["M", "F","Non specificato"];
    final appState = context.read<AppState>();
    return ViewModelBuilder<ProfileViewModel>.reactive(
        viewModelBuilder: () => ProfileViewModel(context, VMType.edit, widget.id),
        onViewModelReady: (vm) async => await vm.initialize(pageActions: [
              PageAction(
                  title: "Salva",
                  isMain: true,
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      await vm.updateProfile(widget.id);
                      context.read<AppState>().markForRefresh();
                      context.pop();
                    }
                  }),
            ]),
        builder: (context, vm, child) {
          return vm.isBusy
              ? LoadingWidget()
              : SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CLContainer(
                          contentMargin: const EdgeInsets.all(Sizes.padding),
                          child: Column(
                            children: [
                              ResponsiveGrid(
                                gridSpacing: Sizes.padding,
                                children: [
                                  ResponsiveGridItem(
                                    lg: 25,
                                    xs: 100,
                                    child: CLTextField(
                                      controller: vm.firstNameTEC,
                                      labelText: "Nome",
                                      validators: [Validators.required],
                                    ),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 25,
                                    xs: 100,
                                    child: CLTextField(controller: vm.lastNameTEC, labelText: "Cognome", validators: [Validators.required]),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 25,
                                    xs: 100,
                                    child: CLTextField(
                                      controller: vm.emailTEC,
                                      labelText: "Email",
                                      validators: [Validators.required, Validators.email],
                                      isEnabled: false,
                                    ),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 25,
                                    xs: 100,
                                    child: CLTextField(controller: vm.phoneTEC, labelText: "Telefono", validators: [Validators.required]),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 25,
                                    xs: 100,
                                    child: Column(
                                      children: [
                                        CLDropdown<City>.singleAsync(
                                          validators: [Validators.required],
                                          searchCallback: vm.getAllCity,
                                          searchColumn: "name",
                                          valueToShow: (item) {
                                            return item.name;
                                          },
                                          selectedValues: vm.selectedCity,
                                          onSelectItem: (item) {
                                            vm.selectedCity = item;
                                          },
                                          hint: "Residenza",
                                          itemBuilder: (context, item) {
                                            return Text(item.name);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 25,
                                    xs: 100,
                                    child: CLTextField(controller: vm.capTEC, labelText: "CAP di residenza", validators: [Validators.required]),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 25,
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
                                    lg: 25,
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
                                    lg: 50,
                                    xs: 100,
                                    child: ClFilePicker.single(
                                      initialFile: vm.imageFile,
                                      allowedExtensions: ['jpg', 'jpeg', 'png'],
                                      onPickedFile: (file) async {
                                        setState(() {
                                          vm.imageFile = file;
                                        });
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
        });
  }
}
