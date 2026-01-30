
import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usecases/usecase.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:fpdart/fpdart.dart';

import '../repository/blog_repository.dart';

class GetAllBlogs implements UseCase<List<Blog>,NoParam> {
  final BlogRepository blogRepository;

  GetAllBlogs(this.blogRepository);
  @override
  Future<Either<Failure, List<Blog>>> call(NoParam params) async{
    return await blogRepository.getAllBlogs();
  }
}