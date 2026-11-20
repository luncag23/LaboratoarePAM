import 'entities.dart';

/// Contractul Repository din stratul Domain (independent de HTTP sau JSON).
abstract class StoreRepository {
  Future<HomePageEntity> getFeed();
  Future<ProductDetailEntity> getProductDetails({String? productId});
}
