import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// --- MODELE DE DATE HOME PAGE ---
class CategoryModel {
  final String id;
  final String name;
  final bool selected;
  final String iconUrl;

  CategoryModel({
    required this.id,
    required this.name,
    required this.selected,
    required this.iconUrl,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      selected: json['selected'] ?? false,
      iconUrl: json['iconUrl'] ?? '',
    );
  }
}

class HeroBannerModel {
  final String id;
  final String title;
  final String imageUrl;
  final String action;
  final int slides;
  final int activeSlide;

  HeroBannerModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.action,
    required this.slides,
    required this.activeSlide,
  });

  factory HeroBannerModel.fromJson(Map<String, dynamic> json) {
    return HeroBannerModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      action: json['action'] ?? '',
      slides: json['slides'] ?? 1,
      activeSlide: json['activeSlide'] ?? 0,
    );
  }
}

class ProductSummaryModel {
  final String id;
  final String name;
  final double price;
  final String currency;
  final String imageUrl;

  ProductSummaryModel({
    required this.id,
    required this.name,
    required this.price,
    required this.currency,
    required this.imageUrl,
  });

  factory ProductSummaryModel.fromJson(Map<String, dynamic> json) {
    return ProductSummaryModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] ?? 'USD',
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}

class NewCollectionModel {
  final String label;
  final String title;
  final String imageUrl;

  NewCollectionModel({
    required this.label,
    required this.title,
    required this.imageUrl,
  });

  factory NewCollectionModel.fromJson(Map<String, dynamic> json) {
    return NewCollectionModel(
      label: json['label'] ?? '',
      title: json['title'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}

class TopCollectionModel {
  final String id;
  final String label;
  final String title;
  final String imageUrl;

  TopCollectionModel({
    required this.id,
    required this.label,
    required this.title,
    required this.imageUrl,
  });

  factory TopCollectionModel.fromJson(Map<String, dynamic> json) {
    return TopCollectionModel(
      id: json['id'] ?? '',
      label: json['label'] ?? '',
      title: json['title'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}

class CategoryPromoModel {
  final String id;
  final String category;
  final String title;
  final String imageUrl;

  CategoryPromoModel({
    required this.id,
    required this.category,
    required this.title,
    required this.imageUrl,
  });

  factory CategoryPromoModel.fromJson(Map<String, dynamic> json) {
    return CategoryPromoModel(
      id: json['id'] ?? '',
      category: json['category'] ?? '',
      title: json['title'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}

class HomePageData {
  final String storeName;
  final List<CategoryModel> categories;
  final HeroBannerModel heroBanner;
  final List<ProductSummaryModel> featureProducts;
  final NewCollectionModel newCollection;
  final List<ProductSummaryModel> recommended;
  final List<TopCollectionModel> topCollections;
  final List<CategoryPromoModel> categoryPromos;

  HomePageData({
    required this.storeName,
    required this.categories,
    required this.heroBanner,
    required this.featureProducts,
    required this.newCollection,
    required this.recommended,
    required this.topCollections,
    required this.categoryPromos,
  });

  factory HomePageData.fromJson(Map<String, dynamic> json) {
    return HomePageData(
      storeName: json['storeName'] ?? 'GemStore',
      categories: (json['categories'] as List? ?? [])
          .map((c) => CategoryModel.fromJson(c))
          .toList(),
      heroBanner: HeroBannerModel.fromJson(json['heroBanner'] ?? {}),
      featureProducts: (json['featureProducts'] as List? ?? [])
          .map((p) => ProductSummaryModel.fromJson(p))
          .toList(),
      newCollection: NewCollectionModel.fromJson(json['newCollection'] ?? {}),
      recommended: (json['recommended'] as List? ?? [])
          .map((p) => ProductSummaryModel.fromJson(p))
          .toList(),
      topCollections: (json['topCollections'] as List? ?? [])
          .map((c) => TopCollectionModel.fromJson(c))
          .toList(),
      categoryPromos: (json['categoryPromos'] as List? ?? [])
          .map((cp) => CategoryPromoModel.fromJson(cp))
          .toList(),
    );
  }
}

// --- MODELE DE DATE PRODUCT DETAILS PAGE ---
class ColorOptionModel {
  final String id;
  final String name;
  final String value;

  ColorOptionModel({required this.id, required this.name, required this.value});

  factory ColorOptionModel.fromJson(Map<String, dynamic> json) {
    return ColorOptionModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      value: json['value'] ?? '#000000',
    );
  }
}

class RatingBreakdownModel {
  final int stars;
  final int percentage;

  RatingBreakdownModel({required this.stars, required this.percentage});

  factory RatingBreakdownModel.fromJson(Map<String, dynamic> json) {
    return RatingBreakdownModel(
      stars: json['stars'] ?? 0,
      percentage: json['percentage'] ?? 0,
    );
  }
}

class ReviewModel {
  final String id;
  final String author;
  final String avatarUrl;
  final double rating;
  final String createdAtLabel;
  final String text;

  ReviewModel({
    required this.id,
    required this.author,
    required this.avatarUrl,
    required this.rating,
    required this.createdAtLabel,
    required this.text,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] ?? '',
      author: json['author'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 5.0,
      createdAtLabel: json['createdAtLabel'] ?? '',
      text: json['text'] ?? '',
    );
  }
}

class ProductDetailModel {
  final String id;
  final String name;
  final double price;
  final String currency;
  final String mainImageUrl;
  final List<String> galleryImageUrls;
  final double rating;
  final int ratingCount;
  final int reviewCount;
  final String description;
  final bool descriptionExpanded;
  final List<ColorOptionModel> availableColors;
  final String selectedColor;
  final List<String> availableSizes;
  final String selectedSize;
  final Map<String, bool> sizeAvailability;
  final List<RatingBreakdownModel> ratingBreakdown;
  final List<ReviewModel> reviews;
  final List<ProductSummaryModel> similarProducts;
  final bool isFavorite;
  final bool canAddToCart;
  final String addToCartLabel;

  ProductDetailModel({
    required this.id,
    required this.name,
    required this.price,
    required this.currency,
    required this.mainImageUrl,
    required this.galleryImageUrls,
    required this.rating,
    required this.ratingCount,
    required this.reviewCount,
    required this.description,
    required this.descriptionExpanded,
    required this.availableColors,
    required this.selectedColor,
    required this.availableSizes,
    required this.selectedSize,
    required this.sizeAvailability,
    required this.ratingBreakdown,
    required this.reviews,
    required this.similarProducts,
    required this.isFavorite,
    required this.canAddToCart,
    required this.addToCartLabel,
  });

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) {
    final actions = json['actions'] as Map<String, dynamic>? ?? {};
    final sizeMapRaw = json['sizeAvailability'] as Map<String, dynamic>? ?? {};
    final Map<String, bool> sizeMap = sizeMapRaw.map(
          (k, v) => MapEntry(k, v as bool),
    );

    return ProductDetailModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      currency: json['currency'] ?? 'USD',
      mainImageUrl: json['mainImageUrl'] ?? '',
      galleryImageUrls: List<String>.from(json['galleryImageUrls'] ?? []),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      ratingCount: json['ratingCount'] ?? 0,
      reviewCount: json['reviewCount'] ?? 0,
      description: json['description'] ?? '',
      descriptionExpanded: json['descriptionExpanded'] ?? false,
      availableColors: (json['availableColors'] as List? ?? [])
          .map((c) => ColorOptionModel.fromJson(c))
          .toList(),
      selectedColor: json['selectedColor'] ?? '',
      availableSizes: List<String>.from(json['availableSizes'] ?? []),
      selectedSize: json['selectedSize'] ?? '',
      sizeAvailability: sizeMap,
      ratingBreakdown: (json['ratingBreakdown'] as List? ?? [])
          .map((r) => RatingBreakdownModel.fromJson(r))
          .toList(),
      reviews: (json['reviews'] as List? ?? [])
          .map((r) => ReviewModel.fromJson(r))
          .toList(),
      similarProducts: (json['similarProducts'] as List? ?? [])
          .map((sp) => ProductSummaryModel.fromJson(sp))
          .toList(),
      isFavorite: actions['isFavorite'] ?? false,
      canAddToCart: actions['canAddToCart'] ?? true,
      addToCartLabel: actions['addToCartLabel'] ?? 'Add To Cart',
    );
  }

  // Constructează dinamic detaliile produsului pe baza cardului apăsat
  factory ProductDetailModel.fromSummary(
      ProductSummaryModel summary,
      ProductDetailModel template,
      ) {
    return ProductDetailModel(
      id: summary.id,
      name: summary.name,
      price: summary.price,
      currency: summary.currency,
      mainImageUrl: summary.imageUrl,
      galleryImageUrls: [summary.imageUrl, ...template.galleryImageUrls.skip(1)],
      rating: template.rating,
      ratingCount: template.ratingCount,
      reviewCount: template.reviewCount,
      description: template.description,
      descriptionExpanded: template.descriptionExpanded,
      availableColors: template.availableColors,
      selectedColor: template.selectedColor,
      availableSizes: template.availableSizes,
      selectedSize: template.selectedSize,
      sizeAvailability: template.sizeAvailability,
      ratingBreakdown: template.ratingBreakdown,
      reviews: template.reviews,
      similarProducts: template.similarProducts,
      isFavorite: template.isFavorite,
      canAddToCart: template.canAddToCart,
      addToCartLabel: template.addToCartLabel,
    );
  }
}

class FullStoreData {
  final HomePageData homePage;
  final ProductDetailModel defaultProductDetail;
  final Set<String> favoriteIds;

  FullStoreData({
    required this.homePage,
    required this.defaultProductDetail,
    required this.favoriteIds,
  });
}

// --- STĂRI BLoC / CUBIT ---
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
  final FullStoreData data;
  final String searchQuery;
  final String selectedCategoryId;

  StoreSuccessState({
    required this.data,
    this.searchQuery = '',
    this.selectedCategoryId = 'women',
  });

  List<ProductSummaryModel> get filteredFeatured {
    return data.homePage.featureProducts.where((p) {
      return p.name.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
  }

  List<ProductSummaryModel> get filteredRecommended {
    return data.homePage.recommended.where((p) {
      return p.name.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
  }
}

// --- REPOSITORY ---
class StoreRepository {
  Future<FullStoreData> loadStoreData() async {
    await Future.delayed(const Duration(milliseconds: 600));

    final String response = await rootBundle.loadString('assets/data.json');
    final Map<String, dynamic> jsonMap = json.decode(response);

    final homePage = HomePageData.fromJson(jsonMap['homePage']);
    final productDetail = ProductDetailModel.fromJson(jsonMap['productPage']['product']);

    final Set<String> initialFavs = {};
    if (productDetail.isFavorite) {
      initialFavs.add(productDetail.id);
    }

    return FullStoreData(
      homePage: homePage,
      defaultProductDetail: productDetail,
      favoriteIds: initialFavs,
    );
  }
}

// --- CUBIT ---
class StoreCubit extends Cubit<StoreState> {
  final StoreRepository repository;
  FullStoreData? _rawData;

  StoreCubit(this.repository) : super(StoreInitialState());

  Future<void> fetchStoreData() async {
    emit(StoreLoadingState());
    try {
      _rawData = await repository.loadStoreData();
      if (_rawData!.homePage.featureProducts.isEmpty && _rawData!.homePage.recommended.isEmpty) {
        emit(StoreEmptyState(message: "Magazinul nu conține produse."));
      } else {
        emit(StoreSuccessState(data: _rawData!));
      }
    } catch (e) {
      emit(StoreErrorState("Eroare la încărcarea datelor: ${e.toString()}"));
    }
  }

  void searchProducts(String query) {
    if (state is StoreSuccessState) {
      final currentState = state as StoreSuccessState;
      final newState = StoreSuccessState(
        data: currentState.data,
        searchQuery: query,
        selectedCategoryId: currentState.selectedCategoryId,
      );

      if (newState.filteredFeatured.isEmpty && newState.filteredRecommended.isEmpty) {
        emit(StoreEmptyState(message: "Niciun produs nu se potrivește căutării '$query'"));
      } else {
        emit(newState);
      }
    } else if (state is StoreEmptyState && query.isEmpty && _rawData != null) {
      emit(StoreSuccessState(data: _rawData!));
    }
  }

  void selectCategory(String categoryId) {
    if (state is StoreSuccessState) {
      final currentState = state as StoreSuccessState;
      emit(StoreSuccessState(
        data: currentState.data,
        searchQuery: currentState.searchQuery,
        selectedCategoryId: categoryId,
      ));
    }
  }

  void toggleFavorite(String productId) {
    if (_rawData == null) return;

    final updatedFavorites = Set<String>.from(_rawData!.favoriteIds);
    if (updatedFavorites.contains(productId)) {
      updatedFavorites.remove(productId);
    } else {
      updatedFavorites.add(productId);
    }

    _rawData = FullStoreData(
      homePage: _rawData!.homePage,
      defaultProductDetail: _rawData!.defaultProductDetail,
      favoriteIds: updatedFavorites,
    );

    if (state is StoreSuccessState) {
      final currentState = state as StoreSuccessState;
      emit(StoreSuccessState(
        data: _rawData!,
        searchQuery: currentState.searchQuery,
        selectedCategoryId: currentState.selectedCategoryId,
      ));
    }
  }
}