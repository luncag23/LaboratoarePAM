import 'package:flutter/material.dart';

import '../../../../core/constants.dart';
import '../../../../core/utils.dart';
import '../../domain/entities.dart';

class ProductDetailContent extends StatelessWidget {
  final ProductDetailEntity detail;
  final ValueChanged<ProductSummaryEntity> onSimilarProductTap;

  const ProductDetailContent({
    super.key,
    required this.detail,
    required this.onSimilarProductTap,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _buildGallery(),
          const SizedBox(height: 20),
          _buildTitleAndPrice(),
          const SizedBox(height: 8),
          _buildRating(),
          const Divider(height: 30),
          _buildColors(),
          const SizedBox(height: 20),
          _buildSizes(),
          const Divider(height: 30),
          _buildDescription(),
          const Divider(height: 30),
          _buildRatingBreakdown(),
          const Divider(height: 30),
          _buildReviews(),
          const Divider(height: 30),
          if (detail.similarProducts.isNotEmpty) _buildSimilarProducts(),
          const SizedBox(height: 30),
          _buildAddToCartButton(),
        ],
      ),
    );
  }

  Widget _title(String text, {double size = 16}) {
    return Text(
      text,
      style: TextStyle(fontSize: size, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildGallery() {
    return SizedBox(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount:
            detail.galleryImageUrls.isNotEmpty ? detail.galleryImageUrls.length : 1,
        itemBuilder: (context, index) {
          final img = detail.galleryImageUrls.isNotEmpty
              ? detail.galleryImageUrls[index]
              : detail.mainImageUrl;
          return Container(
            margin: const EdgeInsets.only(right: 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                img,
                width: 280,
                height: 280,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTitleAndPrice() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: _title(detail.name, size: 22)),
        Text(
          "\$ ${detail.price.toStringAsFixed(2)}",
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.teal,
          ),
        ),
      ],
    );
  }

  Widget _buildRating() {
    return Row(
      children: [
        Row(
          children: List.generate(
            5,
            (i) => Icon(
              i < detail.rating.floor() ? Icons.star : Icons.star_border,
              color: AppColors.teal,
              size: 18,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          "(${detail.ratingCount} rating-uri, ${detail.reviewCount} recenzii)",
          style: const TextStyle(color: Colors.grey, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildColors() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _title("Culori Disponibile:", size: 15),
        const SizedBox(height: 8),
        Row(
          children: detail.availableColors.map((colorOpt) {
            final isSelected = colorOpt.id == detail.selectedColor;
            return Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.black : Colors.transparent,
                  width: 2,
                ),
              ),
              child: CircleAvatar(
                backgroundColor: parseHexColor(colorOpt.value),
                radius: 12,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSizes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _title("Mărimi Disponibile:", size: 15),
        const SizedBox(height: 8),
        Row(
          children: detail.availableSizes.map((size) {
            final isAvailable = detail.sizeAvailability[size] ?? true;
            final isSelected = size == detail.selectedSize;

            return Container(
              margin: const EdgeInsets.only(right: 12),
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: isSelected
                    ? Colors.black
                    : (isAvailable ? Colors.grey[200] : Colors.grey[100]),
                border: Border.all(
                  color: isAvailable ? Colors.black26 : Colors.transparent,
                ),
              ),
              child: Text(
                size,
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : (isAvailable ? Colors.black : Colors.grey[400]),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  decoration: isAvailable ? null : TextDecoration.lineThrough,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _title("Descriere"),
        const SizedBox(height: 8),
        Text(
          detail.description,
          style: const TextStyle(color: Colors.black, height: 1.5),
        ),
      ],
    );
  }

  Widget _buildRatingBreakdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _title("Statistici Rating"),
        const SizedBox(height: 12),
        Column(
          children: detail.ratingBreakdown.map((item) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2.0),
              child: Row(
                children: [
                  Text(
                    "${item.stars} ★",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: LinearProgressIndicator(
                      value: item.percentage / 100,
                      backgroundColor: Colors.grey[200],
                      color: AppColors.teal,
                      minHeight: 6,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "${item.percentage}%",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildReviews() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _title("Recenzii Utilizatori"),
        const SizedBox(height: 12),
        Column(
          children: detail.reviews.map((rev) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(rev.avatarUrl),
                        radius: 16,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          rev.author,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        rev.createdAtLabel,
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    rev.text,
                    style: const TextStyle(color: Colors.black87),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSimilarProducts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _title("Produse Similare"),
        const SizedBox(height: 12),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: detail.similarProducts.length,
            itemBuilder: (context, index) {
              final sp = detail.similarProducts[index];
              return GestureDetector(
                onTap: () => onSimilarProductTap(sp),
                child: Container(
                  width: 130,
                  margin: const EdgeInsets.only(right: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          sp.imageUrl,
                          height: 130,
                          width: 130,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        sp.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                        maxLines: 1,
                      ),
                      Text(
                        "\$ ${sp.price.toStringAsFixed(2)}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAddToCartButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: detail.canAddToCart ? Colors.black : Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: detail.canAddToCart ? () {} : null,
        child: Text(
          detail.addToCartLabel,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
