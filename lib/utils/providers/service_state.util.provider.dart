import 'package:flutter/material.dart';
import '../shared_manager.util.dart';

const _kServiceKey = '__selected_service__';

enum ServiceType {
  vulcanobuono('Vulcano Buono', 'vulcanobuono'),
  macchinari('Gestione Macchinari', 'macchinari'),
  finanza('Gestione Finanziaria', 'finanza');

  final String label;
  final String key;
  const ServiceType(this.label, this.key);

  /// Colore primario del servizio
  Color get serviceColor {
    switch (this) {
      case ServiceType.vulcanobuono:
        return const Color(0xFF2563EB); // Blu — stesso del tema default
      case ServiceType.macchinari:
        return const Color(0xFF7C3AED); // Viola
      case ServiceType.finanza:
        return const Color(0xFF059669); // Verde
    }
  }

  /// Colore primario chiaro per gradient
  Color get serviceColorLight {
    switch (this) {
      case ServiceType.vulcanobuono:
        return const Color(0xFF38BDF8); // Azzurro
      case ServiceType.macchinari:
        return const Color(0xFFA78BFA); // Viola chiaro
      case ServiceType.finanza:
        return const Color(0xFF34D399); // Verde chiaro
    }
  }

  /// Colore secondario (più scuro, per header/sidebar accent)
  Color get serviceSecondary {
    switch (this) {
      case ServiceType.vulcanobuono:
        return const Color(0xFF1C2082);
      case ServiceType.macchinari:
        return const Color(0xFF4C1D95);
      case ServiceType.finanza:
        return const Color(0xFF064E3B);
    }
  }

  static ServiceType? fromKey(String key) {
    for (final s in ServiceType.values) {
      if (s.key == key) return s;
    }
    return null;
  }
}

class ServiceState extends ChangeNotifier {
  static final ServiceState _instance = ServiceState._internal();
  factory ServiceState() => _instance;

  ServiceState._internal() {
    _load();
  }

  ServiceType? _selected;
  ServiceType? get selected => _selected;
  bool get hasSelection => _selected != null;

  void _load() {
    final raw = SharedManager.getString(_kServiceKey);
    if (raw.isNotEmpty) {
      _selected = ServiceType.fromKey(raw);
    }
  }

  Future<void> select(ServiceType service) async {
    _selected = service;
    await SharedManager.setString(_kServiceKey, service.key);
    notifyListeners();
  }

  Future<void> clear() async {
    _selected = null;
    await SharedManager.setString(_kServiceKey, '');
    notifyListeners();
  }
}

