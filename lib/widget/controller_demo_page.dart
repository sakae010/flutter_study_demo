import 'package:flutter/material.dart';

/// 在 Flutter 中有很多内置的 Controller
/// 大部分内置控件都可以通过 Controller 设置和获取控件参数
/// 比如 TextField 的 TextEditingController
/// 比如 ListView  的 ScrollController
/// 一般想对控件做 OOXX 的事情，先找个 Controller 就对了。
class ControllerDemoPage extends StatelessWidget {
  final TextEditingController controller = TextEditingController(text: "init Text");

  ControllerDemoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("Main MediaQuery padding: ${MediaQuery.of(context).padding} viewInsets.bottom: ${MediaQuery.of(context).viewInsets.bottom}");
    return Scaffold(
      appBar: AppBar(
        title: const Text("ControllerDemoPage"),
      ),
      extendBody: true,
      body: Column(
        children: [
          Expanded(
              child: InkWell(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
              )
          ),
          const CustomWidget(),
          Container(
            margin: const EdgeInsets.all(10),
            child: Center(
              child: TextField(
                controller: controller,
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class CustomWidget extends StatelessWidget {
  const CustomWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("Custom MediaQuery padding: ${MediaQuery.of(context).padding} viewInsets.bottom: ${MediaQuery.of(context).viewInsets.bottom}\n  \n");
    return Container();
  }
}