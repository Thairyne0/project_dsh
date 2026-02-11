import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import '../../../../../ui/layout/constants/sizes.constant.dart';
import '../../../../../ui/widgets/cl_container.widget.dart';
import '../../../../../ui/widgets/cl_responsive_grid/flutter_responsive_flex_grid.dart';
import '../../../../../ui/widgets/loading.widget.dart';
import '../../../../../utils/base.viewmodel.dart';
import '../../../../../utils/models/pageaction.model.dart';
import '../../../../../utils/providers/appstate.util.provider.dart';
import '../viewmodels/store_report.viewmodel.dart';

class EditStoreReportPage extends StatefulWidget {
  const EditStoreReportPage({super.key, required this.id});

  final String id;


  @override
  State<EditStoreReportPage> createState() => EditStoreReportPageState();
}

class EditStoreReportPageState extends State<EditStoreReportPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  bool imageAvailable = false;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StoreReportViewModel>.reactive(
        viewModelBuilder: () => StoreReportViewModel(context, VMType.edit, widget.id),
        onViewModelReady: (vm) async => await vm.initialize(pageActions: [
          PageAction(
              title: "Salva",
              isMain: true,
              onTap: () async {
                if (_formKey.currentState!.validate()) {
                  await vm.updateStoreReport(widget.id);
                  context.read<AppState>().markForRefresh();
                context.pop();}
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
                    contentMargin: const EdgeInsets.symmetric(horizontal:Sizes.padding),
                    child: Column(
                      children: [
                        ResponsiveGrid(
                          gridSpacing: Sizes.padding,
                          children: [



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
