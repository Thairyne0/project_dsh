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
          final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;
          return SafeArea(
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: CLTheme.of(context).primaryBackground,
                child: isDesktop
                    ? Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    CLTheme.of(context).secondary,
                                    CLTheme.of(context).secondary.withValues(alpha: 0.85),
                                    CLTheme.of(context).primary.withValues(alpha: 0.9),
                                  ],
                                ),
                              ),
                              child: _buildBrandPanel(),
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: CLContainer(
                              borderRadius: BorderRadius.zero,
                              showBorder: false,
                              child: _buildLoginForm(vm, authState),
                            ),
                          ),
                        ],
                      )
                    : CLContainer(
                        borderRadius: BorderRadius.zero,
                        showBorder: false,
                        child: _buildLoginForm(vm, authState),
                      ),
              ),
            ),
          );
        });
  }

  Widget _buildBrandPanel() {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 56, vertical: 48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.dashboard_rounded, color: Colors.white, size: 48),
              ),
              const SizedBox(height: 64),
              Text(
                "Gestisci facilmente\ntutte le operazioni",
                style: CLTheme.of(context).heading3.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Container(
                width: 48,
                height: 3,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Text(
                  'Tieni sotto controllo le attività giornaliere del tuo centro commerciale, dai contratti degli affittuari alle richieste di manutenzione.',
                  style: CLTheme.of(context).bodyText.copyWith(
                        color: Colors.white.withValues(alpha: 0.75),
                        height: 1.6,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 48),
              // Feature highlights
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 360),
                child: Column(
                  children: [
                    _buildFeatureRow(Icons.analytics_outlined, "Monitoraggio in tempo reale"),
                    const SizedBox(height: 20),
                    _buildFeatureRow(Icons.assignment_outlined, "Gestione contratti e affitti"),
                    const SizedBox(height: 20),
                    _buildFeatureRow(Icons.build_outlined, "Richieste di manutenzione"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String text) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.white.withValues(alpha: 0.9), size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: CLTheme.of(context).bodyText.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontWeight: FontWeight.w500,
                ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm(AuthViewModel vm, AuthState authState) {
    final isDesktop = ResponsiveBreakpoints.of(context).isDesktop;
    final horizontalPadding = isDesktop
        ? MediaQuery.of(context).size.width * 0.06
        : MediaQuery.of(context).size.width * 0.08;

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!isDesktop) ...[
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: CLTheme.of(context).primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.dashboard_rounded, color: CLTheme.of(context).primary, size: 40),
                    ),
                  ),
                  const SizedBox(height: 48),
                ],
                // Header
                Text(
                  "Bentornato",
                  style: CLTheme.of(context).heading4.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                  textAlign: isDesktop ? TextAlign.left : TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  "Accedi alla dashboard per gestire le tue operazioni",
                  style: CLTheme.of(context).bodyText.copyWith(
                        color: CLTheme.of(context).secondaryText,
                        height: 1.5,
                      ),
                  textAlign: isDesktop ? TextAlign.left : TextAlign.center,
                ),
                const SizedBox(height: 36),
                // Form fields
                CLTextField.icon(
                  controller: vm.emailTEC,
                  labelText: "Email",
                  icon: Icon(Icons.email_outlined, size: Sizes.medium, color: CLTheme.of(context).secondaryText),
                ),
                const SizedBox(height: 20),
                CLTextField.password(
                  prefix: Icon(Icons.lock_outline, size: Sizes.medium, color: CLTheme.of(context).secondaryText),
                  controller: vm.passwordTEC,
                  labelText: 'Password',
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      context.customGoNamed(AuthRoutes.recoverPassword.name);
                    },
                    child: Text(
                      "Password dimenticata?",
                      style: CLTheme.of(context).smallText.copyWith(
                            color: CLTheme.of(context).primary,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                // Login button - full width
                CLButton.primary(
                  text: "Accedi",
                  icon: Icons.arrow_forward_rounded,
                  iconAlignment: IconAlignment.end,
                  onTap: () async {
                    await vm.doLogin(authState);
                  },
                  context: context,
                ),
                const SizedBox(height: 40),
                // Footer divider
                Row(
                  children: [
                    Expanded(child: Divider(color: CLTheme.of(context).borderColor)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        "Accesso riservato agli amministratori",
                        style: CLTheme.of(context).smallLabel,
                      ),
                    ),
                    Expanded(child: Divider(color: CLTheme.of(context).borderColor)),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
