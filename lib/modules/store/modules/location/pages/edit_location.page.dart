import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import '../../../../../ui/layout/constants/sizes.constant.dart';
import '../../../../../ui/widgets/cl_container.widget.dart';
import '../../../../../ui/widgets/cl_responsive_grid/flutter_responsive_flex_grid.dart';
import '../../../../../ui/widgets/cl_text_field.widget.dart';
import '../../../../../ui/widgets/loading.widget.dart';
import '../../../../../ui/widgets/textfield_validator.dart';
import '../../../../../utils/base.viewmodel.dart';
import '../../../../../utils/models/pageaction.model.dart';
import '../../../../../utils/providers/appstate.util.provider.dart';
import '../viewmodels/location.viewmodel.dart';

class EditLocationPage extends StatefulWidget {
  const EditLocationPage({super.key, required this.locationId});

  final String locationId;

  @override
  State<EditLocationPage> createState() => _EditLocationPageState();
}

class _EditLocationPageState extends State<EditLocationPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LocationViewModel>.reactive(
        viewModelBuilder: () => LocationViewModel(context, VMType.edit,widget.locationId),
        onViewModelReady: (vm) async => await vm.initialize(pageActions: [
          PageAction(
              title: "Salva",
              isMain: true,
              onTap: () async {
                if (_formKey.currentState!.validate()) {
                  await vm.updateLocation(widget.locationId);
                  context.read<AppState>().markForRefresh();
                context.pop();}
              }),
        ]),
        builder: (context, vm, child) {
          return vm.isBusy ? LoadingWidget()
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
                    contentMargin: const EdgeInsets.all(Sizes.padding),
                    child: Column(
                      children: [
                        ResponsiveGrid(
                          gridSpacing: Sizes.padding,
                          children: [
                            ResponsiveGridItem(
                              lg: 100,
                              xs: 100,
                              child: CLTextField.disabled(controller: vm.storeNameTEC, labelText: "Nome Store",validators: [Validators.required]),
                            ),
                            ResponsiveGridItem(
                              lg: 25,
                              xs: 100,
                              child: CLTextField(controller: vm.nameTEC, labelText: "Nome location",validators: [Validators.required]),
                            ),
                            ResponsiveGridItem(
                              lg: 25,
                              xs: 100,
                              child: CLTextField(controller: vm.civicTEC, labelText: "Civico",validators: [Validators.required]),
                            ),
                            ResponsiveGridItem(
                              lg: 25,
                              xs: 100,
                              child: CLTextField(controller: vm.poiIdTEC, labelText: "Numero POI",validators: [Validators.required]),
                            ),
                            ResponsiveGridItem(
                              lg: 25,
                              xs: 100,
                              child: CLTextField(controller: vm.sqTEC, labelText: "Metri quadri",validators: [Validators.required]),
                            ),
                            ResponsiveGridItem(
                              lg: 25,
                              xs: 100,
                              child: CLTextField.date(
                                  controller: vm.startValidityAtTEC,
                                  labelText: "Data inizio validità",
                                  initialSelectedDateTime: vm.selectedStartValidityAt,
                                  validators: [Validators.required],
                                  withTime: false,
                                  onDateTimeSelected: (date) {
                                    vm.selectedStartValidityAt = date;
                                  }),
                            ),
                            ResponsiveGridItem(
                              lg: 25,
                              xs: 100,
                              child: CLTextField.date(
                                  controller: vm.endValidityAtTEC,
                                  labelText: "Data fine validità",
                                  initialSelectedDateTime: vm.selectedEndValidityAt,
                                  withTime: false,
                                  onDateTimeSelected: (date) {
                                    vm.selectedEndValidityAt = date;
                                  }),
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
