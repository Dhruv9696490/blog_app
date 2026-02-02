import 'package:blog_app/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:blog_app/core/network/connection_checker.dart';
import 'package:blog_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog_app/features/auth/data/repository/auth_repository_imp.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:blog_app/features/auth/domain/usecases/get_current_user.dart';
import 'package:blog_app/features/auth/domain/usecases/log_out.dart';
import 'package:blog_app/features/auth/domain/usecases/user_login.dart';
import 'package:blog_app/features/auth/domain/usecases/user_signup.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:blog_app/features/blog/data/datasources/bloc_remote_data_source.dart';
import 'package:blog_app/features/blog/data/datasources/blog_local_data_source.dart';
import 'package:blog_app/features/blog/data/repository/blog_repository_implementation.dart';
import 'package:blog_app/features/blog/domain/repository/blog_repository.dart';
import 'package:blog_app/features/blog/domain/usecases/delete_blog.dart';
import 'package:blog_app/features/blog/domain/usecases/get_all_blogs.dart';
import 'package:blog_app/features/blog/domain/usecases/update_blog.dart';
import 'package:blog_app/features/blog/domain/usecases/upload_blog.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog/blog_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/secrets/app_secret.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  final supaBase = await Supabase.initialize(
    url: AppSecret.supabaseUrl,
    anonKey: AppSecret.supabaseAnon,
  );
  if (!kIsWeb) {
    await Hive.initFlutter();
    final box = await Hive.openBox('blogs');
    serviceLocator.registerLazySingleton(() => box);
  }

  // Register adapters

  serviceLocator.registerLazySingleton<SupabaseClient>(() => supaBase.client);
  serviceLocator.registerFactory(() => InternetConnection());

  // core
  serviceLocator.registerLazySingleton(() => AppUserCubit());

  _initAuth();
  _initBlog();
}

void _initAuth() {
  serviceLocator
    ..registerFactory<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImplement(serviceLocator()),
    )
    ..registerFactory<ConnectionChecker>(
      () => ConnectionCheckerImpl(serviceLocator()),
    )
    ..registerFactory<AuthRepository>(
      () => AuthRepositoryImplementation(
        serviceLocator(),
        serviceLocator<ConnectionChecker>(),
      ),
    )
    ..registerFactory(() => UserSignUp(serviceLocator()))
    ..registerFactory(() => UserLogin(serviceLocator()))
    ..registerFactory(() => GetCurrentUser(serviceLocator()))
    ..registerFactory(()=> LogOut(authRepository: serviceLocator<AuthRepository>()))
    ..registerLazySingleton(
      () => AuthBloc(
        userSignUp: serviceLocator<UserSignUp>(),
        userLogin: serviceLocator<UserLogin>(),
        getCurrentUser: serviceLocator<GetCurrentUser>(),
        appUserCubit: serviceLocator<AppUserCubit>(),
         logOut: serviceLocator<LogOut>(),
      ),
    );
}

void _initBlog() {
  serviceLocator.registerFactory<BlogRemoteDataSource>(
    () => BlogRemoteDataSourceImplementation(serviceLocator<SupabaseClient>()),
  );
  if (!kIsWeb) {
    serviceLocator.registerFactory<BlogLocalDataSource>(
      () => BlogLocalDataSourceImpl(serviceLocator()),
    );
  }
  serviceLocator
    ..registerFactory<BlogRepository>(
      () => BlogRepositoryImplementation(
        serviceLocator<BlogRemoteDataSource>(),
       (kIsWeb) ? null : serviceLocator<BlogLocalDataSource>(),
        serviceLocator<ConnectionChecker>(),
      ),
    )
    ..registerFactory<UploadBlog>(
      () => UploadBlog(serviceLocator<BlogRepository>()),
    )
    ..registerFactory<GetAllBlogs>(
      () => GetAllBlogs(serviceLocator<BlogRepository>()),
    )
    ..registerFactory<DeleteBlog>(
      () => DeleteBlog(serviceLocator<BlogRepository>()),
    )
    ..registerFactory<UpdateBlog>(
      () => UpdateBlog(serviceLocator<BlogRepository>()),
    )
    ..registerLazySingleton(
      () => BlogBloc(
        uploadBlog: serviceLocator<UploadBlog>(),
        getAllBlogs: serviceLocator<GetAllBlogs>(),
        deleteBlog: serviceLocator<DeleteBlog>(),
        updateBlog: serviceLocator<UpdateBlog>()
      ),
    );
}
