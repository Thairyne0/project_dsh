import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import '../../../../../ui/layout/constants/sizes.constant.dart';
import '../../../../../ui/widgets/cl_container.widget.dart';
import '../../../../../ui/widgets/cl_responsive_grid/flutter_responsive_flex_grid.dart';
import '../../../../../ui/widgets/cl_text_field.widget.dart';
import '../../../../../ui/widgets/loading.widget.dart';
import '../../../../../utils/base.viewmodel.dart';
import '../../../../../utils/models/pageaction.model.dart';
import '../../../../../utils/providers/appstate.util.provider.dart';
import '../../../ui/widgets/alertmanager/alert_manager.dart';
import '../../../ui/widgets/textfield_validator.dart';
import '../modules/location/viewmodels/location.viewmodel.dart';


class AddLocationToStorePage extends StatefulWidget {
  const AddLocationToStorePage({super.key, required this.storeId});

  final String storeId;

  @override
  createState() => AddLocationToStorePageState();
}

class AddLocationToStorePageState extends State<AddLocationToStorePage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();
    return ViewModelBuilder<LocationViewModel>.reactive(
        viewModelBuilder: () => LocationViewModel(context, VMType.other, widget.storeId),
        onViewModelReady: (vm) async => await vm.initialize(pageActions: [
          PageAction(
              title: "Salva",
              isMain: true,
              onTap: () async {
                if (_formKey.currentState!.validate()) {
                  await vm.createLocation();
                  appState.refreshList.add(true);
                  context.pop();
                }else{
                  AlertManager.showDanger("Errore", "Il campo delle categorie non può essere vuoto.");}
              }),
        ]),
        builder: (context, vm, child) {
          return vm.isBusy
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
                              lg: 100,
                              xs: 100,
                              child: CLTextField.disabled(
                                controller: vm.storeNameTEC,
                                labelText: "Nome Store",
                              ),
                            ),
                            ResponsiveGridItem(
                              lg: 25,
                              xs: 100,
                              child: CLTextField(
                                validators: [Validators.required],
                                controller: vm.nameTEC,
                                labelText: "Nome",
                              ),
                            ),
                            ResponsiveGridItem(
                              lg: 25,
                              xs: 100,
                              child: CLTextField(
                                validators: [Validators.required],
                                controller: vm.poiIdTEC,
                                labelText: "Numero Poi",
                              ),
                            ),
                            ResponsiveGridItem(
                              lg: 25,
                              xs: 100,
                              child: CLTextField(
                                validators: [Validators.required],
                                controller: vm.civicTEC,
                                labelText: "Civico",
                              ),
                            ),
                            ResponsiveGridItem(
                              lg: 25,
                              xs: 100,
                              child:CLTextField(controller: vm.sqTEC, labelText: "Metri quadri",validators: [Validators.required]),
                            ),
                            ResponsiveGridItem(
                              lg: 25,
                              xs: 100,
                              child: CLTextField.date(
                                controller: vm.startValidityAtTEC,
                                isRequired: true,
                                labelText: "Data inizio validità",
                                validators: [Validators.required],
                                withTime: false,
                                onDateTimeSelected: (picked) {
                                  vm.selectedStartValidityAt = picked;
                                },
                              ),
                            ),
                            ResponsiveGridItem(
                              lg: 25,
                              xs: 100,
                              child: CLTextField.date(
                                controller: vm.endValidityAtTEC,
                                labelText: "Data fine validità",
                                withTime: false,
                                onDateTimeSelected: (picked) {
                                  vm.selectedEndValidityAt = picked;
                                },
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
          ))]);
        });
  }
}
