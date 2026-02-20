import 'package:project_dsh/utils/go_router_modular/module.dart';
import 'package:project_dsh/utils/go_router_modular/bind.dart';

/// 1. REGISTRO CENTRALE (Singleton)
class BreadcrumbRegistry {
  static final BreadcrumbRegistry _instance = BreadcrumbRegistry._internal();
  factory BreadcrumbRegistry() => _instance;
  BreadcrumbRegistry._internal();

  final Map<String, String> _labels = {};       // path -> nome pagina (es. "News")
  final Map<String, String> _moduleLabels = {}; // path -> nome modulo (es. "Gestione News")

  static String _normPath(String path) {
    if (!path.startsWith('/')) path = '/$path';
    if (path.length > 1 && path.endsWith('/')) {
      path = path.substring(0, path.length - 1);
    }
    return path;
  }

  /// Registra il nome della pagina per un path
  void register(String path, String label) {
    _labels[_normPath(path)] = label;
  }

  /// Registra il nome del modulo genitore per un path
  void registerModule(String path, String label) {
    _moduleLabels[_normPath(path)] = label;
  }

  /// Cerca il nome della pagina
  String? lookup(String path) {
    return _labels[_normPath(path)];
  }

  /// Cerca il nome del modulo genitore
  String? lookupModule(String path) {
    return _moduleLabels[_normPath(path)];
  }
}

/// 2. MIXIN PER I MODULI CUSTOM
mixin BreadcrumbAware on Module {
  Map<String, String> get breadcrumbLabels;

  @override
  List<Bind<Object>> get binds {
    _registerLabels();
    // Chiamiamo super.binds, che nella classe base ritorna const []
    // Ma se la classe figlia fa override senza chiamare super, questo mixin non scatta!
    // TRUCCO: La classe figlia DEVE chiamare super.binds o aggiungere un hook.
    // Oppure usiamo il costruttore della classe figlia.
    return super.binds;
  }
  
  void _registerLabels() {
    breadcrumbLabels.forEach((path, label) {
      BreadcrumbRegistry().register(path, label);
    });
  }
}
