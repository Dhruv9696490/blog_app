
import 'package:blog_app/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class UseCase<Success,Params>{
  Future<Either<Failure,Success>> call(Params params);
}

class NoParam{}