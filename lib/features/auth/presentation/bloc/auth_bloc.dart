import 'package:blog_app/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usecases/usecase.dart';
import 'package:blog_app/features/auth/domain/usecases/log_out.dart';
import '../../../../core/common/entities/user.dart';
import 'package:blog_app/features/auth/domain/usecases/get_current_user.dart';
import 'package:blog_app/features/auth/domain/usecases/user_login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';

import '../../domain/usecases/user_signup.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserLogin _userLogin;
  final GetCurrentUser _getCurrentUser;
  final AppUserCubit _appUserCubit;
  final LogOut _logOut;
  AuthBloc({
    required UserSignUp userSignUp,
    required UserLogin userLogin,
    required GetCurrentUser getCurrentUser,
    required AppUserCubit appUserCubit,
    required LogOut logOut,
  }) : _userSignUp = userSignUp,
       _userLogin = userLogin,
       _getCurrentUser = getCurrentUser,
       _appUserCubit = appUserCubit,
       _logOut = logOut,
       super(AuthInitial()) {
    on<AuthEvent>(_loading);
    on<LoginEvent>(_loginEvent);
    on<SignUpEvent>(_signUpEvent);
    on<GetCurrentUserEvent>(_getCurrentUserEvent);
    on<LogOutEvent>(_logOutEvent);
  }
  void _loading(AuthEvent event, Emitter<AuthState> emit) {
    emit(AuthLoading());
  }

  void _logOutEvent(LogOutEvent event, Emitter<AuthState> emit) async {
    final res = await _logOut(event.userId);
    _appUserCubit.updateUser(null);
    res.fold(
      (l) => emit(AuthFailure(error: l.error)),
      (_) => emit(AuthInitial()),
    );
  }

  void _loginEvent(LoginEvent event, Emitter<AuthState> emit) async {
    final res = await _userLogin(
      LoginParam(email: event.email, password: event.password),
    );
    res.fold(
      (l) => emit(AuthFailure(error: l.error)),
      (r) => _updatingUser(r, emit),
    );
  }

  void _signUpEvent(SignUpEvent event, Emitter<AuthState> emit) async {
    final res = await _userSignUp(
      SignUpParam(
        name: event.name,
        email: event.email,
        password: event.password,
      ),
    );
    res.fold(
      (l) => emit(AuthFailure(error: l.error)),
      (r) => _updatingUser(r, emit),
    );
  }

  void _getCurrentUserEvent(
    GetCurrentUserEvent event,
    Emitter<AuthState> emit,
  ) async {
    final Either<Failure, User> user = await _getCurrentUser(NoParam());
    user.fold(
      (l) => emit(AuthFailure(error: l.error)),
      (r) => _updatingUser(r, emit),
    );
  }

  void _updatingUser(User user, Emitter<AuthState> emit) {
    _appUserCubit.updateUser(user);
    emit(AuthSuccess(user: user));
  }
}
