import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'store_logic.dart';
import 'store_ui.dart';

void main() {
  runApp(const GemStoreApp());
}

class GemStoreApp extends StatelessWidget {
  const GemStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => StoreRepository(),
      child: BlocProvider(
        create: (context) => StoreCubit(context.read<StoreRepository>())..fetchStoreData(),
        child: MaterialApp(
          title: 'GemStore',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor: const Color(0xFFF9F9F9),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.black),
              titleTextStyle: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          home: const HomePageUI(),
        ),
      ),
    );
  }
}