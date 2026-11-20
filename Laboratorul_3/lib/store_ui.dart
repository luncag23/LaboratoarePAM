import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'store_logic.dart';

const Color _tealColor = Color(0xFF508A7B);

// --- PAGINA PRINCIPALĂ (HOME) ---
class HomePageUI extends StatefulWidget {
  const HomePageUI({super.key});

  @override
  State<HomePageUI> createState() => _HomePageUIState();
}

class _HomePageUIState extends State<HomePageUI> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.menu_rounded), onPressed: () {}),
        title: BlocBuilder<StoreCubit, StoreState>(
          builder: (context, state) {
            final name = (state is StoreSuccessState)
                ? state.data.homePage.storeName
                : "GemStore";
            return Text(name);
          },
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<StoreCubit>().fetchStoreData(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => context.read<StoreCubit>().searchProducts(val),
              decoration: InputDecoration(
                hintText: "Căutare produse...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    context.read<StoreCubit>().searchProducts('');
                  },
                )
                    : null,
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<StoreCubit, StoreState>(
              builder: (context, state) {
                if (state is StoreLoadingState) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(color: _tealColor),
                        SizedBox(height: 16),
                        Text("Se încarcă datele din JSON..."),
                      ],
                    ),
                  );
                }

                if (state is StoreErrorState) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, size: 60, color: Colors.redAccent),
                          const SizedBox(height: 16),
                          Text(state.message, textAlign: TextAlign.center),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => context.read<StoreCubit>().fetchStoreData(),
                            child: const Text("Reîncearcă"),
                          )
                        ],
                      ),
                    ),
                  );
                }

                if (state is StoreEmptyState) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off, size: 60, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(state.message, style: const TextStyle(color: Colors.grey, fontSize: 16)),
                      ],
                    ),
                  );
                }

                if (state is StoreSuccessState) {
                  final home = state.data.homePage;

                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 90,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: home.categories.length,
                            itemBuilder: (context, index) {
                              final cat = home.categories[index];
                              final isSelected = cat.id == state.selectedCategoryId;
                              return GestureDetector(
                                onTap: () => context.read<StoreCubit>().selectCategory(cat.id),
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 16),
                                  child: Column(
                                    children: [
                                      CircleAvatar(
                                        radius: 24,
                                        backgroundColor: isSelected ? Colors.black : Colors.grey[200],
                                        child: Icon(
                                          _getCategoryIcon(cat.id),
                                          color: isSelected ? Colors.white : Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        cat.name,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        _HeroBannerCard(banner: home.heroBanner),
                        if (state.filteredFeatured.isNotEmpty) ...[
                          _sectionHeader("Feature Products"),
                          SizedBox(
                            height: 230,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(horizontal: 8),
                              itemCount: state.filteredFeatured.length,
                              itemBuilder: (context, index) {
                                final product = state.filteredFeatured[index];
                                final isFav = state.data.favoriteIds.contains(product.id);
                                return ProductCardWidget(
                                  product: product,
                                  isFavorite: isFav,
                                  onFavoriteToggle: () =>
                                      context.read<StoreCubit>().toggleFavorite(product.id),
                                );
                              },
                            ),
                          ),
                        ],
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: _NewCollectionBanner(item: home.newCollection),
                        ),
                        if (state.filteredRecommended.isNotEmpty) ...[
                          _sectionHeader("Recommended"),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: state.filteredRecommended.length,
                            itemBuilder: (context, index) {
                              final product = state.filteredRecommended[index];
                              final isFav = state.data.favoriteIds.contains(product.id);
                              return SmallProductCardWidget(
                                product: product,
                                isFavorite: isFav,
                                onFavoriteToggle: () =>
                                    context.read<StoreCubit>().toggleFavorite(product.id),
                              );
                            },
                          ),
                        ],
                        if (home.topCollections.isNotEmpty) ...[
                          _sectionHeader("Top Collection"),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              children: home.topCollections.map((tc) {
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  height: 120,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    image: DecorationImage(
                                      image: NetworkImage(tc.imageUrl),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      gradient: LinearGradient(
                                        colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                                      ),
                                    ),
                                    alignment: Alignment.centerLeft,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(tc.label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                        const SizedBox(height: 4),
                                        Text(tc.title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          )
                        ],
                        if (home.categoryPromos.isNotEmpty) ...[
                          _sectionHeader("Category Promos"),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: home.categoryPromos.map((cp) {
                                return Expanded(
                                  child: Container(
                                    height: 140,
                                    margin: const EdgeInsets.only(right: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      image: DecorationImage(
                                        image: NetworkImage(cp.imageUrl),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        gradient: LinearGradient(
                                          colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                                          begin: Alignment.bottomCenter,
                                          end: Alignment.topCenter,
                                        ),
                                      ),
                                      alignment: Alignment.bottomLeft,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(cp.category, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                                          Text(cp.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          )
                        ],
                        const SizedBox(height: 40),
                      ],
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String id) {
    switch (id) {
      case 'women':
        return Icons.female;
      case 'men':
        return Icons.male;
      case 'accessories':
        return Icons.watch;
      case 'beauty':
        return Icons.face;
      default:
        return Icons.category;
    }
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

// --- WIDGETURI BANNER & CARDURI ---
class _HeroBannerCard extends StatelessWidget {
  final HeroBannerModel banner;

  const _HeroBannerCard({required this.banner});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      height: 160,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        image: DecorationImage(
          image: NetworkImage(banner.imageUrl),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.black.withOpacity(0.6), Colors.transparent],
          ),
        ),
        alignment: Alignment.centerLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              banner.title,
              style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              banner.action,
              style: const TextStyle(color: Colors.white70, fontSize: 14, decoration: TextDecoration.underline),
            ),
          ],
        ),
      ),
    );
  }
}

class _NewCollectionBanner extends StatelessWidget {
  final NewCollectionModel item;

  const _NewCollectionBanner({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 6),
                  Text(item.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(right: Radius.circular(16)),
            child: Image.network(item.imageUrl, width: 140, height: 140, fit: BoxFit.cover),
          )
        ],
      ),
    );
  }
}

class ProductCardWidget extends StatelessWidget {
  final ProductSummaryModel product;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const ProductCardWidget({
    super.key,
    required this.product,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final state = context.read<StoreCubit>().state;
        if (state is StoreSuccessState) {
          final detail = ProductDetailModel.fromSummary(
            product,
            state.data.defaultProductDetail,
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductDetailsPageUI(detail: detail),
            ),
          );
        }
      },
      child: Container(
        width: 140,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    product.imageUrl,
                    height: 150,
                    width: 140,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: GestureDetector(
                    onTap: onFavoriteToggle,
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: Colors.white.withOpacity(0.9),
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.grey,
                        size: 16,
                      ),
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(height: 8),
            Text(
              product.name,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              "\$ ${product.price.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class SmallProductCardWidget extends StatelessWidget {
  final ProductSummaryModel product;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const SmallProductCardWidget({
    super.key,
    required this.product,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final state = context.read<StoreCubit>().state;
        if (state is StoreSuccessState) {
          final detail = ProductDetailModel.fromSummary(
            product,
            state.data.defaultProductDetail,
          );
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductDetailsPageUI(detail: detail),
            ),
          );
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(product.imageUrl, width: 60, height: 60, fit: BoxFit.cover),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text("\$ ${product.price.toStringAsFixed(2)}", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.grey,
              ),
              onPressed: onFavoriteToggle,
            ),
          ],
        ),
      ),
    );
  }
}

// --- PAGINA DETALII PRODUS ---
class ProductDetailsPageUI extends StatelessWidget {
  final ProductDetailModel detail;

  const ProductDetailsPageUI({super.key, required this.detail});

  Color _parseHexColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(detail.name),
        actions: [
          BlocBuilder<StoreCubit, StoreState>(
            builder: (context, state) {
              final isFav = (state is StoreSuccessState)
                  ? state.data.favoriteIds.contains(detail.id)
                  : false;
              return IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? Colors.red : Colors.black,
                ),
                onPressed: () => context.read<StoreCubit>().toggleFavorite(detail.id),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 280,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: detail.galleryImageUrls.isNotEmpty
                    ? detail.galleryImageUrls.length
                    : 1,
                itemBuilder: (context, index) {
                  final img = detail.galleryImageUrls.isNotEmpty
                      ? detail.galleryImageUrls[index]
                      : detail.mainImageUrl;
                  return Container(
                    margin: const EdgeInsets.only(right: 12),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(img, width: 280, height: 280, fit: BoxFit.cover),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(detail.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ),
                Text(
                  "\$ ${detail.price.toStringAsFixed(2)}",
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: _tealColor),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Row(
                  children: List.generate(
                    5,
                        (i) => Icon(
                      i < detail.rating.floor() ? Icons.star : Icons.star_border,
                      color: _tealColor,
                      size: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text("(${detail.ratingCount} rating-uri, ${detail.reviewCount} recenzii)",
                    style: const TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
            const Divider(height: 30),
            const Text("Culori Disponibile:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
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
                    backgroundColor: _parseHexColor(colorOpt.value),
                    radius: 12,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            const Text("Mărimi Disponibile:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
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
            const Divider(height: 30),
            const Text("Descriere", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(detail.description, style: const TextStyle(color: Colors.black, height: 1.5)),
            const Divider(height: 30),
            const Text("Statistici Rating", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Column(
              children: detail.ratingBreakdown.map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Row(
                    children: [
                      Text("${item.stars} ★", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: LinearProgressIndicator(
                          value: item.percentage / 100,
                          backgroundColor: Colors.grey[200],
                          color: _tealColor,
                          minHeight: 6,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text("${item.percentage}%", style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  ),
                );
              }).toList(),
            ),
            const Divider(height: 30),
            const Text("Recenzii Utilizatori", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                            child: Text(rev.author, style: const TextStyle(fontWeight: FontWeight.bold)),
                          ),
                          Text(rev.createdAtLabel, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(rev.text, style: const TextStyle(color: Colors.black87)),
                    ],
                  ),
                );
              }).toList(),
            ),
            const Divider(height: 30),
            if (detail.similarProducts.isNotEmpty) ...[
              const Text("Produse Similare", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: detail.similarProducts.length,
                  itemBuilder: (context, index) {
                    final sp = detail.similarProducts[index];
                    return GestureDetector(
                      onTap: () {
                        final state = context.read<StoreCubit>().state;
                        if (state is StoreSuccessState) {
                          final newDetail = ProductDetailModel.fromSummary(
                            sp,
                            state.data.defaultProductDetail,
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProductDetailsPageUI(detail: newDetail),
                            ),
                          );
                        }
                      },
                      child: Container(
                        width: 130,
                        margin: const EdgeInsets.only(right: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(sp.imageUrl, height: 130, width: 130, fit: BoxFit.cover),
                            ),
                            const SizedBox(height: 6),
                            Text(sp.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13), maxLines: 1),
                            Text("\$ ${sp.price.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: detail.canAddToCart ? Colors.black : Colors.grey,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: detail.canAddToCart ? () {} : null,
                child: Text(
                  detail.addToCartLabel,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}