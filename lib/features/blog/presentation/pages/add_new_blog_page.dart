import 'package:blog_app/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:blog_app/core/constants/constants.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/loading.dart';
import 'package:blog_app/core/utils/show_message.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/pages/blog_page.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_editor_field.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AddNewBlogPage extends StatefulWidget {
  final Blog? blog;
  static route(Blog? blog) => MaterialPageRoute(
    builder: (_) {
      return AddNewBlogPage(blog: blog);
    },
  );

  const AddNewBlogPage({super.key, required this.blog});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  List<String> blogCategory = [];
  final formKey = GlobalKey<FormState>();
  Uint8List? image;
  @override
  void initState() {
    super.initState();
    if (widget.blog != null) {
      blogCategory = widget.blog!.topics;
      titleController.text = widget.blog!.title;
      contentController.text = widget.blog!.content;
    }
  }

  void _uploadBlog() {
    final posterId =
        (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;
    if (formKey.currentState!.validate() &&
        image != null &&
        blogCategory.isNotEmpty &&
        widget.blog == null) {
      context.read<BlogBloc>().add(
        UploadBlogEvent(
          image: image!,
          title: titleController.text.trim(),
          content: contentController.text.trim(),
          posterId: posterId,
          topics: blogCategory,
        ),
      );
    } else if (formKey.currentState!.validate() &&
        image != null &&
        blogCategory.isNotEmpty &&
        widget.blog != null) {
      context.read<BlogBloc>().add(
        UpdateBlogEvent(
          imageUrl: widget.blog!.imageUrl,
          id: widget.blog!.id,
          image: image,
          title: titleController.text.trim(),
          content: contentController.text.trim(),
          posterId: widget.blog!.posterId,
          topics: blogCategory,
        ),
      );
    } else if (formKey.currentState!.validate() &&
        image == null &&
        blogCategory.isNotEmpty &&
        widget.blog != null) {
      context.read<BlogBloc>().add(
        UpdateBlogEvent(
          imageUrl: widget.blog!.imageUrl,
          id: widget.blog!.id,
          image: null,
          title: titleController.text.trim(),
          content: contentController.text.trim(),
          posterId: widget.blog!.posterId,
          topics: blogCategory,
        ),
      );
    }
  }

  void pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    final Uint8List? bytes = await picked?.readAsBytes();
    if (bytes != null) {
      image = bytes;
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
    final widthSize = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(size: 35),
        title: const Text('Add Blog'),
        actions: [
          IconButton(
            onPressed: () => _uploadBlog(),
            icon: Icon(Icons.done, size: 40),
          ),
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
                                child: Image.memory(image!, fit: BoxFit.cover),
                              ),
                            )
                          : (image == null && widget.blog != null)
                          ? SizedBox(
                              height: 0.30 * widthSize,
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(9),
                                child: Image.network(
                                  widget.blog!.imageUrl,
                                  fit: BoxFit.fill,
                                  loadingBuilder:
                                      (context, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return Center(
                                          child: SizedBox(
                                            height: 4,
                                            child: LinearProgressIndicator(),
                                          ),
                                        );
                                      },
                                ),
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
                              child: SizedBox(
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
                        children: Constants.topics.map((e) {
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
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
                                labelPadding: EdgeInsets.fromLTRB(14, 4, 14, 4),
                                padding: EdgeInsets.all(0),
                                label: Text(
                                  e,
                                  style: TextStyle(
                                    fontSize: !(widthSize > 667)
                                        ? 16
                                        : widthSize * 0.018,
                                  ),
                                ),
                                side: BorderSide(color: AppPallete.borderColor),
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
