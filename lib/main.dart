import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:project_dsh/ui/widgets/alertmanager/alert_manager.dart';
import 'package:project_dsh/utils/app_database.util.dart';
import 'package:project_dsh/utils/constants/strings.constant.dart';
import 'package:project_dsh/utils/observers/navigation.util.observer.dart';
import 'package:project_dsh/utils/providers/appstate.util.provider.dart';
import 'package:project_dsh/utils/providers/authstate.util.provider.dart';
import 'package:project_dsh/utils/go_router_modular/go_router_modular_configure.dart';
import 'package:project_dsh/utils/providers/chat.util.provider.dart';
import 'package:project_dsh/utils/providers/navigation.util.provider.dart';
import 'package:project_dsh/utils/providers/theme.util.provider.dart';
import 'package:project_dsh/utils/shared_manager.util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'utils/app.module.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedManager.initPrefs();
  await AppDatabase.prepareDatabase();
  await Modular.configure(
    appModule: AppModule(),
    initialRoute: "/welcome",
    debugLogDiagnostics: false,
    debugLogDiagnosticsGoRouter: false,
    observers: [GoRouterBreadcrumbObserver()],
    navigatorKey: AlertManager.navigatorKey,
  );
  runApp(
    MultiProvider(
        providers: [
          ChangeNotifierProvider<AppState>(create: (context) => AppState()),
          ChangeNotifierProvider<NavigationState>(create: (context) => NavigationState()),
          ChangeNotifierProvider<AuthState>(create: (context) => AuthState()),
          ChangeNotifierProvider<ChatState>(create: (context) => ChatState()),
          ChangeNotifierProvider<ThemeProvider>(create: (context) => ThemeProvider()),
        ],
        child: MainApp()),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return MaterialApp.router(
      routerConfig: GoRouterModular.routerConfig,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate, // <--- Necessario per Material
        GlobalWidgetsLocalizations.delegate,  // <--- Necessario per i Widget base
        GlobalCupertinoLocalizations.delegate,// <--- Necessario per stile iOS
        FlutterQuillLocalizations.delegate,
      ],
      supportedLocales: [Locale("it","it_IT")],
      locale: Locale("it","it_IT"),
      title: Strings.appName,
      debugShowCheckedModeBanner: false,
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: Navigator(
          onGenerateRoute: (_) => MaterialPageRoute(
            builder: (context) => Material(
              type: MaterialType.transparency,
              child: DefaultAlertListener(child: child!),
            ),
          ),
        ),
        breakpoints: [
          const Breakpoint(start: 0, end: 1079, name: MOBILE),
          const Breakpoint(start: 1079, end: double.infinity, name: DESKTOP),
        ],
      ),
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      themeMode: appState.theme,
    );
  }
}
