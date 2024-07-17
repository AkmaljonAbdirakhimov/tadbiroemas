import 'package:bloc/bloc.dart';
import 'package:tadbiroemas/data/repositories/auth_repository.dart';

import '../../../data/models/user.dart';

part 'auth_state.dart';
part 'auth_event.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(InitialAuthState()) {
    on<LoginEvent>(_onLogin);
    on<RegisterEvent>(_onRegister);
    on<LogoutEvent>(_onLogout);
    on<CheckTokenExpiryEvent>(_onCheckTokenExpiry);
  }

  void _onLogin(LoginEvent event, emit) async {
    emit(LoadingAuthState());
    try {
      final user = await _authRepository.login(
        event.email,
        event.password,
      );

      emit(AuthenticatedAuthState(user));
    } catch (e) {
      emit(ErrorAuthState(e.toString()));
    }
  }

  void _onRegister(RegisterEvent event, emit) async {
    emit(LoadingAuthState());
    try {
      final user = await _authRepository.register(
        event.email,
        event.password,
      );

      emit(AuthenticatedAuthState(user));
    } catch (e) {
      emit(ErrorAuthState(e.toString()));
    }
  }

  void _onLogout(LogoutEvent event, emit) async {
    // clear tokens
    emit(LoadingAuthState());
    emit(UnAuthenticatedAuthState());
  }

  void _onCheckTokenExpiry(CheckTokenExpiryEvent event, emit) async {
    emit(LoadingAuthState());
    final user = await _authRepository.checkTokenExpiry();
    if (user != null) {
      emit(AuthenticatedAuthState(user));
    } else {
      emit(UnAuthenticatedAuthState());
    }
  }
}
