import 'package:flutter/material.dart';

class TransformDemoPage extends StatelessWidget {
  const TransformDemoPage({Key? key}) : super(key: key);

  getHeader(context) {
    /// 向上偏移-30位置
    return Transform.translate(
      offset: const Offset(0, -30),
      child: Container(
        height: 72.0,
        width: 72.0,
        decoration: BoxDecoration(

            /// 阴影
            boxShadow: [
              BoxShadow(color: Theme.of(context).cardColor, blurRadius: 4.0)
            ],

            /// 形状
            shape: BoxShape.circle,

            /// 图片
            image: const DecorationImage(
                fit: BoxFit.cover, image: AssetImage("static/gsy_cat.png"))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("TransformDemoPage"),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Card(
          margin: const EdgeInsets.all(10),
          child: Container(
            height: 150,
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                getHeader(context),
                const Text(
                  "Flutter is Google's portable UI toolkit for crafting "
                  "beautiful, natively compiled applications for mobile, "
                  "web, and desktop from a single codebase. ",
                  overflow: TextOverflow.ellipsis,
                  softWrap: true,
                  maxLines: 3,
                  style: TextStyle(),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
