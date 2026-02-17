import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:stacked/stacked.dart';
import 'package:project_dsh/ui/cl_theme.dart';
import 'package:project_dsh/ui/widgets/cl_responsive_grid/flutter_responsive_flex_grid.dart';
import 'package:project_dsh/ui/widgets/cl_text_field.widget.dart';
import '../../../ui/layout/constants/sizes.constant.dart';
import '../../../ui/widgets/cl_container.widget.dart';
import '../../../ui/widgets/cl_dropdown/cl_dropdown.dart';
import '../../../ui/widgets/loading.widget.dart';
import '../../../ui/widgets/textfield_validator.dart';
import '../../../utils/base.viewmodel.dart';
import '../../../utils/models/pageaction.model.dart';
import '../../../utils/providers/appstate.util.provider.dart';
import '../modules/brand/models/brand.model.dart';
import '../viewmodels/store.viewmodel.dart';

class NewStorePage extends StatefulWidget {
  const NewStorePage({super.key});

  @override
  createState() => NewStorePageState();
}

class NewStorePageState extends State<NewStorePage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  bool imageAvailable = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();
    return ViewModelBuilder<StoreViewModel>.reactive(
        viewModelBuilder: () => StoreViewModel(context, VMType.create, null),
        onViewModelReady: (vm) async => await vm.initialize(pageActions: [
              PageAction(
                  title: "Salva",
                  isMain: true,
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      await vm.createStore();
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
                                          lg: 25,
                                          xs: 100,
                                          child: Column(
                                            children: [
                                              CLDropdown<Brand>.singleAsync(
                                                validators: [Validators.required],
                                                searchCallback: vm.getAllBrand,
                                                searchColumn: "name",
                                                valueToShow: (item) {
                                                  return item.modelIdentifier;
                                                },
                                                onSelectItem: (item) {
                                                  vm.selectedBrand = item;
                                                },
                                                hint: "Seleziona un Brand",
                                                itemBuilder: (context, item) {
                                                  return Text(item.modelIdentifier);
                                                },
                                              ),
                                            ],
                                          )),
                                      ResponsiveGridItem(
                                        lg: 25,
                                        xs: 100,
                                        child: CLTextField(
                                            controller: vm.nameTEC, labelText: "Ragione sociale", validators: [Validators.required], isRequired: true),
                                      ),
                                      ResponsiveGridItem(
                                        lg: 25,
                                        xs: 100,
                                        child: CLTextField(
                                            controller: vm.emailTEC, labelText: "Email"),
                                      ),

                                      ResponsiveGridItem(
                                        lg: 25,
                                        xs: 100,
                                        child: CLTextField(
                                            controller: vm.pecTEC, labelText: "PEC", ),
                                      ),
                                      ResponsiveGridItem(
                                        lg: 33,
                                        xs: 100,
                                        child: CLTextField(controller: vm.phoneTEC, labelText: "Telefono",),
                                      ),
                                      ResponsiveGridItem(
                                        lg: 33,
                                        xs: 100,
                                        child:
                                            CLTextField(controller: vm.pivaTEC, labelText: "Partita Iva", validators: [Validators.required], isRequired: true),
                                      ),
                                      ResponsiveGridItem(
                                        lg: 33,
                                        xs: 100,
                                        child: CLTextField(
                                            controller: vm.legalAddressTEC, labelText: "Indirizzo Legale", validators: [Validators.required], isRequired: true),
                                      ),

                                      /*ResponsiveGridItem(
                                        lg: 100,
                                        xs: 100,
                                        child: ClFilePicker.single(
                                          allowedExtensions: ['jpg', 'jpeg', 'png'],
                                          onPickedFile: (file) async {
                                            setState(() {
                                              vm.imageFile = file;
                                            });
                                          },
                                        ),
                                      ),*/
                                      if (ResponsiveBreakpoints.of(context).isDesktop) ...[
                                        ResponsiveGridItem(
                                            lg: 20,
                                            xs: 100,
                                            child: Row(
                                              children: [
                                                Text(""),
                                              ],
                                            )),
                                        ResponsiveGridItem(
                                            lg: 20,
                                            xs: 100,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    "Apetura Mattina",
                                                    style: CLTheme.of(context).subTitle,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            )),
                                        ResponsiveGridItem(
                                            lg: 20,
                                            xs: 100,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    "Chiusura Mattina",
                                                    style: CLTheme.of(context).subTitle,
                                                    overflow: TextOverflow.ellipsis,

                                                  ),
                                                ),
                                              ],
                                            )),
                                        ResponsiveGridItem(
                                            lg: 20,
                                            xs: 100,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    "Apertura Pomeriggio",
                                                    style: CLTheme.of(context).subTitle,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            )),
                                        ResponsiveGridItem(
                                            lg: 20,
                                            xs: 100,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    "Chiusura Pomeriggio",
                                                    style: CLTheme.of(context).subTitle,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            )),
                                      ],
                                      ResponsiveGridItem(
                                          lg: 20,
                                          xs: 100,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  "Lunedì",
                                                  style: CLTheme.of(context).subTitle,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          )),
                                      ResponsiveGridItem(
                                          lg: 20,
                                          xs: 100,
                                          child: CLTextField.time(controller: vm.weeklySchedule[0].morningOpeningTEC, labelText: "", onTimeSelected: (TimeOfDay? time) {})),
                                      ResponsiveGridItem(
                                          lg: 20,
                                          xs: 100,
                                          child: CLTextField.time(controller: vm.weeklySchedule[0].morningClosingTEC, labelText: "", onTimeSelected: (TimeOfDay? time) {})),
                                      ResponsiveGridItem(
                                          lg: 20,
                                          xs: 100,
                                          child: CLTextField.time(controller: vm.weeklySchedule[0].eveningOpeningTEC, labelText: "", onTimeSelected: (TimeOfDay? time) {})),
                                      ResponsiveGridItem(
                                          lg: 20,
                                          xs: 100,
                                          child: CLTextField.time(controller: vm.weeklySchedule[0].eveningClosingTEC, labelText: "", onTimeSelected: (TimeOfDay? time) {})),
                                      ResponsiveGridItem(
                                          lg: 20,
                                          xs: 100,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  "Martedì",
                                                  style: CLTheme.of(context).subTitle,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          )),
                                      ResponsiveGridItem(
                                          lg: 20,
                                          xs: 100,
                                          child: CLTextField.time(controller: vm.weeklySchedule[1].morningOpeningTEC, labelText: "", onTimeSelected: (TimeOfDay? time) {})),
                                      ResponsiveGridItem(
                                          lg: 20,
                                          xs: 100,
                                          child: CLTextField.time(controller: vm.weeklySchedule[1].morningClosingTEC, labelText: "", onTimeSelected: (TimeOfDay? time) {})),
                                      ResponsiveGridItem(
                                          lg: 20,
                                          xs: 100,
                                          child: CLTextField.time(controller: vm.weeklySchedule[1].eveningOpeningTEC, labelText: "", onTimeSelected: (TimeOfDay? time) {})),
                                      ResponsiveGridItem(
                                          lg: 20,
                                          xs: 100,
                                          child: CLTextField.time(controller: vm.weeklySchedule[1].eveningClosingTEC, labelText: "", onTimeSelected: (TimeOfDay? time) {})),
                                      ResponsiveGridItem(
                                          lg: 20,
                                          xs: 100,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  "Mercoledì",
                                                  style: CLTheme.of(context).subTitle,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          )),
                                      ResponsiveGridItem(
                                          lg: 20,
                                          xs: 100,
                                          child: CLTextField.time(controller: vm.weeklySchedule[2].morningOpeningTEC, labelText: "", onTimeSelected: (TimeOfDay? time) {})),
                                      ResponsiveGridItem(
                                          lg: 20,
                                          xs: 100,
                                          child: CLTextField.time(controller: vm.weeklySchedule[2].morningClosingTEC, labelText: "", onTimeSelected: (TimeOfDay? time) {})),
                                      ResponsiveGridItem(
                                          lg: 20,
                                          xs: 100,
                                          child: CLTextField.time(controller: vm.weeklySchedule[2].eveningOpeningTEC, labelText: "", onTimeSelected: (TimeOfDay? time) {})),
                                      ResponsiveGridItem(
                                          lg: 20,
                                          xs: 100,
                                          child: CLTextField.time(controller: vm.weeklySchedule[2].eveningClosingTEC, labelText: "", onTimeSelected: (TimeOfDay? time) {})),
                                      ResponsiveGridItem(
                                          lg: 20,
                                          xs: 100,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  "Giovedì",
                                                  style: CLTheme.of(context).subTitle,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          )),
                                      ResponsiveGridItem(
                                          lg: 20,
                                          xs: 100,
                                          child: CLTextField.time(controller: vm.weeklySchedule[3].morningOpeningTEC, labelText: "", onTimeSelected: (TimeOfDay? time) {})),
                                      ResponsiveGridItem(
                                          lg: 20,
                                          xs: 100,
                                          child: CLTextField.time(controller: vm.weeklySchedule[3].morningClosingTEC, labelText: "", onTimeSelected: (TimeOfDay? time) {})),
                                      ResponsiveGridItem(
                                          lg: 20,
                                          xs: 100,
                                          child: CLTextField.time(controller: vm.weeklySchedule[3].eveningOpeningTEC, labelText: "", onTimeSelected: (TimeOfDay? time) {})),
                                      ResponsiveGridItem(
                                          lg: 20,
                                          xs: 100,
                                          child: CLTextField.time(controller: vm.weeklySchedule[3].eveningClosingTEC, labelText: "", onTimeSelected: (TimeOfDay? time) {})),
                                      ResponsiveGridItem(
                                          lg: 20,
                                          xs: 100,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  "Venerdì",
                                                  style: CLTheme.of(context).subTitle,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          )),
                                      ResponsiveGridItem(
                                          lg: 20,
                                          xs: 100,
                                          child: CLTextField.time(controller: vm.weeklySchedule[4].morningOpeningTEC, labelText: "", onTimeSelected: (TimeOfDay? time) {})),
                                      ResponsiveGridItem(
                                          lg: 20,
                                          xs: 100,
                                          child: CLTextField.time(controller: vm.weeklySchedule[4].morningClosingTEC, labelText: "", onTimeSelected: (TimeOfDay? time) {})),
                                      ResponsiveGridItem(
                                          lg: 20,
                                          xs: 100,
                                          child: CLTextField.time(controller: vm.weeklySchedule[4].eveningOpeningTEC, labelText: "", onTimeSelected: (TimeOfDay? time) {})),
                                      ResponsiveGridItem(
                                          lg: 20,
                                          xs: 100,
                                          child: CLTextField.time(controller: vm.weeklySchedule[4].eveningClosingTEC, labelText: "", onTimeSelected: (TimeOfDay? time) {})),
                                      ResponsiveGridItem(
                                          lg: 20,
                                          xs: 100,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  "Sabato",
                                                  style: CLTheme.of(context).subTitle,
                                                  overflow: TextOverflow.ellipsis,

                                                ),
                                              ),
                                            ],
                                          )),
                                      ResponsiveGridItem(
                                          lg: 20,
                                          xs: 100,
                                          child: CLTextField.time(controller: vm.weeklySchedule[5].morningOpeningTEC, labelText: "", onTimeSelected: (TimeOfDay? time) {})),
                                      ResponsiveGridItem(
                                          lg: 20,
                                          xs: 100,
                                          child: CLTextField.time(controller: vm.weeklySchedule[5].morningClosingTEC, labelText: "", onTimeSelected: (TimeOfDay? time) {})),
                                      ResponsiveGridItem(
                                          lg: 20,
                                          xs: 100,
                                          child: CLTextField.time(controller: vm.weeklySchedule[5].eveningOpeningTEC, labelText: "", onTimeSelected: (TimeOfDay? time) {})),
                                      ResponsiveGridItem(
                                          lg: 20,
                                          xs: 100,
                                          child: CLTextField.time(controller: vm.weeklySchedule[5].eveningClosingTEC, labelText: "", onTimeSelected: (TimeOfDay? time) {})),
                                      ResponsiveGridItem(
                                          lg: 20,
                                          xs: 100,
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  "Domenica",
                                                  style: CLTheme.of(context).subTitle,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          )),
                                      ResponsiveGridItem(
                                          lg: 20,
                                          xs: 100,
                                          child: CLTextField.time(controller: vm.weeklySchedule[6].morningOpeningTEC, labelText: "", onTimeSelected: (TimeOfDay? time) {})),
                                      ResponsiveGridItem(
                                          lg: 20,
                                          xs: 100,
                                          child: CLTextField.time(controller: vm.weeklySchedule[6].morningClosingTEC, labelText: "", onTimeSelected: (TimeOfDay? time) {})),
                                      ResponsiveGridItem(
                                          lg: 20,
                                          xs: 100,
                                          child: CLTextField.time(controller: vm.weeklySchedule[6].eveningOpeningTEC, labelText: "", onTimeSelected: (TimeOfDay? time) {})),
                                      ResponsiveGridItem(
                                          lg: 20,
                                          xs: 100,
                                          child: CLTextField.time(controller: vm.weeklySchedule[6].eveningClosingTEC, labelText: "", onTimeSelected: (TimeOfDay? time) {})),
                                      ResponsiveGridItem(
                                          lg: 100,
                                          xs: 100,
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: Sizes.padding),
                                            child: Row(
                                              children: [
                                                Icon(
                                                  Icons.info,
                                                  color: CLTheme.of(context).primary,
                                                  size: 30,
                                                ),
                                                SizedBox(
                                                  width: Sizes.padding,
                                                ),
                                                Flexible(
                                                    child: Text(
                                                  "Se imposti sia l’orario di apertura mattutino che quello pomeridiano, il sistema considera l’attività con una pausa tra la mattina e il pomeriggio, mentre se inserisci solo l’orario di apertura mattina e chiusura pomeriggio, senza specificare la chiusura mattutina e la riapertura pomeridiana, l’orario sarà considerato continuato; se invece non inserisci alcun orario per la mattina o per il pomeriggio, l’attività sarà considerata chiusa in quella fascia oraria.",
                                                  style: CLTheme.of(context).smallLabel.copyWith(fontStyle: FontStyle.italic),
                                                  maxLines: null,
                                                ))
                                              ],
                                            ),
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: Sizes.padding)
                          ],
                        ),
                      ),
                    ))]));
        });
  }
}
