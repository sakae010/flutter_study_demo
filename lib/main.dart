import 'package:flutter/material.dart';
import 'package:window_location_href/window_location_href.dart';
import 'package:flutter_study_demo/widget/controller_demo_page.dart'
    deferred as controller_demo_page;
import 'package:flutter_study_demo/widget/clip_demo_page.dart'
    deferred as clip_demo_page;
import 'package:flutter_study_demo/widget/scroll_listener_demo_page.dart'
    deferred as scroll_listener_demo_page;
import 'package:flutter_study_demo/widget/scroll_to_index_demo_page.dart'
    deferred as scroll_to_index_demo_page;
import 'package:flutter_study_demo/widget/scroll_to_index_demo_page2.dart'
    deferred as scroll_to_index_demo_page2;
import 'package:flutter_study_demo/widget/gradient_text_demo_page.dart'
    deferred as gradient_text_demo_page;
import 'package:flutter_study_demo/widget/transform_demo_page.dart'
    deferred as transform_demo_page;
import 'package:flutter_study_demo/widget/text_line_height_demo_page.dart'
    deferred as text_line_height_demo_page;
import 'package:flutter_study_demo/widget/refresh_demo_page.dart'
    deferred as refresh_demo_page;
import 'package:flutter_study_demo/widget/refresh_demo_page2.dart'
    deferred as refresh_demo_page2;
import 'package:flutter_study_demo/widget/custom_pull/refresh_demo_page3.dart'
    deferred as refresh_demo_page3;
import 'package:flutter_study_demo/widget/positioned_demo_page.dart'
    deferred as positioned_demo_page;
import 'package:flutter_study_demo/widget/bubble/bubble_demo_page.dart'
    deferred as bubble_demo_page;
import 'package:flutter_study_demo/widget/tag_demo_page.dart'
    deferred as tag_demo_page;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demos',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demos'),
      routes: routers,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();

    final href = getHref();
    int? index = href?.indexOf("#");
    if (href != null && index != null && index > 0) {
      String uri = href;
      String key = uri.substring(index + 1, uri.length);
      if (key.isNotEmpty && key.length > 3) {
        var result = Uri.decodeFull(key);
        if (routers.keys.contains(result) && result != '/') {
          Future(() {
            Navigator.pushNamed(context, result);
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var routeLists = routers.keys.toList();
    return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: ListView.builder(
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.pushNamed(context, routeLists[index]);
                },
                child: Card(
                    child: Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  height: 50,
                  child: Text(routers.keys.toList()[index]),
                )),
              );
            },
            itemCount: routeLists.length));
  }
}

class ContainerAsyncRouterPage extends StatelessWidget {
  final Future libraryFuture;

  // 不能直接传widget，因为 release 打包时 dart2js 优化会导致时序不对
  final WidgetBuilder child;

  const ContainerAsyncRouterPage(this.libraryFuture, this.child, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: libraryFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(),
              body: Container(
                alignment: Alignment.center,
                child: Text(
                  'Error: ${snapshot.error}',
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 20,
                  ),
                ),
              ),
            );
          }
          return child.call(context);
        }
        return Scaffold(
          appBar: AppBar(),
          body: Container(
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}

Map<String, WidgetBuilder> routers = {
  "文本输入框简单的Controller": (context) {
    return ContainerAsyncRouterPage(controller_demo_page.loadLibrary(),
        (context) {
      return controller_demo_page.ControllerDemoPage();
    });
  },
  "实现控件圆角不同组合": (context) {
    return ContainerAsyncRouterPage(clip_demo_page.loadLibrary(), (context) {
      return clip_demo_page.ClipDemoPage();
    });
  },
  "列表滑动监听": (context) {
    return ContainerAsyncRouterPage(scroll_listener_demo_page.loadLibrary(),
        (context) {
      return scroll_listener_demo_page.ScrollListenerDemoPage();
    });
  },
  "滚动到指定位置": (context) {
    return ContainerAsyncRouterPage(scroll_to_index_demo_page.loadLibrary(),
        (context) => scroll_to_index_demo_page.ScrollToIndexDemoPage());
  },
  "滚动到指定位置2": (context) {
    return ContainerAsyncRouterPage(scroll_to_index_demo_page2.loadLibrary(),
        (context) => scroll_to_index_demo_page2.ScrollToIndexDemoPage2());
  },
  "展示渐变带边框的文本": (context) {
    return ContainerAsyncRouterPage(gradient_text_demo_page.loadLibrary(),
        (context) => gradient_text_demo_page.GradientTextDemoPage());
  },
  "Transform 效果展示": (context) {
    return ContainerAsyncRouterPage(transform_demo_page.loadLibrary(),
        (context) => transform_demo_page.TransformDemoPage());
  },
  "计算另类文本行间距展示": (context) {
    return ContainerAsyncRouterPage(text_line_height_demo_page.loadLibrary(),
        (context) => text_line_height_demo_page.TextLineHeightDemoPage());
  },
  "简单上下刷新": (context) {
    return ContainerAsyncRouterPage(refresh_demo_page.loadLibrary(), (context) {
      return refresh_demo_page.RefreshDemoPage();
    });
  },
  "简单上下刷新2": (context) {
    return ContainerAsyncRouterPage(refresh_demo_page2.loadLibrary(),
        (context) {
      return refresh_demo_page2.RefreshDemoPage2();
    });
  },
  "简单上下刷新3": (context) {
    return ContainerAsyncRouterPage(refresh_demo_page3.loadLibrary(),
        (context) {
      return refresh_demo_page3.RefreshDemoPage3();
    });
  },
  "通过绝对定位布局": (context) {
    return ContainerAsyncRouterPage(positioned_demo_page.loadLibrary(),
        (context) {
      return positioned_demo_page.PositionedDemoPage();
    });
  },
  "气泡提示框": (context) {
    return ContainerAsyncRouterPage(bubble_demo_page.loadLibrary(), (context) {
      return bubble_demo_page.BubbleDemoPage();
    });
  },
  "Tag效果展示": (context) {
    return ContainerAsyncRouterPage(tag_demo_page.loadLibrary(), (context) {
      return tag_demo_page.TagDemoPage();
    });
  },
};
