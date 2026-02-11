import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:project_dsh/modules/users/modules/role_permission/models/permission.model.dart';
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
import '../viewmodels/role_permission.viewmodel.dart';

class AddPermissionToRolePage extends StatefulWidget {
  const AddPermissionToRolePage({super.key, required this.id});

  final String id;

  @override
  createState() => AddPermissionToRolePageState();
}

class AddPermissionToRolePageState extends State<AddPermissionToRolePage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();
    return ViewModelBuilder<RoleViewModel>.reactive(
        viewModelBuilder: () => RoleViewModel(context, VMType.other, widget.id),
        onViewModelReady: (vm) async => await vm.initialize(pageActions: [
              PageAction(
                  title: "Salva",
                  isMain: true,
                  onTap: () async {
                    if (_formKey.currentState!.validate() && vm.selectedPermission.isNotEmpty) {
                      await vm.attachPermissionToRole();
                      appState.refreshList.add(true);
                      context.pop();
                    }else{
                      AlertManager.showDanger("Errore", "Il campo dei permessi non può essere vuoto.");}
                  }),
            ]),
        builder: (context, vm, child) {
          return vm.isBusy
              ? const LoadingWidget()
              : SingleChildScrollView(
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
                                children: [
                                  ResponsiveGridItem(
                                    lg: 50,
                                    xs: 100,
                                    child: CLTextField.disabled(
                                      controller: vm.nameTEC,
                                      labelText: "Ruolo",
                                    ),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 50,
                                    xs: 100,
                                  ),
                                  ResponsiveGridItem(
                                    lg: 100,
                                    xs: 100,
                                    child: Column(
                                      children: [
                                        CLDropdown<Permission>.multipleAsync(
                                          searchCallback: vm.getAllPermissionByRole,
                                          searchColumn: "name",
                                          valueToShow: (item) {
                                            return item.modelIdentifier;
                                          },
                                          onSelectItems: (items) {
                                            vm.selectedPermission = items;
                                          },
                                          hint: "Seleziona un permesso",
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
                );
        });
  }
}
