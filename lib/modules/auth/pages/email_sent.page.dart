import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_dsh/utils/extension.util.dart';

import '../../../ui/cl_theme.dart';
import '../../../ui/layout/constants/sizes.constant.dart';
import '../../../ui/widgets/buttons/cl_button.widget.dart';
import '../../../ui/widgets/logo.widget.dart';
import '../../welcome/constants/welcome_routes.constants.dart';

class EmailSent extends StatefulWidget {
  const EmailSent({super.key});

  @override
  State<EmailSent> createState() => _EmailSentState();
}

class _EmailSentState extends State<EmailSent> {
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
                  Text('Email inviata!', style: CLTheme.of(context).heading4.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                  SizedBox(height: Sizes.padding),
                  Text(
                    'Per procedere, controlla la tua email e segui il link che ti abbiamo inviato. Se non trovi l’email, controlla anche la cartella spam o promozioni. Per qualsiasi problema, contatta il nostro supporto.',
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
                  LogoWidget(dark: true, height: 80),
                ],
              ),
            ),
          ),
        ));
  }
}
