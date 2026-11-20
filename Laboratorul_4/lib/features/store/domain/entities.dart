class CategoryEntity {
  final String id;
  final String name;
  final bool selected;
  final String iconUrl;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.selected,
    required this.iconUrl,
  });
}

class HeroBannerEntity {
  final String id;
  final String title;
  final String imageUrl;
  final String action;
  final int slides;
  final int activeSlide;

  const HeroBannerEntity({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.action,
    required this.slides,
    required this.activeSlide,
  });
}

class ProductSummaryEntity {
  final String id;
  final String name;
  final double price;
  final String currency;
  final String imageUrl;

  const ProductSummaryEntity({
    required this.id,
    required this.name,
    required this.price,
    required this.currency,
    required this.imageUrl,
  });
}

class NewCollectionEntity {
  final String label;
  final String title;
  final String imageUrl;

  const NewCollectionEntity({
    required this.label,
    required this.title,
    required this.imageUrl,
  });
}

class TopCollectionEntity {
  final String id;
  final String label;
  final String title;
  final String imageUrl;

  const TopCollectionEntity({
    required this.id,
    required this.label,
    required this.title,
    required this.imageUrl,
  });
}

class CategoryPromoEntity {
  final String id;
  final String category;
  final String title;
  final String imageUrl;

  const CategoryPromoEntity({
    required this.id,
    required this.category,
    required this.title,
    required this.imageUrl,
  });
}

class HomePageEntity {
  final String storeName;
  final List<CategoryEntity> categories;
  final HeroBannerEntity heroBanner;
  final List<ProductSummaryEntity> featureProducts;
  final NewCollectionEntity newCollection;
  final List<ProductSummaryEntity> recommended;
  final List<TopCollectionEntity> topCollections;
  final List<CategoryPromoEntity> categoryPromos;

  const HomePageEntity({
    required this.storeName,
    required this.categories,
    required this.heroBanner,
    required this.featureProducts,
    required this.newCollection,
    required this.recommended,
    required this.topCollections,
    required this.categoryPromos,
  });
}

class ColorOptionEntity {
  final String id;
  final String name;
  final String value;

  const ColorOptionEntity({
    required this.id,
    required this.name,
    required this.value,
  });
}

class RatingBreakdownEntity {
  final int stars;
  final int percentage;

  const RatingBreakdownEntity({
    required this.stars,
    required this.percentage,
  });
}

class ReviewEntity {
  final String id;
  final String author;
  final String avatarUrl;
  final double rating;
  final String createdAtLabel;
  final String text;

  const ReviewEntity({
    required this.id,
    required this.author,
    required this.avatarUrl,
    required this.rating,
    required this.createdAtLabel,
    required this.text,
  });
}

class ProductDetailEntity {
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
  final List<ColorOptionEntity> availableColors;
  final String selectedColor;
  final List<String> availableSizes;
  final String selectedSize;
  final Map<String, bool> sizeAvailability;
  final List<RatingBreakdownEntity> ratingBreakdown;
  final List<ReviewEntity> reviews;
  final List<ProductSummaryEntity> similarProducts;
  final bool isFavorite;
  final bool canAddToCart;
  final String addToCartLabel;

  const ProductDetailEntity({
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

  ProductDetailEntity mergeWithSummary(ProductSummaryEntity summary) {
    if (id == summary.id || summary.id.isEmpty) return this;
    final secondaryGallery = galleryImageUrls.length > 1
        ? galleryImageUrls.skip(1).toList()
        : <String>[];
    return ProductDetailEntity(
      id: summary.id,
      name: summary.name,
      price: summary.price,
      currency: summary.currency,
      mainImageUrl: summary.imageUrl,
      galleryImageUrls: [summary.imageUrl, ...secondaryGallery],
      rating: rating,
      ratingCount: ratingCount,
      reviewCount: reviewCount,
      description: description,
      descriptionExpanded: descriptionExpanded,
      availableColors: availableColors,
      selectedColor: selectedColor,
      availableSizes: availableSizes,
      selectedSize: selectedSize,
      sizeAvailability: sizeAvailability,
      ratingBreakdown: ratingBreakdown,
      reviews: reviews,
      similarProducts: similarProducts,
      isFavorite: isFavorite,
      canAddToCart: canAddToCart,
      addToCartLabel: addToCartLabel,
    );
  }
}
