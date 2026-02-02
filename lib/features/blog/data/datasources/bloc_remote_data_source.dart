import 'dart:typed_data';
import 'package:blog_app/core/error/exception.dart';
import 'package:blog_app/features/blog/data/models/blog_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class BlogRemoteDataSource {
  Future<BlogModel> uploadBlog(BlogModel blog);
  Future<String> uploadImage(Uint8List imageBytes, BlogModel blog);
  Future<List<BlogModel>> getAllBlogs();
  Future<void> deleteBlog(String blogId);
  Future<BlogModel> updateBlog(BlogModel blog);
}

class BlogRemoteDataSourceImplementation implements BlogRemoteDataSource {
  final SupabaseClient supabaseClient;
  BlogRemoteDataSourceImplementation(this.supabaseClient);

  @override
  Future<BlogModel> uploadBlog(BlogModel blog) async {
    try {
      final blogData = await supabaseClient
          .from('blogs')
          .insert(blog.toJson())
          .select();
      return BlogModel.fromJson(blogData.first);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<BlogModel> updateBlog(BlogModel blog) async {
    final data = blog.toJson();
    try {
      final blogData = await supabaseClient
          .from('blogs')
          .update(data)
          .eq('id', blog.id)
          .select();
      return BlogModel.fromJson(blogData.first);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> uploadImage(Uint8List imageBytes, BlogModel blog) async {
    final path = 'blogs/${blog.id}.png';
    try {
      await supabaseClient.storage.from('blog_images').remove([path]);

      await supabaseClient.storage
          .from('blog_images')
          .uploadBinary(
            path,
            imageBytes,
            fileOptions: const FileOptions(
              contentType: 'image/png',
              upsert: true,
            ),
          );
      return supabaseClient.storage.from('blog_images').getPublicUrl(path);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<BlogModel>> getAllBlogs() async {
    try {
      final blogModelData = await supabaseClient
          .from('blogs')
          .select('*, profiles (name)');
      return blogModelData
          .map(
            (blogs) => BlogModel.fromJson(
              blogs,
            ).copyWith(posterName: blogs['profiles']['name']),
          )
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteBlog(String blogId) async {
    final path = 'blogs/$blogId.png';
    try {
      final response = await supabaseClient
          .from('blogs')
          .delete()
          .eq('id', blogId);
      await supabaseClient.storage.from('blog_images').remove([path]);
      if (response != null) {
        throw ServerException('delete not working');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
