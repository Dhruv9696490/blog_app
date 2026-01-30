import 'dart:io';

import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usecases/usecase.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/usecases/delete_blog.dart';
import 'package:blog_app/features/blog/domain/usecases/get_all_blogs.dart';
import 'package:blog_app/features/blog/domain/usecases/upload_blog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';


part 'blog_event.dart';

part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  final GetAllBlogs _getAllBlogs;
  final DeleteBlog _deleteBlog;

  BlogBloc({required UploadBlog uploadBlog,required GetAllBlogs getAllBlogs,required DeleteBlog deleteBlog})
      :
        _uploadBlog = uploadBlog,
        _getAllBlogs = getAllBlogs,
        _deleteBlog = deleteBlog,
        super(BlogInitial()) {
    on<BlogEvent>((event, emit) => emit(BlogLoading()));
    on<UploadBlogEvent>(_uploadBlogEvent);
    on<GetAllBlogsEvent>( _getAllBlogsEvent);
    on<DeleteBlogEvent>( _deleteBlogEvent);
  }

  void _getAllBlogsEvent(GetAllBlogsEvent event, Emitter<BlogState> emit) async {

    final Either<Failure, List<Blog>> response =await _getAllBlogs(NoParam());
    response.fold((l)=> emit(BlogFailure(error: l.error)), (r)=> emit(BlogFetchedAllSuccess(blogs: r)));
  }

  void _uploadBlogEvent(UploadBlogEvent event, Emitter<BlogState> emit) async{

    final Either<Failure, Blog> response = await _uploadBlog(UploadBlogParam(
        image: event.image,
        title: event.title,
        content: event.content,
        posterId: event.posterId,
        topics: event.topics
    ));
    response.fold((l)=> emit(BlogFailure(error: l.error)), (r)=> emit(BlogUploadSuccess()) );
  }
  void _deleteBlogEvent(DeleteBlogEvent event, Emitter<BlogState> emit)async{
    final  Either<Failure, void> result = await _deleteBlog(event.blogId);
    result.fold((l)=> emit(BlogFailure(error: l.error)), (r){
      emit(BlogUploadSuccess());
    } );
  }
}
