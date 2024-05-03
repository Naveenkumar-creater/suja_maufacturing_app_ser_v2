import 'package:equatable/equatable.dart';


class TargetQtyEntity extends Equatable {
  const TargetQtyEntity(
{
  required  this.targetQty, 
  });
    final TargetQty1? targetQty;
  @override
  // TODO: implement props
  List<Object?> get props => [targetQty];
  
}

class  TargetQty1 extends Equatable{
  const TargetQty1({required this.targetqty});
  final int? targetqty;
  @override
  // TODO: implement props
  List<Object?> get props =>[targetqty];

} 