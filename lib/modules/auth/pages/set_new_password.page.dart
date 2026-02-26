import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import '../../../ui/cl_theme.dart';
import '../../../ui/layout/constants/sizes.constant.dart';
import '../../../ui/widgets/alertmanager/alert_manager.dart';
import '../../../ui/widgets/buttons/cl_button.widget.dart';
import '../../../ui/widgets/cl_text_field.widget.dart';
import '../../../ui/widgets/loading.widget.dart';

import '../../../ui/widgets/textfield_validator.dart';
import '../../../utils/base.viewmodel.dart';
import '../viewmodels/password.viewmodel.dart';

class SetNewPasswordPage extends StatefulWidget {
  const SetNewPasswordPage({super.key, required this.code});

  final String code;

  @override
  State<SetNewPasswordPage> createState() => _SetNewPasswordPageState();
}

class _SetNewPasswordPageState extends State<SetNewPasswordPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PasswordViewModel>.reactive(
        viewModelBuilder: () => PasswordViewModel(context, VMType.other, widget.code),
        onViewModelReady: (vm) async => await vm.initialize(),
        builder: (context, vm, child) {
          return Scaffold(
            resizeToAvoidBottomInset: true,
            body: vm.isBusy
                ? LoadingWidget()
                : Form(
                    key: _formKey,
                    child: GestureDetector(
                      onTap: () => FocusScope.of(context).unfocus(),
                      child: Container(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: Sizes.padding),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                GestureDetector(
                                    onTap: () => Navigator.pop(context),
                                    child: Container(
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: CLTheme.of(context).primary.withValues(alpha: 0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(Icons.dashboard_rounded, color: CLTheme.of(context).primary, size: 48),
                                    )),
                                SizedBox(height: Sizes.padding),
                                CLTextField.password(controller: vm.newPasswordTEC, labelText: 'Nuova password', validators: [Validators.required]),
                                SizedBox(height: Sizes.padding),
                                CLTextField.password(controller: vm.confirmNewPasswordTEC, labelText: 'Conferma password', validators: [Validators.required]),
                                SizedBox(height: Sizes.padding),
                                CLButton.primary(
                                    text: 'Conferma',
                                    onTap: () async {
                                      if (_formKey.currentState!.validate()) {
                                        if (vm.newPasswordTEC.text != vm.confirmNewPasswordTEC.text) {
                                          AlertManager.showWarning('Attenzione!', 'Le due password non corrispondono');
                                        } else {
                                          await vm.resetPassword();
                                        }
                                      }
                                    },
                                    context: context)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
          );
        });
  }
}
