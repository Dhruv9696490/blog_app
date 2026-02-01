
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/calculate_reading_time.dart';
import '../pages/blog_viewer_page.dart';

class BlogCard extends StatelessWidget {
  final Blog blog;
  final Color color;
  final VoidCallback deleteCallback;
  final VoidCallback editCallback;
  const BlogCard({
    super.key,
    required this.blog,
    required this.color,
    required this.deleteCallback,
    required this.editCallback
  });

  @override
  Widget build(BuildContext context) {
      final widthSize = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        Navigator.push(context, BlogViewerPage.route(blog));
      },
      child: Container(
        height: 200,
        margin: const EdgeInsets.all(16).copyWith(
          bottom: 4,
        ),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: blog.topics
                          .map(
                            (e) => Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Chip(label: Text(e,style: TextStyle(fontSize: !(widthSize > 667) ? 16 : widthSize*0.02),)),
                        ),
                      )   .toList(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(onPressed: editCallback,
                      icon: Icon(Icons.edit,color: Colors.white,size: !(widthSize > 667) ? 40 : widthSize*0.05, )),
                ),
                IconButton(onPressed: deleteCallback,
                    icon: Icon(Icons.delete,color: Colors.white,size: !(widthSize > 667) ? 40 : widthSize*0.05, ))
              ],
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  blog.title,
                  style:  TextStyle(
                    fontSize: !(widthSize > 667) ? 20 : widthSize*0.02,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Text('${calculateReadingTime(blog.content)} min',style: TextStyle(fontSize: !(widthSize > 667) ? 16 : widthSize*0.02)),
          ],
        ),
      ),
    );
  }
}
