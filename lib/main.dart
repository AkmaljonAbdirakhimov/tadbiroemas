import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tadbiroemas/data/repositories/auth_repository.dart';
import 'package:tadbiroemas/logic/blocs/auth/auth_bloc.dart';
import 'package:tadbiroemas/services/firebase_auth_service.dart';

import 'core/app.dart';

void main() {
  final firebaseAuthService = FirebaseAuthService();

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) {
            return AuthRepository(
              firebaseAuthService: firebaseAuthService,
            );
          },
        )
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (ctx) {
            return AuthBloc(
              authRepository: ctx.read<AuthRepository>(),
            );
          })
        ],
        child: const MainApp(),
      ),
    ),
  );
}
