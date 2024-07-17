import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tadbiroemas/data/repositories/auth_repository.dart';
import 'package:tadbiroemas/data/repositories/product_repository.dart';
import 'package:tadbiroemas/logic/blocs/auth/auth_bloc.dart';
import 'package:tadbiroemas/logic/blocs/observer/all_observer.dart';
import 'package:tadbiroemas/logic/blocs/products/products_bloc.dart';
import 'package:tadbiroemas/services/firebase_auth_service.dart';
import 'package:tadbiroemas/services/firebase_product_service.dart';

import 'core/app.dart';

void main() {
  Bloc.observer = MyBlocObserver();

  final firebaseAuthService = FirebaseAuthService();
  final firebaseProductService = FirebaseProductService();

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) {
            return AuthRepository(
              firebaseAuthService: firebaseAuthService,
            );
          },
        ),
        RepositoryProvider(
          create: (context) {
            return ProductRepository(
              firebaseProductService: firebaseProductService,
            );
          },
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (ctx) {
            return AuthBloc(
              authRepository: ctx.read<AuthRepository>(),
            );
          }),
          BlocProvider(create: (ctx) {
            return ProductsBloc(
              productRepository: ctx.read<ProductRepository>(),
            );
          }),
        ],
        child: const MainApp(),
      ),
    ),
  );
}
