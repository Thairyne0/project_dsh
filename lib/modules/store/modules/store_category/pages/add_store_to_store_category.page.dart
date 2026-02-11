import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import '../../../../../ui/layout/constants/sizes.constant.dart';
import '../../../../../ui/widgets/alertmanager/alert_manager.dart';
import '../../../../../ui/widgets/cl_container.widget.dart';
import '../../../../../ui/widgets/cl_dropdown/cl_dropdown.dart';
import '../../../../../ui/widgets/cl_responsive_grid/flutter_responsive_flex_grid.dart';
import '../../../../../ui/widgets/cl_text_field.widget.dart';
import '../../../../../ui/widgets/loading.widget.dart';
import '../../../../../utils/base.viewmodel.dart';
import '../../../../../utils/models/pageaction.model.dart';
import '../../../../../utils/providers/appstate.util.provider.dart';
import '../../../models/store.model.dart';
import '../viewmodels/store_category.viewmodel.dart';


class AddStoreToStoreCategoryPage extends StatefulWidget {
  const AddStoreToStoreCategoryPage({super.key, required this.id});

  final String id;

  @override
  createState() => AddStoreToStoreCategoryPageState();
}

class AddStoreToStoreCategoryPageState extends State<AddStoreToStoreCategoryPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();
    return ViewModelBuilder<StoreCategoryViewModel>.reactive(
        viewModelBuilder: () => StoreCategoryViewModel(context, VMType.other, widget.id),
        onViewModelReady: (vm) async => await vm.initialize(pageActions: [
          PageAction(
              title: "Salva",
              isMain: true,
              onTap: () async {
                if (_formKey.currentState!.validate() && vm.selectedStores.isNotEmpty) {
                  await vm.attachStoreToStoreCategory();
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
                              lg: 25,
                              xs: 100,
                              child: CLTextField.disabled(
                                controller: vm.nameTEC,
                                labelText: "Nome",
                              ),
                            ),
                            ResponsiveGridItem(
                              lg: 100,
                              xs: 100,
                              child: Column(
                                children: [
                                  CLDropdown<Store>.multipleAsync(
                                    searchCallback: vm.getAllStoreByStoreCategory,
                                    searchColumn: "name",
                                    valueToShow: (item) {
                                      return item.modelIdentifier;
                                    },
                                    onSelectItems: (items) {
                                      vm.selectedStores = items;
                                    },
                                    hint: "Seleziona uno store",
                                    itemBuilder: (context, item) {
                                      return Text(item.modelIdentifier);
                                    },
                                  )
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
          ))]);
        });
  }
}
