

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../entities/User.dart';

part 'app_user_state.dart';

class AppUserCubit extends Cubit<AppUserState> {
  AppUserCubit() : super(AppUserInitial());

  void updateUser(User? user){
    if(user==null){
      return emit(AppUserLoggedOut());
    }else{
      emit(AppUserLoggedIn(user));
    }
  }
}
