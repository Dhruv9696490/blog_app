import 'package:blog_app/core/common/cubit/app_user/app_user_cubit.dart';
import 'package:blog_app/core/constants/constants.dart';
import 'package:blog_app/core/theme/app_pallete.dart';
import 'package:blog_app/core/utils/loading.dart';
import 'package:blog_app/core/utils/show_message.dart';
import 'package:blog_app/features/auth/presentation/pages/login_page.dart';
import 'package:blog_app/features/blog/presentation/bloc/blog/blog_bloc.dart';
import 'package:blog_app/features/blog/presentation/pages/add_new_blog_page.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_card.dart';
import 'package:blog_app/features/blog/presentation/widgets/blog_drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(
    builder: (_) {
      return BlogPage();
    },
  );

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

  List<String> currentTab = [];
  @override
  Widget build(BuildContext context) {
    final widthSize = MediaQuery.of(context).size.width;
    // final user = (context.read<AppUserCubit>().state as AppUserLoggedIn).user;
    return Scaffold(
      drawer: BlogDrawer(),
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: IconButton(
                visualDensity: VisualDensity(),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                icon: Icon(Icons.keyboard_double_arrow_right_sharp,size: 30,),
              ),
            );
          },
        ),
        title: Text('Blog App', style: TextStyle(fontSize: 30)),
        titleSpacing: 0,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, AddNewBlogPage.route(null));
            },
            icon: Icon(CupertinoIcons.add_circled, size: 45),
          ),
        ],
      ),
      body: BlocListener<AppUserCubit, AppUserState>(
        listener: (BuildContext context, AppUserState state) {
          if (state is AppUserLoggedOut) {
            Navigator.pushAndRemoveUntil(
              context,
              LoginPage.route(),
              (_) => false,
            );
          }
        },
        child: BlocConsumer<BlogBloc, BlogState>(
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
            if (state is BlogFetchedAllSuccess) {
              final itemView = currentTab.isEmpty
                  ? state.blogs
                  : state.blogs.where((i) {
                      return i.topics.any((m) {
                        return currentTab.contains(m);
                      });
                    }).toList();
              return Column(
                children: [
                  Padding(
                    padding: kIsWeb ?  const EdgeInsets.fromLTRB(8, 0, 16, 0) : const EdgeInsets.fromLTRB(8, 0, 8, 0),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: Constants.topics.map((label) {
                          return Padding(
                            padding: kIsWeb ? const EdgeInsets.fromLTRB(6, 6, 8, 6)  :  const EdgeInsets.fromLTRB(6, 0, 0, 0)   ,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (currentTab.contains(label)) {
                                    currentTab.remove(label);
                                  } else {
                                    currentTab.add(label);
                                  }
                                });
                              },
                              child: Chip(
                                label: Text(
                                  label,
                                  style: TextStyle(
                                    color: currentTab.contains(label)
                                        ? Colors.black
                                        : null,
                                  ),
                                ),
                                color: currentTab.contains(label)
                                    ? WidgetStatePropertyAll(Colors.white70)
                                    : WidgetStatePropertyAll(
                                        Colors.transparent,
                                      ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SizedBox(height: 0),
                  Expanded(
                    child: Scrollbar(
                      interactive: true,
                      thumbVisibility: true,
                      trackVisibility: true,
                      thickness: 10,
                      radius: Radius.circular(7),
                      child: GridView.builder(
                        itemCount: itemView.length,
                        itemBuilder: (context, index) {
                          final item = itemView[index];
                          return BlogCard(
                            blog: item,
                            color: index % 2 == 0
                                ? AppPallete.gradient1
                                : AppPallete.gradient2,
                            deleteCallback: () {
                              showDialog(
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
                                    title: Text(
                                      "Do you want to delete this blog?",
                                    ),
                                    actions: [
                                      IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          context.read<BlogBloc>().add(
                                            DeleteBlogEvent(blogId: item.id),
                                          );
                                        },
                                        icon: Icon(Icons.check),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: Icon(Icons.close_sharp),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            editCallback: () => Navigator.push(
                              context,
                              AddNewBlogPage.route(item),
                            ),
                          );
                        },
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: widthSize > 645 ? 2 : 1,
                          childAspectRatio: 1.7,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
            return SizedBox();
          },
        ),
      ),
    );
  }
}
