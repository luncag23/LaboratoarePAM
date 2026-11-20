import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

import 'core/constants.dart';
import 'features/store/data/store_remote_data_source.dart';
import 'features/store/data/store_repository_impl.dart';
import 'features/store/domain/store_repository.dart';
import 'features/store/domain/usecases.dart';
import 'features/store/presentation/cubit/store_cubit.dart';
import 'features/store/presentation/pages/home_page.dart';

void main() {
  runApp(const GemStoreApp());
}

class GemStoreApp extends StatelessWidget {
  const GemStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    // --- DEPENDENCY INJECTION (Data -> Domain -> Presentation) ---
    final httpClient = http.Client();
    final remoteDataSource = StoreRemoteDataSourceImpl(client: httpClient);
    final StoreRepository storeRepository = StoreRepositoryImpl(
      remoteDataSource: remoteDataSource,
    );

    final getFeedUseCase = GetFeedUseCase(storeRepository);
    final getProductDetailsUseCase = GetProductDetailsUseCase(storeRepository);

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<StoreRepository>.value(value: storeRepository),
        RepositoryProvider<GetFeedUseCase>.value(value: getFeedUseCase),
        RepositoryProvider<GetProductDetailsUseCase>.value(
          value: getProductDetailsUseCase,
        ),
      ],
      child: BlocProvider(
        create: (context) => StoreCubit(
          getFeedUseCase: context.read<GetFeedUseCase>(),
        )..fetchStoreData(),
        child: MaterialApp(
          title: 'GemStore',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: AppColors.scaffoldBackground,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.black),
              titleTextStyle: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          home: const HomePage(),
        ),
      ),
    );
  }
}
