import 'package:flutter/cupertino.dart';
import 'package:suja/features/domain/entity/actual_qty_entity.dart';

class ActualQtyProvider extends ChangeNotifier {
  ActualQtyEntity? _user;
  ActualQtyEntity? get user => _user;
  void setUser(ActualQtyEntity actual) {
    _user = actual;
    notifyListeners();
  }
}
