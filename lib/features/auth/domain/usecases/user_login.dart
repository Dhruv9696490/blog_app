
import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usecases/usecase.dart';
import '../../../../core/common/entities/user.dart';

import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';


class UserLogin implements UseCase<User,LoginParam>{
  final AuthRepository authRepository;
  UserLogin(this.authRepository);
  @override
  Future<Either<Failure, User>> call(LoginParam param) async{
       return await authRepository.loginWithEmailAndPassword(
           email: param.email, password: param.password);
  }
}



class LoginParam{
  final String email;
  final String password;
  LoginParam({required this.email, required this.password});
}