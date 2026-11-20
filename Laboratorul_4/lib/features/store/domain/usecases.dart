import 'entities.dart';
import 'store_repository.dart';

/// Use Case pentru încărcarea feed-ului paginii principale.
class GetFeedUseCase {
  final StoreRepository repository;

  GetFeedUseCase(this.repository);

  Future<HomePageEntity> call() {
    return repository.getFeed();
  }
}

/// Use Case pentru încărcarea detaliilor unui produs.
class GetProductDetailsUseCase {
  final StoreRepository repository;

  GetProductDetailsUseCase(this.repository);

  Future<ProductDetailEntity> call({ProductSummaryEntity? summary}) async {
    final detail = await repository.getProductDetails(productId: summary?.id);
    if (summary != null) {
      return detail.mergeWithSummary(summary);
    }
    return detail;
  }
}
