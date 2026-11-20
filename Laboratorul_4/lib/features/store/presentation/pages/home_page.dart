import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/store_cubit.dart';
import '../widgets/common_widgets.dart';
import '../widgets/home_widgets.dart';

// --- PAGINA PRINCIPALĂ (HOME) ---
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded),
          onPressed: () {},
        ),
        title: BlocBuilder<StoreCubit, StoreState>(
          builder: (context, state) {
            final name = (state is StoreSuccessState)
                ? state.homePage.storeName
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
          _buildSearchField(context),
          Expanded(
            child: BlocBuilder<StoreCubit, StoreState>(
              builder: (context, state) {
                if (state is StoreLoadingState) {
                  return const LoadingView(message: "Se încarcă datele din API...");
                }
                if (state is StoreErrorState) {
                  return ErrorView(
                    message: state.message,
                    onRetry: () => context.read<StoreCubit>().fetchStoreData(),
                  );
                }
                if (state is StoreEmptyState) {
                  return EmptyView(message: state.message);
                }
                if (state is StoreSuccessState) {
                  return _buildContent(context, state);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _searchController,
        onChanged: (val) {
          setState(() {});
          context.read<StoreCubit>().searchProducts(val);
        },
        decoration: InputDecoration(
          hintText: "Căutare produse...",
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                    context.read<StoreCubit>().searchProducts('');
                  },
                )
              : null,
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, StoreSuccessState state) {
    final home = state.homePage;
    final cubit = context.read<StoreCubit>();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CategorySelector(
            categories: home.categories,
            selectedCategoryId: state.selectedCategoryId,
            onSelected: cubit.selectCategory,
          ),
          HeroBannerCard(banner: home.heroBanner),
          if (state.filteredFeatured.isNotEmpty) ...[
            const SectionHeader("Feature Products"),
            SizedBox(
              height: 230,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemCount: state.filteredFeatured.length,
                itemBuilder: (context, index) {
                  final product = state.filteredFeatured[index];
                  return ProductCardWidget(
                    product: product,
                    isFavorite: state.favoriteIds.contains(product.id),
                    onFavoriteToggle: () => cubit.toggleFavorite(product.id),
                  );
                },
              ),
            ),
          ],
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: NewCollectionBanner(item: home.newCollection),
          ),
          if (state.filteredRecommended.isNotEmpty) ...[
            const SectionHeader("Recommended"),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: state.filteredRecommended.length,
              itemBuilder: (context, index) {
                final product = state.filteredRecommended[index];
                return SmallProductCardWidget(
                  product: product,
                  isFavorite: state.favoriteIds.contains(product.id),
                  onFavoriteToggle: () => cubit.toggleFavorite(product.id),
                );
              },
            ),
          ],
          if (home.topCollections.isNotEmpty)
            TopCollectionsSection(collections: home.topCollections),
          if (home.categoryPromos.isNotEmpty)
            CategoryPromosSection(promos: home.categoryPromos),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
