import 'package:flutter/material.dart';
import 'package:flutter_study_demo/widget/controller_demo_page.dart'
    deferred as controller_demo_page;
import 'package:window_location_href/window_location_href.dart';

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
  }
};
