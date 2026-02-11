import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:project_dsh/ui/cl_theme.dart';
import 'package:project_dsh/ui/layout/constants/sizes.constant.dart';
import 'package:project_dsh/ui/widgets/buttons/cl_button.widget.dart';
import 'package:project_dsh/ui/widgets/cl_container.widget.dart';
import 'package:project_dsh/ui/widgets/cl_text_field.widget.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:project_dsh/utils/base.viewmodel.dart';
import 'package:project_dsh/utils/extension.util.dart';
import '../../../utils/providers/authstate.util.provider.dart';
import '../constants/auth_routes.constants.dart';
import '../viewmodels/auth.viewmodel.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    AuthState authState = context.read<AuthState>();
    return ViewModelBuilder<AuthViewModel>.reactive(
        viewModelBuilder: () => AuthViewModel(context, VMType.other, null),
        onViewModelReady: (vm) async => await vm.initialize(),
        builder: (context, vm, child) {
          return SafeArea(
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: CLTheme.of(context).primaryBackground,
                child: ResponsiveBreakpoints.of(context).isDesktop
                    ? Row(
                        children: [
                          Expanded(child: CLContainer(borderRadius: BorderRadius.zero, backgroundColor: CLTheme.of(context).secondary, child: _buildui())),
                          Expanded(
                            child: CLContainer(borderRadius: BorderRadius.zero, child: _buildSingupUi(vm, authState)),
                          ),
                        ],
                      )
                    : CLContainer(borderRadius: BorderRadius.zero, child: _buildSingupUi(vm, authState)),
              ),
            ),
          );
        });
  }

  Widget _buildui() {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 36),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(child: Image.asset("assets/images/logo_dark.png")),
              SizedBox(
                height: 100,
              ),
              Text("Gestisci facilmente tutte le operazioni", style: CLTheme.of(context).heading4.copyWith(color: Colors.white)),
              SizedBox(
                height: 20,
              ),
              Text(
                'Tieni sotto controllo le attività giornaliere del tuo centro commerciale, dai contratti degli affittuari alle richieste di manutenzione. Migliora l\'efficienza operativa con strumenti intuitivi che ti aiutano a prendere decisioni informate in tempo reale.',
                style: CLTheme.of(context).bodyLabel.copyWith(color: Colors.white.withOpacity(0.7)),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isChecked = false;

  Widget _buildSingupUi(AuthViewModel vm, AuthState authState) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              !ResponsiveBreakpoints.of(context).isDesktop
                  ? Image.asset(
                      "assets/images/logo_light.png",
                      scale: 1.5,
                    )
                  : SizedBox.shrink(),
              const SizedBox(
                height: 48,
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.start, children: [
                Text("Accedi alla dashboard", style: CLTheme.of(context).heading4, textAlign: TextAlign.center),
                Text(
                  "Amministra, Gestisci, Monitora",
                  textAlign: TextAlign.center,
                  style: CLTheme.of(context).bodyText.copyWith(color: CLTheme.of(context).secondaryText),
                ),
                Column(
                  children: [
                    SizedBox(height: Sizes.padding * 2),
                    CLTextField.icon(
                      controller: vm.emailTEC,
                      labelText: "Email",
                      icon: Icon(Icons.email_outlined, size: Sizes.medium, color: CLTheme.of(context).secondaryText),
                    ),
                    SizedBox(height: Sizes.padding * 2),
                    CLTextField.password(
                      prefix: Icon(Icons.lock_outline, size: Sizes.medium, color: CLTheme.of(context).secondaryText),
                      controller: vm.passwordTEC,
                      labelText: 'Password',
                    ),
                    SizedBox(height: Sizes.padding),
                    Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            context.customGoNamed(AuthRoutes.recoverPassword.name);
                          },
                          child: Text(
                            "Password dimenticata?",
                            style: CLTheme.of(context).bodyText.copyWith(color: CLTheme.of(context).primary),
                          ),
                        )),
                  ],
                ),
                SizedBox(height: Sizes.padding * 2),
                CLButton.primary(
                    width: 240,
                    text: "Entra",
                    onTap: () async {
                      await vm.doLogin(authState);
                    },
                    context: context),
                const SizedBox(
                  height: 32,
                ),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
