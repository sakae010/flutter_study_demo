import 'package:flutter/material.dart';

class RefreshDemoPage extends StatefulWidget {
  const RefreshDemoPage({Key? key}) : super(key: key);

  @override
  State<RefreshDemoPage> createState() => _RefreshDemoPageState();
}

class _RefreshDemoPageState extends State<RefreshDemoPage> {
  final int pageSize = 30;

  bool disposed = false;

  List<String> dataList = [];

  final ScrollController _scrollController = ScrollController();

  final GlobalKey<RefreshIndicatorState> refreshKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      /// 判断当前滑动位置是否到达底部，触发加载更多回调
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        loadMore();
      }
      Future.delayed(const Duration(seconds: 0), () {
        refreshKey.currentState!.show();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    disposed = true;
  }

  Future<void> onRefresh() async {
    await Future.delayed(const Duration(seconds: 2));
    dataList.clear();
    dataList = List.generate(pageSize, (index) => "refresh");
    if (disposed) {
      return;
    }
    setState(() {});
  }

  Future<void> loadMore() async {
    await Future.delayed(const Duration(seconds: 2));
    for (int i = 0; i < pageSize; i++) {
      dataList.add("loadmore");
    }
    if (disposed) {
      return;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("RefreshDemoPage"),
      ),
      body: RefreshIndicator(
        ///GlobalKey，用户外部获取RefreshIndicator的State，做显示刷新
        key: refreshKey,

        /// 下拉刷新出发，返回的是一个Future
        onRefresh: onRefresh,
        child: ListView.builder(
          ///保持ListView任何情况都能滚动，解决在RefreshIndicator的兼容问题。
          physics: const AlwaysScrollableScrollPhysics(),

          ///根据状态返回
          itemBuilder: (context, index) {
            if (index == dataList.length) {
              return Container(
                margin: const EdgeInsets.all(10),
                child: const Align(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return Card(
              child: Container(
                height: 60,
                alignment: Alignment.centerLeft,
                child: Text("Item ${dataList[index]} $index"),
              ),
            );
          },

          /// 根据状态返回数量
          itemCount: (dataList.length >= pageSize)
              ? dataList.length + 1
              : dataList.length,
          controller: _scrollController,
        ),
      ),
    );
  }
}
