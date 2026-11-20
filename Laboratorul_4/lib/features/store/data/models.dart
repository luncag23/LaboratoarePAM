import '../../../core/utils.dart';
import '../domain/entities.dart';

class CategoryModel extends CategoryEntity {
  const CategoryModel({
    required super.id,
    required super.name,
    required super.selected,
    required super.iconUrl,
  });

  factory CategoryModel.fromJson(JsonMap json) {
    return CategoryModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      selected: json['selected'] as bool? ?? false,
      iconUrl: json['iconUrl']?.toString() ?? '',
    );
  }

  JsonMap toJson() => {
        'id': id,
        'name': name,
        'selected': selected,
        'iconUrl': iconUrl,
      };
}

class HeroBannerModel extends HeroBannerEntity {
  const HeroBannerModel({
    required super.id,
    required super.title,
    required super.imageUrl,
    required super.action,
    required super.slides,
    required super.activeSlide,
  });

  factory HeroBannerModel.fromJson(JsonMap json) {
    return HeroBannerModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? '',
      action: json['action']?.toString() ?? '',
      slides: parseInt(json['slides'], 1),
      activeSlide: parseInt(json['activeSlide'], 0),
    );
  }

  JsonMap toJson() => {
        'id': id,
        'title': title,
        'imageUrl': imageUrl,
        'action': action,
        'slides': slides,
        'activeSlide': activeSlide,
      };
}

class ProductSummaryModel extends ProductSummaryEntity {
  const ProductSummaryModel({
    required super.id,
    required super.name,
    required super.price,
    required super.currency,
    required super.imageUrl,
  });

  factory ProductSummaryModel.fromJson(JsonMap json) {
    return ProductSummaryModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      price: parseDouble(json['price']),
      currency: json['currency']?.toString() ?? 'USD',
      imageUrl: json['imageUrl']?.toString() ?? '',
    );
  }

  JsonMap toJson() => {
        'id': id,
        'name': name,
        'price': price,
        'currency': currency,
        'imageUrl': imageUrl,
      };
}

class NewCollectionModel extends NewCollectionEntity {
  const NewCollectionModel({
    required super.label,
    required super.title,
    required super.imageUrl,
  });

  factory NewCollectionModel.fromJson(JsonMap json) {
    return NewCollectionModel(
      label: json['label']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? '',
    );
  }

  JsonMap toJson() => {
        'label': label,
        'title': title,
        'imageUrl': imageUrl,
      };
}

class TopCollectionModel extends TopCollectionEntity {
  const TopCollectionModel({
    required super.id,
    required super.label,
    required super.title,
    required super.imageUrl,
  });

  factory TopCollectionModel.fromJson(JsonMap json) {
    return TopCollectionModel(
      id: json['id']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? '',
    );
  }

  JsonMap toJson() => {
        'id': id,
        'label': label,
        'title': title,
        'imageUrl': imageUrl,
      };
}

class CategoryPromoModel extends CategoryPromoEntity {
  const CategoryPromoModel({
    required super.id,
    required super.category,
    required super.title,
    required super.imageUrl,
  });

  factory CategoryPromoModel.fromJson(JsonMap json) {
    return CategoryPromoModel(
      id: json['id']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      imageUrl: json['imageUrl']?.toString() ?? '',
    );
  }

  JsonMap toJson() => {
        'id': id,
        'category': category,
        'title': title,
        'imageUrl': imageUrl,
      };
}

class HomePageModel extends HomePageEntity {
  const HomePageModel({
    required super.storeName,
    required super.categories,
    required super.heroBanner,
    required super.featureProducts,
    required super.newCollection,
    required super.recommended,
    required super.topCollections,
    required super.categoryPromos,
  });

  factory HomePageModel.fromJson(JsonMap rawJson) {
    final JsonMap json = rawJson['homePage'] is JsonMap
        ? rawJson['homePage'] as JsonMap
        : (rawJson['data'] is JsonMap ? rawJson['data'] as JsonMap : rawJson);

    final heroRaw = json['heroBanner'];
    final JsonMap heroMap = heroRaw is JsonMap
        ? heroRaw
        : (heroRaw is List && heroRaw.isNotEmpty && heroRaw.first is JsonMap
            ? heroRaw.first as JsonMap
            : <String, dynamic>{});

    final newColRaw = json['newCollection'];
    final JsonMap newColMap = newColRaw is JsonMap
        ? newColRaw
        : (newColRaw is List &&
                newColRaw.isNotEmpty &&
                newColRaw.first is JsonMap
            ? newColRaw.first as JsonMap
            : <String, dynamic>{});

    return HomePageModel(
      storeName: json['storeName']?.toString() ?? 'GemStore',
      categories:
          asMapList(json['categories']).map(CategoryModel.fromJson).toList(),
      heroBanner: HeroBannerModel.fromJson(heroMap),
      featureProducts: asMapList(json['featureProducts'])
          .map(ProductSummaryModel.fromJson)
          .toList(),
      newCollection: NewCollectionModel.fromJson(newColMap),
      recommended: asMapList(json['recommended'])
          .map(ProductSummaryModel.fromJson)
          .toList(),
      topCollections: asMapList(json['topCollections'])
          .map(TopCollectionModel.fromJson)
          .toList(),
      categoryPromos: asMapList(json['categoryPromos'])
          .map(CategoryPromoModel.fromJson)
          .toList(),
    );
  }

  JsonMap toJson() => {
        'storeName': storeName,
        'categories':
            categories.map((e) => (e as CategoryModel).toJson()).toList(),
        'heroBanner': (heroBanner as HeroBannerModel).toJson(),
        'featureProducts': featureProducts
            .map((e) => (e as ProductSummaryModel).toJson())
            .toList(),
        'newCollection': (newCollection as NewCollectionModel).toJson(),
        'recommended': recommended
            .map((e) => (e as ProductSummaryModel).toJson())
            .toList(),
        'topCollections': topCollections
            .map((e) => (e as TopCollectionModel).toJson())
            .toList(),
        'categoryPromos': categoryPromos
            .map((e) => (e as CategoryPromoModel).toJson())
            .toList(),
      };
}

class ColorOptionModel extends ColorOptionEntity {
  const ColorOptionModel({
    required super.id,
    required super.name,
    required super.value,
  });

  factory ColorOptionModel.fromJson(JsonMap json) {
    return ColorOptionModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      value: json['value']?.toString() ?? '#000000',
    );
  }

  JsonMap toJson() => {
        'id': id,
        'name': name,
        'value': value,
      };
}

class RatingBreakdownModel extends RatingBreakdownEntity {
  const RatingBreakdownModel({
    required super.stars,
    required super.percentage,
  });

  factory RatingBreakdownModel.fromJson(JsonMap json) {
    return RatingBreakdownModel(
      stars: parseInt(json['stars']),
      percentage: parseInt(json['percentage']),
    );
  }

  JsonMap toJson() => {
        'stars': stars,
        'percentage': percentage,
      };
}

class ReviewModel extends ReviewEntity {
  const ReviewModel({
    required super.id,
    required super.author,
    required super.avatarUrl,
    required super.rating,
    required super.createdAtLabel,
    required super.text,
  });

  factory ReviewModel.fromJson(JsonMap json) {
    return ReviewModel(
      id: json['id']?.toString() ?? '',
      author: json['author']?.toString() ?? '',
      avatarUrl: json['avatarUrl']?.toString() ?? '',
      rating: parseDouble(json['rating'], 5.0),
      createdAtLabel: json['createdAtLabel']?.toString() ?? '',
      text: json['text']?.toString() ?? '',
    );
  }

  JsonMap toJson() => {
        'id': id,
        'author': author,
        'avatarUrl': avatarUrl,
        'rating': rating,
        'createdAtLabel': createdAtLabel,
        'text': text,
      };
}

class ProductDetailModel extends ProductDetailEntity {
  const ProductDetailModel({
    required super.id,
    required super.name,
    required super.price,
    required super.currency,
    required super.mainImageUrl,
    required super.galleryImageUrls,
    required super.rating,
    required super.ratingCount,
    required super.reviewCount,
    required super.description,
    required super.descriptionExpanded,
    required super.availableColors,
    required super.selectedColor,
    required super.availableSizes,
    required super.selectedSize,
    required super.sizeAvailability,
    required super.ratingBreakdown,
    required super.reviews,
    required super.similarProducts,
    required super.isFavorite,
    required super.canAddToCart,
    required super.addToCartLabel,
  });

  factory ProductDetailModel.fromJson(JsonMap rawJson) {
    JsonMap json = rawJson;
    if (json['productPage'] is JsonMap) {
      json = json['productPage'] as JsonMap;
    }
    if (json['product'] is JsonMap) {
      json = json['product'] as JsonMap;
    } else if (json['data'] is JsonMap) {
      json = json['data'] as JsonMap;
    }

    final actions = json['actions'] is JsonMap
        ? json['actions'] as JsonMap
        : <String, dynamic>{};
    final sizeMapRaw = json['sizeAvailability'] is JsonMap
        ? json['sizeAvailability'] as JsonMap
        : <String, dynamic>{};
    final Map<String, bool> sizeMap = sizeMapRaw.map(
      (k, v) => MapEntry(k, v as bool? ?? true),
    );

    return ProductDetailModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      price: parseDouble(json['price']),
      currency: json['currency']?.toString() ?? 'USD',
      mainImageUrl: json['mainImageUrl']?.toString() ?? '',
      galleryImageUrls: (json['galleryImageUrls'] as List? ?? [])
          .map((e) => e.toString())
          .toList(),
      rating: parseDouble(json['rating']),
      ratingCount: parseInt(json['ratingCount']),
      reviewCount: parseInt(json['reviewCount']),
      description: json['description']?.toString() ?? '',
      descriptionExpanded: json['descriptionExpanded'] as bool? ?? false,
      availableColors: asMapList(json['availableColors'])
          .map(ColorOptionModel.fromJson)
          .toList(),
      selectedColor: json['selectedColor']?.toString() ?? '',
      availableSizes: (json['availableSizes'] as List? ?? [])
          .map((e) => e.toString())
          .toList(),
      selectedSize: json['selectedSize']?.toString() ?? '',
      sizeAvailability: sizeMap,
      ratingBreakdown: asMapList(json['ratingBreakdown'])
          .map(RatingBreakdownModel.fromJson)
          .toList(),
      reviews: asMapList(json['reviews']).map(ReviewModel.fromJson).toList(),
      similarProducts: asMapList(json['similarProducts'])
          .map(ProductSummaryModel.fromJson)
          .toList(),
      isFavorite: actions['isFavorite'] as bool? ?? false,
      canAddToCart: actions['canAddToCart'] as bool? ?? true,
      addToCartLabel: actions['addToCartLabel']?.toString() ?? 'Add To Cart',
    );
  }

  JsonMap toJson() => {
        'id': id,
        'name': name,
        'price': price,
        'currency': currency,
        'mainImageUrl': mainImageUrl,
        'galleryImageUrls': galleryImageUrls,
        'rating': rating,
        'ratingCount': ratingCount,
        'reviewCount': reviewCount,
        'description': description,
        'descriptionExpanded': descriptionExpanded,
        'availableColors': availableColors
            .map((e) => (e as ColorOptionModel).toJson())
            .toList(),
        'selectedColor': selectedColor,
        'availableSizes': availableSizes,
        'selectedSize': selectedSize,
        'sizeAvailability': sizeAvailability,
        'ratingBreakdown': ratingBreakdown
            .map((e) => (e as RatingBreakdownModel).toJson())
            .toList(),
        'reviews': reviews.map((e) => (e as ReviewModel).toJson()).toList(),
        'similarProducts': similarProducts
            .map((e) => (e as ProductSummaryModel).toJson())
            .toList(),
        'actions': {
          'isFavorite': isFavorite,
          'canAddToCart': canAddToCart,
          'addToCartLabel': addToCartLabel,
        },
      };
}
