import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:project_dsh/ui/widgets/cl_media_viewer.widget.dart';
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
import '../viewmodels/news.viewmodel.dart';

class EditNewsPage extends StatefulWidget {
  const EditNewsPage({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  createState() => EditNewsPageState();
}

class EditNewsPageState extends State<EditNewsPage> with TickerProviderStateMixin {
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
        viewModelBuilder: () => NewsViewModel(context, VMType.edit, widget.id),
        onViewModelReady: (vm) async => await vm.initialize(pageActions: [
              PageAction(
                  title: "Salva",
                  isMain: true,
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      await vm.updateNews(widget.id);
                      context.read<AppState>().markForRefresh();
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
                                    lg: 33,
                                    xs: 100,
                                    child: CLTextField(controller: vm.titleTEC, labelText: "Titolo", validators: [Validators.required]),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 33,
                                    xs: 100,
                                    child: CLTextField.date(
                                        controller: vm.startingAtTEC,
                                        labelText: "Data inizio",
                                        validators: [Validators.required],
                                        withTime: false,
                                        initialSelectedDateTime: vm.selectedStartingAtDate,
                                        onDateTimeSelected: (date) {
                                          vm.selectedStartingAtDate = date;
                                        }),
                                  ),
                                  ResponsiveGridItem(
                                    lg: 33,
                                    xs: 100,
                                    child: CLTextField.date(
                                        controller: vm.endingAtTEC,
                                        labelText: "Data fine",
                                        validators: [Validators.required],
                                        withTime: false,
                                        initialSelectedDateTime: vm.selectedEndingAtDate,
                                        onDateTimeSelected: (date) {
                                          vm.selectedEndingAtDate = date;
                                        }),
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
                                      initialFile: CLMedia(fileUrl: vm.news.imageUrl),
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
                                      children: [
                                        Checkbox(
                                          value: vm.isHighlighted,
                                          onChanged: (bool? newValue) {
                                            setState(() {
                                              vm.isHighlighted = newValue ?? false;
                                            });
                                          },
                                        ),
                                        const Text('In evidenza?'),
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
