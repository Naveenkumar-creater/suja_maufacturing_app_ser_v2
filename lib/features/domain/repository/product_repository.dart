import 'package:suja/features/domain/entity/product_entity.dart';


abstract class ProductRepository{
  Future<ProductEntity>getProductList(int id,String token);
}