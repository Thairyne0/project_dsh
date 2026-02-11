import 'package:flutter/cupertino.dart';

class RefreshNotifier extends ChangeNotifier {
  bool _shouldRefresh = false;
  bool get shouldRefresh => _shouldRefresh;

  void markForRefresh() {
    _shouldRefresh = true;
    notifyListeners();
  }

  void reset() {
    _shouldRefresh = false;
  }
}