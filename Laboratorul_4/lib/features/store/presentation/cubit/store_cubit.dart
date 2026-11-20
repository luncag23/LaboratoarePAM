import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities.dart';
import '../../domain/usecases.dart';

abstract class StoreState {}

class StoreInitialState extends StoreState {}

class StoreLoadingState extends StoreState {}

class StoreEmptyState extends StoreState {
  final String message;
  StoreEmptyState({this.message = "Nu au fost găsite produse."});
}

class StoreErrorState extends StoreState {
  final String message;
  StoreErrorState(this.message);
}

class StoreSuccessState extends StoreState {
  final HomePageEntity homePage;
  final Set<String> favoriteIds;
  final String searchQuery;
  final String selectedCategoryId;

  StoreSuccessState({
    required this.homePage,
    required this.favoriteIds,
    this.searchQuery = '',
    this.selectedCategoryId = 'women',
  });

  List<ProductSummaryEntity> get filteredFeatured {
    return homePage.featureProducts.where((p) {
      return p.name.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
  }

  List<ProductSummaryEntity> get filteredRecommended {
    return homePage.recommended.where((p) {
      return p.name.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
  }
}

class StoreCubit extends Cubit<StoreState> {
  final GetFeedUseCase getFeedUseCase;
  HomePageEntity? _cachedHomePage;
  Set<String> _favoriteIds = {};

  StoreCubit({required this.getFeedUseCase}) : super(StoreInitialState());

  Future<void> fetchStoreData() async {
    emit(StoreLoadingState());
    try {
      final homePage = await getFeedUseCase();
      _cachedHomePage = homePage;

      final CategoryEntity selectedCat = homePage.categories.firstWhere(
        (c) => c.selected,
        orElse: () => homePage.categories.isNotEmpty
            ? homePage.categories.first
            : const CategoryEntity(
                id: 'women',
                name: 'Women',
                selected: true,
                iconUrl: '',
              ),
      );

      if (homePage.featureProducts.isEmpty && homePage.recommended.isEmpty) {
        emit(StoreEmptyState(message: "Magazinul nu conține produse."));
      } else {
        emit(
          StoreSuccessState(
            homePage: homePage,
            favoriteIds: _favoriteIds,
            selectedCategoryId: selectedCat.id,
          ),
        );
      }
    } catch (e) {
      emit(StoreErrorState("Eroare la încărcarea datelor din API: $e"));
    }
  }

  void searchProducts(String query) {
    if (state is StoreSuccessState) {
      final currentState = state as StoreSuccessState;
      final newState = StoreSuccessState(
        homePage: currentState.homePage,
        favoriteIds: currentState.favoriteIds,
        searchQuery: query,
        selectedCategoryId: currentState.selectedCategoryId,
      );

      if (newState.filteredFeatured.isEmpty &&
          newState.filteredRecommended.isEmpty) {
        emit(
          StoreEmptyState(
            message: "Niciun produs nu se potrivește căutării '$query'",
          ),
        );
      } else {
        emit(newState);
      }
    } else if (state is StoreEmptyState &&
        query.isEmpty &&
        _cachedHomePage != null) {
      emit(
        StoreSuccessState(
          homePage: _cachedHomePage!,
          favoriteIds: _favoriteIds,
        ),
      );
    }
  }

  void selectCategory(String categoryId) {
    if (state is StoreSuccessState) {
      final currentState = state as StoreSuccessState;
      emit(
        StoreSuccessState(
          homePage: currentState.homePage,
          favoriteIds: currentState.favoriteIds,
          searchQuery: currentState.searchQuery,
          selectedCategoryId: categoryId,
        ),
      );
    }
  }

  void toggleFavorite(String productId) {
    final updatedFavorites = Set<String>.from(_favoriteIds);
    if (updatedFavorites.contains(productId)) {
      updatedFavorites.remove(productId);
    } else {
      updatedFavorites.add(productId);
    }
    _favoriteIds = updatedFavorites;

    if (state is StoreSuccessState) {
      final currentState = state as StoreSuccessState;
      emit(
        StoreSuccessState(
          homePage: currentState.homePage,
          favoriteIds: _favoriteIds,
          searchQuery: currentState.searchQuery,
          selectedCategoryId: currentState.selectedCategoryId,
        ),
      );
    }
  }
}
