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
import '../../../../../ui/widgets/textfield_validator.dart';
import '../../../../../utils/base.viewmodel.dart';
import '../../../../../utils/models/pageaction.model.dart';
import '../../../../../utils/providers/appstate.util.provider.dart';

import '../../../ui/widgets/alertmanager/alert_manager.dart';
import '../../../ui/widgets/cl_dropdown/cl_dropdown.dart';
import '../../users/models/user.model.dart';
import '../viewmodels/store.viewmodel.dart';

class AddStoreEmployeePage extends StatefulWidget {
  const AddStoreEmployeePage({super.key, required this.id});

  final String id;

  @override
  createState() => AddStoreEmployeePageState();
}

class AddStoreEmployeePageState extends State<AddStoreEmployeePage> with TickerProviderStateMixin {
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
        viewModelBuilder: () => StoreViewModel(context, VMType.edit, widget.id),
        onViewModelReady: (vm) async => await vm.initialize(pageActions: [
          PageAction(
              title: "Salva",
              isMain: true,
              onTap: () async {
                if (_formKey.currentState!.validate() && vm.selectedUser.isNotEmpty) {
                  await vm.attachUserStore();
                  appState.refreshList.add(true);
                  context.pop();
                }else{
                  AlertManager.showDanger("Errore", "Il campo degli utenti non può essere vuoto.");}
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
                    contentMargin: const EdgeInsets.all(Sizes.padding),
                    child: Column(
                      children: [
                        ResponsiveGrid(
                          gridSpacing: Sizes.padding,
                          children: [
                            ResponsiveGridItem(
                              lg: 50,
                              xs: 100,
                              child: CLTextField.disabled(controller: vm.nameTEC, labelText: "Store", validators: [Validators.required],isRequired: true),
                            ),
                            ResponsiveGridItem(
                              lg: 50,
                              xs: 100,
                              child: Column(
                                children: [
                                  CLDropdown<User>.multipleAsync(
                                    searchCallback: vm.getAllUser,
                                    searchColumn: "userData:firstName || userData:lastName",
                                    valueToShow: (item) {
                                      return item.modelIdentifier;
                                    },
                                    onSelectItems: (items) {
                                      vm.selectedUser = items;
                                    },
                                    hint: "Seleziona un utente",
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
