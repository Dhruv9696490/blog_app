import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/loading.dart';
import 'package:blog_app/core/utils/show_message.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/pages/add_new_blog_page.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogPage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (_) {
        return BlogPage();
      });

  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  @override
  void initState() {
    context.read<BlogBloc>().add(GetAllBlogsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog App'),
        actions: [
          IconButton(onPressed: () {
            Navigator.push(context, AddNewBlogPage.route());
          },
              icon: const Icon(CupertinoIcons.add_circled))
        ],
      ),
      body: BlocConsumer<BlogBloc,BlogState>(
        listener: (context, state) {
          if(state is BlogFailure){
            addMessage(context, state.error);
          }
          else if(state is BlogUploadSuccess){
            Navigator.pushAndRemoveUntil(context, BlogPage.route(), (_)=> false);
          }
        },
        builder: (context, state) {
          if(state is BlogLoading){
            return ShowLoading();
          }
          if(state is BlogFetchedAllSuccess){
            return Scrollbar(
              child: ListView.builder(
                itemCount: state.blogs.length,
                  itemBuilder: (context,index){
                  final item = state.blogs[index];
                    return BlogCard(blog: item,color: index % 2 == 0
                    ? AppPallete.gradient1
                        : AppPallete.gradient2, voidCallback:
                        () => context.read<BlogBloc>().add(DeleteBlogEvent(blogId: item.id)),
                    );
                  }),
            );
          }
          return SizedBox();
        }
      ),
    );
  }
}
