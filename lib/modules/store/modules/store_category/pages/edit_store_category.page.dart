import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import '../../../../../ui/layout/constants/sizes.constant.dart';
import '../../../../../ui/widgets/cl_container.widget.dart';
import '../../../../../ui/widgets/cl_file_picker.widget.dart';
import '../../../../../ui/widgets/cl_media_viewer.widget.dart';
import '../../../../../ui/widgets/cl_responsive_grid/flutter_responsive_flex_grid.dart';
import '../../../../../ui/widgets/cl_text_field.widget.dart';
import '../../../../../ui/widgets/loading.widget.dart';
import '../../../../../ui/widgets/textfield_validator.dart';
import '../../../../../utils/base.viewmodel.dart';
import '../../../../../utils/models/pageaction.model.dart';
import '../../../../../utils/providers/appstate.util.provider.dart';
import '../viewmodels/store_category.viewmodel.dart';

class EditStoreCategoryPage extends StatefulWidget {
  const EditStoreCategoryPage({super.key, required this.id});

  final String id;


  @override
  State<EditStoreCategoryPage> createState() => EditStoreCategoryPageState();
}

class EditStoreCategoryPageState extends State<EditStoreCategoryPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  bool imageAvailable = false;

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();
    return ViewModelBuilder<StoreCategoryViewModel>.reactive(
        viewModelBuilder: () => StoreCategoryViewModel(context, VMType.edit, widget.id),
        onViewModelReady: (vm) async => await vm.initialize(pageActions: [
          PageAction(
              title: "Salva",
              isMain: true,
              onTap: () async {
                if (_formKey.currentState!.validate()) {
                  await vm.updateStoreCategory(widget.id);
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
                            ResponsiveGridItem(
                              lg: 25,
                              xs: 100,
                              child: CLTextField(controller: vm.nameTEC, labelText: "Nome",validators: [Validators.required]),
                            ),
                            ResponsiveGridItem(
                              lg: 25,
                              xs: 100,
                              child: ClFilePicker.single(
                                initialFile: CLMedia(fileUrl: vm.storeCategory.imageUrl),
                                allowedExtensions: ['jpg', 'jpeg', 'png'],
                                onPickedFile: (file) async {
                                  setState(() {
                                    vm.imageFile = file;
                                  });
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
