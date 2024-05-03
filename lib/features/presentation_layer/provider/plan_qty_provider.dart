import 'package:flutter/cupertino.dart';
import 'package:suja/features/domain/entity/actual_qty_entity.dart';
import 'package:suja/features/domain/entity/plan_qty_entity.dart';

class PlanQtyProvider extends ChangeNotifier {
  PlanQtyEntity? _user;
  PlanQtyEntity? get user => _user;
  void setUser(PlanQtyEntity actual) {
    _user = actual;
    notifyListeners();
  }
}
