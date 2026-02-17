import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import '../../../../../ui/layout/constants/sizes.constant.dart';
import '../../../../../ui/widgets/cl_container.widget.dart';
import '../../../../../ui/widgets/cl_dropdown/cl_dropdown.dart';
import '../../../../../ui/widgets/cl_responsive_grid/flutter_responsive_flex_grid.dart';
import '../../../../../ui/widgets/cl_text_field.widget.dart';
import '../../../../../ui/widgets/loading.widget.dart';
import '../../../../../ui/widgets/textfield_validator.dart';
import '../../../../../utils/base.viewmodel.dart';
import '../../../../../utils/models/pageaction.model.dart';
import '../../../../../utils/providers/appstate.util.provider.dart';
import '../../../models/store.model.dart';
import '../viewmodels/location.viewmodel.dart';

class NewLocationPage extends StatefulWidget {
  const NewLocationPage({super.key});

  @override
  createState() => NewLocationPageState();
}

class NewLocationPageState extends State<NewLocationPage> with TickerProviderStateMixin {
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
        viewModelBuilder: () => LocationViewModel(context, VMType.create, null),
        onViewModelReady: (vm) async => await vm.initialize(pageActions: [PageAction(
            title: "Salva",
            isMain: true,
            onTap: () async {
              if (_formKey.currentState!.validate()) {
                await vm.createLocation();
              appState.refreshList.add(true);
              context.pop();}
            }),]),
        builder: (context, vm, child) {
          return vm.isBusy ? const LoadingWidget() :
          CustomScrollView(
              slivers: [
          SliverPadding(
          padding: const EdgeInsets.only(top: Sizes.headerOffset),
          sliver: SliverToBoxAdapter(
          child: Form(
              key: _formKey,
              child: CLContainer(
                contentMargin: const EdgeInsets.symmetric(horizontal: Sizes.padding),
                child: Column(
                      children: [
                        ResponsiveGrid(
                          gridSpacing: Sizes.padding,
                          children: [
                            ResponsiveGridItem(
                              lg: 25,
                              xs: 100,
                              child:CLTextField(controller: vm.nameTEC, labelText: "Nome",validators: [Validators.required],isRequired: true),
                            ),
                            ResponsiveGridItem(
                              lg: 25,
                              xs: 100,
                              child:CLTextField(controller: vm.civicTEC, labelText: "Civico",validators: [Validators.required],isRequired: true),
                            ),
                            ResponsiveGridItem(
                              lg: 25,
                              xs: 100,
                              child:CLTextField(controller: vm.poiIdTEC, labelText: "Numero POI",validators: [Validators.required],isRequired: true),
                            ),
                            ResponsiveGridItem(
                              lg: 25,
                              xs: 100,
                              child: CLTextField.date(
                                controller: vm.startValidityAtTEC,
                                isRequired: true,
                                labelText: "Data inizio Validità",
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
                                controller: vm.startValidityAtTEC,
                                isRequired: true,
                                labelText: "Data fine Validità",
                                validators: [Validators.required],
                                withTime: false,
                                onDateTimeSelected: (picked) {
                                  vm.selectedEndValidityAt = picked;
                                },
                              ),
                            ),
                            ResponsiveGridItem(
                              lg: 25,
                              xs: 100,
                              child:CLTextField(controller: vm.sqTEC, labelText: "Metri quadri",validators: [Validators.required]),
                            ),
                            ResponsiveGridItem(
                                lg: 50,
                                xs: 100,
                                child: Column(
                                  children: [
                                    CLDropdown<Store>.singleAsync(
                                      validators: [Validators.required],
                                      searchCallback: vm.getAllStore,
                                      searchColumn: "name",
                                      valueToShow: (item) => item.modelIdentifier,
                                      onSelectItem: (item) {
                                        vm.selectedStore = item!;
                                      },
                                      hint: "Seleziona uno store",
                                      itemBuilder: (context, item) {
                                        return Text(item.modelIdentifier);
                                      },
                                    )
                                  ],
                                )),
                          ],
                        ),
                      ],
                    ),
                  )
            ),
          ))]);
        });
  }
}
