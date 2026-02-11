import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:stacked/stacked.dart';
import 'package:project_dsh/modules/welcome/constants/welcome_routes.constants.dart';
import 'package:project_dsh/utils/extension.util.dart';

import '../../../ui/cl_theme.dart';
import '../../../ui/layout/constants/sizes.constant.dart';
import '../../../ui/widgets/buttons/cl_button.widget.dart';
import '../../../ui/widgets/cl_container.widget.dart';
import '../../../ui/widgets/cl_text_field.widget.dart';
import '../../../ui/widgets/logo.widget.dart';
import '../../../ui/widgets/textfield_validator.dart';
import '../../../utils/base.viewmodel.dart';
import '../constants/auth_routes.constants.dart';
import '../viewmodels/auth.viewmodel.dart';

class RecoverPasswordPage extends StatefulWidget {
  const RecoverPasswordPage({super.key});

  @override
  State<RecoverPasswordPage> createState() => _RecoverPasswordPageState();
}

class _RecoverPasswordPageState extends State<RecoverPasswordPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AuthViewModel>.reactive(
        viewModelBuilder: () => AuthViewModel(context, VMType.list, null),
        onViewModelReady: (vm) async => await vm.initialize(),
        builder: (context, vm, child) {
          return Scaffold(
            resizeToAvoidBottomInset: true,
            body: Form(
              key: _formKey,
              child: GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Container(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                            onTap: (){
                              context.customGoNamed(WelcomeRoutes.welcome.name);
                            },
                            child: SvgPicture.asset(
                              'assets/icons/close.svg',
                              height: 30,
                            )),
                        SizedBox(height: Sizes.padding),
                        LogoWidget(
                          dark: true,
                          height: 120,
                        ),
                        CLContainer(
                          contentMargin: EdgeInsets.all(Sizes.padding),
                          backgroundColor: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(Sizes.padding),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                    textAlign: TextAlign.center,
                                    'Recupera la tua password',
                                    style: CLTheme.of(context).heading4.copyWith(color: Colors.black, fontWeight: FontWeight.bold)),
                                SizedBox(height: Sizes.padding),
                                Text(
                                    textAlign: TextAlign.center,
                                    'Inserisci il tuo indirizzo email e ti invieremo un link per reimpostare la tua password.',
                                    style: CLTheme.of(context).bodyText),
                                SizedBox(height: Sizes.padding),
                                CLTextField(controller: vm.emailTEC, labelText: 'E-mail', validators: [Validators.required]),
                                SizedBox(height: Sizes.padding),
                                CLButton.primary(
                                  width: double.infinity,
                                  text: 'Invia link di reset',
                                  onTap: () async {
                                    if (_formKey.currentState!.validate()) {
                                      await vm.recoverPassword(vm.emailTEC.text);
                                      context.goNamed(AuthRoutes.emailSent.name);
                                    }
                                  },
                                  // textStyle: CLTheme.of(context).bodyText.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                                  context: context,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
