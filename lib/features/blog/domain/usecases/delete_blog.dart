
import 'package:blog_app/core/error/exception.dart';
import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usecases/usecase.dart';
import 'package:blog_app/features/blog/domain/repository/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class DeleteBlog implements UseCase<void,String> {
  final BlogRepository blogRepository;
  DeleteBlog(this.blogRepository);
  @override
  Future<Either<Failure, void>> call(String blogId) async{
    return await blogRepository.deleteBlog(blogId);
  }
}