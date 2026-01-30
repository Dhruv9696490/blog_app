
import 'package:blog_app/core/error/exception.dart';
import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/common/entities/User.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/network/connection_checker.dart';
import '../model/user_model.dart';

class AuthRepositoryImplementation implements AuthRepository{
  final AuthRemoteDataSource authRemoteDataSource;
  final ConnectionChecker connectionChecker;

  AuthRepositoryImplementation(this.authRemoteDataSource, this.connectionChecker);
  @override
  Future<Either<Failure, User>> loginWithEmailAndPassword({required String email, required String password}) async{
    try{
      if (!await (connectionChecker.isConnected)) {
        return left(Failure(Constants.noConnectionErrorMessage));
      }
      final id = await authRemoteDataSource.loginWithEmailPassword(email: email, password: password);
      return right(id);
    }on ServerException catch(e){
      return left(Failure(e.error));
    }
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailAndPassword({required String name, required String email, required String password})async {
    try{

      if (!await (connectionChecker.isConnected)) {
        return left(Failure(Constants.noConnectionErrorMessage));
      }
      final id =await authRemoteDataSource.signUpWithEmailPassword(name: name, email: email, password: password);
      return right(id);
    }on ServerException catch(e){
      return left(Failure(e.error));
    }
  }

  @override
  Future<Either<Failure, User>> getCurrentUser() async{
        try{

          if (!await (connectionChecker.isConnected)) {
            final session = authRemoteDataSource.userCurrentSession;

            if (session == null) {
              return left(Failure('User not logged in!'));
            }

            return right(
              UserModel(
                id: session.user.id,
                email: session.user.email ?? '',
                name: '',
              ),
            );
          }
          final user = await authRemoteDataSource.getCurrentUserData();
          if(user==null){
            return left(Failure("user is mull"));
          }
          return right(user);
        }on ServerException catch(e){
            return left(Failure(e.error));
        }
  }

}