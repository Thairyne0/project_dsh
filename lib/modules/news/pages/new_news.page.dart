import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import '../../../../../ui/layout/constants/sizes.constant.dart';
import '../../../../../ui/widgets/cl_container.widget.dart';
import '../../../../../ui/widgets/cl_file_picker.widget.dart';
import '../../../../../ui/widgets/cl_responsive_grid/flutter_responsive_flex_grid.dart';
import '../../../../../ui/widgets/cl_text_field.widget.dart';
import '../../../../../ui/widgets/loading.widget.dart';
import '../../../../../ui/widgets/textfield_validator.dart';
import '../../../../../utils/base.viewmodel.dart';
import '../../../../../utils/models/pageaction.model.dart';
import '../../../../../utils/providers/appstate.util.provider.dart';
import '../../../ui/cl_theme.dart';
import '../viewmodels/news.viewmodel.dart';

class NewNewsPage extends StatefulWidget {
  const NewNewsPage({Key? key}) : super(key: key);

  @override
  createState() => NewNewsPageState();
}

class NewNewsPageState extends State<NewNewsPage> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.read<AppState>();
    return ViewModelBuilder<NewsViewModel>.reactive(
        viewModelBuilder: () => NewsViewModel(context, VMType.create, null),
        onViewModelReady: (vm) async => await vm.initialize(pageActions: [
              PageAction(
                  title: "Salva",
                  isMain: true,
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      await vm.createNews();
                      appState.refreshList.add(true);
                      context.pop();
                    }
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
                                    lg: 100,
                                    xs: 100,
                                    child: CLTextField(controller: vm.titleTEC, labelText: "Titolo", validators: [Validators.required],isRequired: true),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 50,
                                    xs: 100,
                                    child: CLTextField.date(
                                      controller: vm.startingAtTEC,
                                      labelText: "Data inizio",
                                      withTime: false,
                                      validators: [Validators.required],
                                      isRequired: true,
                                      onDateTimeSelected: (picked) {
                                        vm.selectedStartingAtDate = picked;
                                      },
                                    ),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 50,
                                    xs: 100,
                                    child: CLTextField.date(
                                      controller: vm.endingAtTEC,
                                      labelText: "Data Fine",
                                      withTime: false,
                                      validators: [Validators.required],
                                      isRequired: true,
                                      onDateTimeSelected: (picked) {
                                        vm.selectedEndingAtDate = picked;
                                      },
                                    ),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 100,
                                    xs: 100,
                                    child: CLTextField.quill(
                                      quillController: vm.descriptionTEC,
                                      labelText: "Descrizione",
                                      validators: [Validators.required],
                                      isRequired: true,
                                    ),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 50,
                                    xs: 100,
                                    child: ClFilePicker.single(
                                      allowedExtensions: ['jpg', 'jpeg', 'png'],
                                      onPickedFile: (file) async {
                                        setState(() {
                                          vm.imageFile = file;
                                        });
                                      },
                                    ),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 100,
                                    xs: 100,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: Checkbox(
                                            activeColor: CLTheme.of(context).secondary,
                                            splashRadius: 0,
                                            value: vm.isHighlighted,
                                            onChanged: (bool? newValue) {
                                              vm.setIsHighlighted(newValue!);
                                            },
                                          ),
                                        ),
                                        SizedBox(width: 8),
                                        Text('In evidenza?', style: CLTheme.of(context).bodyLabel),
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
