import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities.dart';
import '../../domain/usecases.dart';
import '../cubit/product_detail_cubit.dart';
import '../cubit/store_cubit.dart';
import '../widgets/common_widgets.dart';
import '../widgets/product_detail_content.dart';

// --- PAGINA DETALII PRODUS (Conectată la /feed/details) ---
class ProductDetailsPage extends StatelessWidget {
  final ProductSummaryEntity summary;

  const ProductDetailsPage({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductDetailCubit(
        getProductDetailsUseCase: context.read<GetProductDetailsUseCase>(),
      )..loadDetails(summary),
      child: Scaffold(
        appBar: AppBar(
          title: Text(summary.name),
          actions: [
            BlocBuilder<StoreCubit, StoreState>(
              builder: (context, state) {
                final isFav = (state is StoreSuccessState)
                    ? state.favoriteIds.contains(summary.id)
                    : false;
                return IconButton(
                  icon: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? Colors.red : Colors.black,
                  ),
                  onPressed: () =>
                      context.read<StoreCubit>().toggleFavorite(summary.id),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<ProductDetailCubit, ProductDetailState>(
          builder: (context, state) {
            if (state is ProductDetailLoadingState ||
                state is ProductDetailInitialState) {
              return const LoadingView(
                message: "Se încarcă detaliile produsului din API...",
              );
            }

            if (state is ProductDetailErrorState) {
              return ErrorView(
                message: state.message,
                onRetry: () =>
                    context.read<ProductDetailCubit>().loadDetails(summary),
              );
            }

            if (state is ProductDetailSuccessState) {
              return ProductDetailContent(
                detail: state.detail,
                onSimilarProductTap: (sp) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProductDetailsPage(summary: sp),
                    ),
                  );
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
