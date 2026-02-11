import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_dsh/utils/extension.util.dart';


import '../../../../ui/cl_theme.dart';
import '../../../../ui/layout/constants/sizes.constant.dart';
import '../../../../ui/widgets/buttons/cl_button.widget.dart';
import '../../../../ui/widgets/logo.widget.dart';
import '../../welcome/constants/welcome_routes.constants.dart';

class ConfirmNewPassword extends StatefulWidget {
  const ConfirmNewPassword({super.key});

  @override
  State<ConfirmNewPassword> createState() => _ConfirmNewPasswordState();
}

class _ConfirmNewPasswordState extends State<ConfirmNewPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Container(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(Sizes.padding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset('assets/icons/check.svg', height: 100),
                  SizedBox(height: Sizes.padding * 2),
                  Text('Password aggiornata con successo!', style: CLTheme.of(context).heading4.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                  SizedBox(height: Sizes.padding),
                  Text(
                    'Potrai effettuare l\accesso utilizzando le credenziali aggiornate.',
                    style: CLTheme.of(context).bodyText.copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: Sizes.padding * 2),
                  CLButton.primary(
                      text: 'Vai al login',
                      onTap: () {
                        context.customGoNamed(WelcomeRoutes.welcome.name);
                      },
                      context: context),
                  SizedBox(height: Sizes.padding * 2),
                  LogoWidget(dark:true,height: 80),
                ],
              ),
            ),
          ),
        ));
  }
}
