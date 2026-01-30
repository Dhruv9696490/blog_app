part of 'blog_bloc.dart';

@immutable
sealed class BlogEvent {}

class UploadBlogEvent extends BlogEvent{
  final File image;
  final String title;
  final String content;
  final String posterId;
  final List<String> topics;

  UploadBlogEvent({
    required this.image,
    required this.title,
    required this.content,
    required this.posterId,
    required this.topics,
  });
}

class GetAllBlogsEvent extends BlogEvent{}
class DeleteBlogEvent extends BlogEvent{
  final String blogId;
  DeleteBlogEvent({required this.blogId});
}