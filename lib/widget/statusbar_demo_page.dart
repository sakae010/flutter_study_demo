import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StatusBarDemoPage extends StatefulWidget {
  const StatusBarDemoPage({Key? key}) : super(key: key);

  @override
  State<StatusBarDemoPage> createState() => _StatusBarDemoPageState();
}

class _StatusBarDemoPageState extends State<StatusBarDemoPage> {
  bool customSystemUIOverlayStyle = false;

  @override
  Widget build(BuildContext context) {
    var body = getBody();
    ///如果手动设置过状态栏，就不可以用 AnnotatedRegion ，会影响
    if (customSystemUIOverlayStyle) {
      return body;
    }
    ///如果没有手动设置过状态栏，就可以用 AnnotatedRegion 直接嵌套显示
    return AnnotatedRegion(child: body, value: SystemUiOverlayStyle.dark);
  }

  getBody() {
    return Scaffold(
      appBar: const ImageAppBar(),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextButton(
                onPressed: () {
                  /// 手动修改
                  setState(() {
                    customSystemUIOverlayStyle = true;
                  });
                  SystemChrome.setSystemUIOverlayStyle(
                      SystemUiOverlayStyle.light);
                },
                style: ButtonStyle(
                    backgroundColor:
                        ButtonStyleButton.allOrNull(Colors.yellowAccent)),
                child: const Text("Light")
            ),
            const SizedBox(
              width: 10,
            ),
            TextButton(
                onPressed: () {
                  setState(() {
                    customSystemUIOverlayStyle = true;
                  });
                  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
                },
                child: const Text("Dark")
            )
          ],
        ),
      ),
    );
  }
}

class ImageAppBar extends StatelessWidget with PreferredSizeWidget {
  const ImageAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          "static/gsy_cat.png",
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width,
          height: kToolbarHeight * 3,
        ),
        SafeArea(
            child: IconButton(
          color: Colors.white,
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ))
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight * 3);
}
