import 'dart:io';

import 'package:blog_app/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/image_picker.dart';
import 'package:blog_app/core/utils/loading.dart';
import 'package:blog_app/core/utils/show_message.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_page.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_editor_field.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNewBlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(
    builder: (_) {
      return AddNewBlogPage();
    },
  );

  const AddNewBlogPage({super.key});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final List<String> blogCategory = [];
  final formKey = GlobalKey<FormState>();
  File? image;

  void _uploadBlog() {
    if (formKey.currentState!.validate() &&
        image != null &&
        blogCategory.isNotEmpty) {
      final posterId =
          (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
      context.read<BlogBloc>().add(
        UploadBlogEvent(
          image: image!,
          title: titleController.text.trim(),
          content: contentController.text.trim(),
          posterId: posterId,
          topics: blogCategory,
        ),
      );
    }
  }

  void pickImage() async {
    final pickedImage = await imagePickerFromGallery();
    if (pickedImage != null) {
      image = pickedImage;
    }
    setState(() {});
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Blog'),
        actions: [
          IconButton(onPressed: () => _uploadBlog(), icon: Icon(Icons.done)),
        ],
      ),
      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            addMessage(context, state.error);
          } else if (state is BlogUploadSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              BlogPage.route(),
              (_) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return ShowLoading();
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        pickImage();
                      },
                      child: image != null
                          ? SizedBox(
                              height: 150,
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(9),
                                child: Image.file(image!, fit: BoxFit.cover),
                              ),
                            )
                          : DottedBorder(
                              options: RoundedRectDottedBorderOptions(
                                radius: Radius.circular(16),
                                color: AppPallete.borderColor,
                                dashPattern: [10, 5],
                                padding: EdgeInsets.all(16),
                                strokeWidth: 2,
                              ),
                              child: Container(
                                height: 150,
                                width: double.infinity,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.folder_open, size: 40),
                                    SizedBox(height: 15),
                                    Text(
                                      "Select your image",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ),
                    SizedBox(height: 15),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children:
                            [
                              'Technology',
                              'Business',
                              'Programming',
                              'Entertainment',
                            ].map((e) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    if (blogCategory.contains(e)) {
                                      blogCategory.remove(e);
                                    } else {
                                      blogCategory.add(e);
                                    }
                                    setState(() {});
                                  },
                                  child: Chip(
                                    padding: EdgeInsets.all(0),
                                    label: Text(e),
                                    side: BorderSide(
                                      color: AppPallete.borderColor,
                                    ),
                                    color: blogCategory.contains(e)
                                        ? WidgetStatePropertyAll(
                                            AppPallete.gradient1,
                                          )
                                        : WidgetStatePropertyAll(
                                            AppPallete.backgroundColor,
                                          ),
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                    BlogEditorField(
                      controller: titleController,
                      hint: 'Blog title',
                    ),
                    SizedBox(height: 10),
                    BlogEditorField(
                      controller: contentController,
                      hint: 'Blog content',
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
