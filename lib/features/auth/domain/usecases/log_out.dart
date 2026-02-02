import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usecases/usecase.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class LogOut implements UseCase<void, String> {
  final AuthRepository authRepository;

  LogOut({required this.authRepository});

  @override
  Future<Either<Failure, void>> call(String userId) async{
    return await authRepository.logOut(userId: userId);
  }
}
