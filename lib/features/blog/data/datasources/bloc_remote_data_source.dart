import 'dart:io';
import 'package:blog_app/core/error/exception.dart';
import 'package:blog_app/features/blog/data/models/blog_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class BlogRemoteDataSource{
  Future<BlogModel> uploadBlog(BlogModel blog);
  Future<String> uploadImage(File image,BlogModel blog);
  Future<List<BlogModel>> getAllBlogs();
  Future<void> deleteBlog(String blogId);
}

class BlogRemoteDataSourceImplementation implements BlogRemoteDataSource{
  final SupabaseClient supabaseClient;
  BlogRemoteDataSourceImplementation(this.supabaseClient);

  @override
  Future<BlogModel> uploadBlog(BlogModel blog) async{
    try{
     final blogData =  await supabaseClient.from('blogs').insert(blog.toJson()).select();
     return BlogModel.fromJson(blogData.first);
    }catch(e){
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> uploadImage(File image, BlogModel blog) async{
         try{
           await supabaseClient.storage.from('blog_images').upload(blog.id, image);
           return supabaseClient.storage.from('blog_images').getPublicUrl(blog.id); 
         }catch(e){
           throw ServerException(e.toString());
         }
  }

  @override
  Future<List<BlogModel>> getAllBlogs() async{
    try{
      final blogModelData = await supabaseClient.from('blogs').select('*, profiles (name)');
      return blogModelData.map((blogs)=> BlogModel.fromJson(blogs).copyWith(
        posterName: blogs['profiles']['name']
      )).toList();
    }on PostgrestException catch(e){
      throw ServerException(e.message);
    }
    catch(e){
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deleteBlog(String blogId) async {
    try{
      final response = await supabaseClient.from('blogs').delete().eq('id',blogId);
    if(response!=null){
      throw ServerException('delete not working');
    }
    }catch(e){
      throw ServerException(e.toString());
    }
  }
}

