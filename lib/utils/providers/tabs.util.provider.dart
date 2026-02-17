import 'package:flutter/material.dart';

/// Modello per un tab aperto
class OpenTab {
  final String id;
  final String path;
  final String title;
  final IconData? icon;
  final bool canClose;
  final DateTime openedAt;

  OpenTab({
    required this.id,
    required this.path,
    required this.title,
    this.icon,
    this.canClose = true,
    DateTime? openedAt,
  }) : openedAt = openedAt ?? DateTime.now();

  OpenTab copyWith({
    String? id,
    String? path,
    String? title,
    IconData? icon,
    bool? canClose,
  }) {
    return OpenTab(
      id: id ?? this.id,
      path: path ?? this.path,
      title: title ?? this.title,
      icon: icon ?? this.icon,
      canClose: canClose ?? this.canClose,
      openedAt: openedAt,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OpenTab && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

/// Provider per gestire i tab aperti (stile IDE)
class TabsState extends ChangeNotifier {
  final List<OpenTab> _tabs = [];
  String? _activeTabId;

  /// Lista dei tab aperti
  List<OpenTab> get tabs => List.unmodifiable(_tabs);

  /// ID del tab attivo
  String? get activeTabId => _activeTabId;

  /// Tab attivo corrente
  OpenTab? get activeTab {
    if (_activeTabId == null) return null;
    try {
      return _tabs.firstWhere((tab) => tab.id == _activeTabId);
    } catch (e) {
      return null;
    }
  }

  /// Indice del tab attivo
  int get activeTabIndex {
    if (_activeTabId == null) return -1;
    return _tabs.indexWhere((tab) => tab.id == _activeTabId);
  }

  /// Numero di tab aperti
  int get tabCount => _tabs.length;

  /// Controlla se un tab con un certo path è già aperto
  OpenTab? findTabByPath(String path) {
    try {
      return _tabs.firstWhere((tab) => tab.path == path);
    } catch (e) {
      return null;
    }
  }

  /// Controlla se un tab con un certo ID esiste
  bool hasTab(String id) {
    return _tabs.any((tab) => tab.id == id);
  }

  /// Apre un nuovo tab o attiva uno esistente se il path corrisponde
  /// Ritorna il tab (nuovo o esistente)
  OpenTab openTab({
    required String path,
    required String title,
    IconData? icon,
    bool canClose = true,
    bool activateIfExists = true,
  }) {
    print('[TabsState] openTab chiamato con path: $path, title: $title');
    print('[TabsState] Tab esistenti: ${_tabs.map((t) => "${t.title}(${t.path})").join(", ")}');

    // Controlla se esiste già un tab con questo path
    final existingTab = findTabByPath(path);
    if (existingTab != null) {
      print('[TabsState] Tab esistente trovato: ${existingTab.title} (${existingTab.path})');
      if (activateIfExists) {
        setActiveTab(existingTab.id);
      }
      return existingTab;
    }

    print('[TabsState] Creo nuovo tab: $title ($path)');

    // Crea un nuovo tab
    final newTab = OpenTab(
      id: _generateTabId(path),
      path: path,
      title: title,
      icon: icon,
      canClose: canClose,
    );

    _tabs.add(newTab);
    _activeTabId = newTab.id;
    notifyListeners();

    print('[TabsState] Tab creato. Totale tab: ${_tabs.length}');

    return newTab;
  }

  /// Genera un ID univoco per il tab
  String _generateTabId(String path) {
    return '${path}_${DateTime.now().millisecondsSinceEpoch}';
  }

  /// Imposta il tab attivo
  void setActiveTab(String tabId) {
    if (_activeTabId == tabId) return;
    if (!hasTab(tabId)) return;

    _activeTabId = tabId;
    notifyListeners();
  }

  /// Imposta il tab attivo per indice
  void setActiveTabByIndex(int index) {
    if (index < 0 || index >= _tabs.length) return;
    setActiveTab(_tabs[index].id);
  }

  /// Chiude un tab
  void closeTab(String tabId) {
    final tabIndex = _tabs.indexWhere((tab) => tab.id == tabId);
    if (tabIndex == -1) return;

    final tab = _tabs[tabIndex];
    if (!tab.canClose) return;

    _tabs.removeAt(tabIndex);

    // Se abbiamo chiuso il tab attivo, attiva un altro tab
    if (_activeTabId == tabId) {
      if (_tabs.isEmpty) {
        _activeTabId = null;
      } else if (tabIndex < _tabs.length) {
        // Attiva il tab nella stessa posizione
        _activeTabId = _tabs[tabIndex].id;
      } else {
        // Attiva l'ultimo tab
        _activeTabId = _tabs.last.id;
      }
    }

    notifyListeners();
  }

  /// Chiude tutti i tab tranne quello specificato
  void closeOtherTabs(String tabId) {
    _tabs.removeWhere((tab) => tab.id != tabId && tab.canClose);
    if (!hasTab(_activeTabId ?? '')) {
      _activeTabId = _tabs.isNotEmpty ? _tabs.first.id : null;
    }
    notifyListeners();
  }

  /// Chiude tutti i tab a destra di quello specificato
  void closeTabsToRight(String tabId) {
    final tabIndex = _tabs.indexWhere((tab) => tab.id == tabId);
    if (tabIndex == -1) return;

    _tabs.removeWhere((tab) {
      final index = _tabs.indexOf(tab);
      return index > tabIndex && tab.canClose;
    });

    if (!hasTab(_activeTabId ?? '')) {
      _activeTabId = _tabs.isNotEmpty ? _tabs.last.id : null;
    }
    notifyListeners();
  }

  /// Chiude tutti i tab
  void closeAllTabs() {
    _tabs.removeWhere((tab) => tab.canClose);
    _activeTabId = _tabs.isNotEmpty ? _tabs.first.id : null;
    notifyListeners();
  }

  /// Aggiorna il titolo di un tab
  void updateTabTitle(String tabId, String newTitle) {
    final tabIndex = _tabs.indexWhere((tab) => tab.id == tabId);
    if (tabIndex == -1) return;

    _tabs[tabIndex] = _tabs[tabIndex].copyWith(title: newTitle);
    notifyListeners();
  }

  /// Riordina i tab (drag & drop)
  void reorderTab(int oldIndex, int newIndex) {
    if (oldIndex < 0 || oldIndex >= _tabs.length) return;
    if (newIndex < 0 || newIndex > _tabs.length) return;

    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final tab = _tabs.removeAt(oldIndex);
    _tabs.insert(newIndex, tab);
    notifyListeners();
  }

  /// Vai al tab precedente
  void previousTab() {
    if (_tabs.isEmpty) return;
    final currentIndex = activeTabIndex;
    if (currentIndex <= 0) {
      setActiveTabByIndex(_tabs.length - 1);
    } else {
      setActiveTabByIndex(currentIndex - 1);
    }
  }

  /// Vai al tab successivo
  void nextTab() {
    if (_tabs.isEmpty) return;
    final currentIndex = activeTabIndex;
    if (currentIndex >= _tabs.length - 1) {
      setActiveTabByIndex(0);
    } else {
      setActiveTabByIndex(currentIndex + 1);
    }
  }

  /// Resetta completamente tutti i tab (utile dopo login/logout)
  void resetTabs() {
    _tabs.clear();
    _activeTabId = null;
    notifyListeners();
  }

  /// Rimuove tutti i tab che iniziano con uno dei path specificati
  void removeTabsByPaths(List<String> pathPrefixes) {
    _tabs.removeWhere((tab) {
      for (final prefix in pathPrefixes) {
        if (tab.path.startsWith(prefix)) {
          return true;
        }
      }
      return false;
    });

    // Se il tab attivo è stato rimosso, attiva il primo disponibile
    if (_activeTabId != null && !hasTab(_activeTabId!)) {
      _activeTabId = _tabs.isNotEmpty ? _tabs.first.id : null;
    }

    notifyListeners();
  }

  /// Rimuove i tab di welcome/auth (da chiamare dopo il login)
  void removeAuthTabs() {
    removeTabsByPaths(['/welcome', '/auth', '/login', '/register']);
  }
}


