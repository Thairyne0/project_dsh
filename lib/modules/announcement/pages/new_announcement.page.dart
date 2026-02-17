import 'package:flutter/cupertino.dart';
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
import '../viewmodels/announcement.viewmodel.dart';

class NewAnnouncementPage extends StatefulWidget {
  const NewAnnouncementPage({super.key});

  @override
  createState() => NewAnnouncementPageState();
}

class NewAnnouncementPageState extends State<NewAnnouncementPage> with TickerProviderStateMixin {
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
    return ViewModelBuilder<AnnouncementViewModel>.reactive(
        viewModelBuilder: () => AnnouncementViewModel(context, VMType.create, null),
        onViewModelReady: (vm) async => await vm.initialize(pageActions: [
              PageAction(
                  title: "Salva",
                  isMain: true,
                  onTap: () async {
                    if (_formKey.currentState!.validate()) {
                      await vm.createAnnouncement();
                      appState.refreshList.add(true);
                      context.pop();
                    }
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
                                    lg: 100,
                                    xs: 100,
                                    child: CLTextField(controller: vm.titleTEC, labelText: "Titolo", validators: [Validators.required], isRequired: true),
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
                                    lg: 25,
                                    xs: 100,
                                    child: ClFilePicker.multiple(
                                      allowedExtensions: ['jpg', 'jpeg', 'png'],
                                      onFilesPicked: (files) {
                                        setState(() {
                                          vm.mediaFiles = files;
                                        });
                                      },
                                    ),
                                  )
                                  /*  ResponsiveGridItem(
                                    lg: 50,
                                    xs: 100,
                                    child: ClFilePicker.single(
                                      initialFile: vm.imageFile,
                                      allowedExtensions: ['jpg', 'jpeg', 'png'],
                                      onPickedFile: (file) async {
                                        setState(() {
                                          vm.imageFile = file;
                                        });
                                      },
                                    ),
                                  ),*/
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
