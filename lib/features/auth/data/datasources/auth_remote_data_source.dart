
import 'package:blog_app/core/error/exception.dart';
import 'package:blog_app/features/auth/data/model/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AuthRemoteDataSource {
  Session? get userCurrentSession;
  Future<UserModel> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
});
  Future<UserModel> loginWithEmailPassword({
    required String email,
    required String password,
});
  Future<UserModel?> getCurrentUserData();
}

class AuthRemoteDataSourceImplement implements AuthRemoteDataSource {
  final SupabaseClient supabaseClient;
  AuthRemoteDataSourceImplement(this.supabaseClient);
  @override
  Session? get userCurrentSession => supabaseClient.auth.currentSession;
  @override
  Future<UserModel> loginWithEmailPassword({required String email, required String password}) async{
    try{
      final user = await supabaseClient.auth.signInWithPassword(password: password,email: email);
      if(user.user==null){
        throw ServerException('something went wrong');
      }else{
        return UserModel.fromJson(user.user!.toJson());
      }
    } on AuthException catch (e) {
      throw ServerException(e.message);
    }catch(e){
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> signUpWithEmailPassword({required String name, required String email, required String password}) async{
    try{
      final user = await supabaseClient.auth.signUp(
          password: password,
          email: email,
          data: {'name': name}
      );
      if(user.user==null){
        throw ServerException('something went wrong');
      }else{
        return UserModel.fromJson(user.user!.toJson()).copyWith(
          email: userCurrentSession?.user.email
        );
      }
    } on AuthException catch (e) {
      throw ServerException(e.message);
    }catch(e){
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel?> getCurrentUserData() async{
      try{
        if(userCurrentSession != null){
        final userData = await supabaseClient.from('profiles').select().eq('id', userCurrentSession!.user.id);
        if (userData.isEmpty) return null;
          return UserModel.fromJson(userData.first).copyWith(
            email: userCurrentSession!.user.email,
          );
          }
        return null;
      }catch(e){
        throw ServerException(e.toString());
      }
  }


}