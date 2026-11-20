import '../domain/entities.dart';
import '../domain/store_repository.dart';
import 'store_remote_data_source.dart';

/// Implementarea Repository-ului care leagă DataSource de Domain.
class StoreRepositoryImpl implements StoreRepository {
  final StoreRemoteDataSource remoteDataSource;

  StoreRepositoryImpl({required this.remoteDataSource});

  @override
  Future<HomePageEntity> getFeed() async {
    return await remoteDataSource.fetchFeed();
  }

  @override
  Future<ProductDetailEntity> getProductDetails({String? productId}) async {
    return await remoteDataSource.fetchProductDetails(productId: productId);
  }
}
