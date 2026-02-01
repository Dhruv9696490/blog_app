part of 'blog_bloc.dart';

@immutable
sealed class BlogState {}

final class BlogInitial extends BlogState {}
final class BlogLoading extends BlogState {}
final class BlogUploadSuccess extends BlogState {}
final class BlogFetchedAllSuccess extends BlogState {
  final List<Blog> blogs;
  BlogFetchedAllSuccess({required this.blogs});
}
final class BlogFailure extends BlogState {
  final String error;
  BlogFailure({required this.error});
}

