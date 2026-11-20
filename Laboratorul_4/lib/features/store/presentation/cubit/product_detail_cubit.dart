import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities.dart';
import '../../domain/usecases.dart';

abstract class ProductDetailState {}

class ProductDetailInitialState extends ProductDetailState {}

class ProductDetailLoadingState extends ProductDetailState {}

class ProductDetailErrorState extends ProductDetailState {
  final String message;
  ProductDetailErrorState(this.message);
}

class ProductDetailSuccessState extends ProductDetailState {
  final ProductDetailEntity detail;
  ProductDetailSuccessState(this.detail);
}

class ProductDetailCubit extends Cubit<ProductDetailState> {
  final GetProductDetailsUseCase getProductDetailsUseCase;

  ProductDetailCubit({required this.getProductDetailsUseCase})
      : super(ProductDetailInitialState());

  Future<void> loadDetails(ProductSummaryEntity summary) async {
    emit(ProductDetailLoadingState());
    try {
      final detail = await getProductDetailsUseCase(summary: summary);
      emit(ProductDetailSuccessState(detail));
    } catch (e) {
      emit(ProductDetailErrorState("Eroare la încărcarea detaliilor: $e"));
    }
  }
}
