import 'package:suja/features/domain/entity/card_no_entity.dart';
import 'package:suja/features/domain/entity/process_entity.dart';

abstract class CardNoRepository {
  Future<CardNoEntity> getCardNo(String token,int cardNo);
}
