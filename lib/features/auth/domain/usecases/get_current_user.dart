
import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usecases/usecase.dart';
import '../../../../core/common/entities/user.dart';

import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';


class GetCurrentUser implements UseCase<User,NoParam> {
  final AuthRepository authRepository;
  GetCurrentUser(this.authRepository);
  @override
  Future<Either<Failure, User>> call(NoParam params){
       return authRepository.getCurrentUser();
  }
}