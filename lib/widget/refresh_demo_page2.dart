import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RefreshDemoPage2 extends StatefulWidget {
  const RefreshDemoPage2({Key? key}) : super(key: key);

  @override
  State<RefreshDemoPage2> createState() => _RefreshDemoPage2State();
}

class _RefreshDemoPage2State extends State<RefreshDemoPage2> {
  final int pageSize = 30;

  bool disposed = false;

  List<String> dataList = [];

  final ScrollController _scrollController = ScrollController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    ///直接触发下拉
    Future.delayed(const Duration(milliseconds: 500), () {
      _scrollController.animateTo(-141,
          duration: const Duration(milliseconds: 600), curve: Curves.linear);
      return true;
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
      appBar: AppBar(title: const Text("RefreshDemoPage2")),
      body: NotificationListener(
        onNotification: (ScrollNotification notification) {
          ///判断当前滑动位置是不是到达底部，触发加载更多回调
          if (notification is ScrollEndNotification) {
            if (_scrollController.position.pixels > 0 &&
                _scrollController.position.pixels ==
                    _scrollController.position.maxScrollExtent) {
              loadMore();
            }
          }
          return false;
        },
        child: CustomScrollView(
          controller: _scrollController,

          ///回弹效果
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          slivers: [
            ///控制显示刷新的 CupertinoSliverRefreshControl
            CupertinoSliverRefreshControl(
              refreshIndicatorExtent: 100,
              refreshTriggerPullDistance: 140,
              onRefresh: onRefresh,
            ),

            /// 列表区域
            SliverSafeArea(
                sliver: SliverList(
              ///代理显示
              delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
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
                  childCount: (dataList.length >= pageSize)
                      ? dataList.length + 1
                      : dataList.length),
            ))
          ],
        ),
      ),
    );
  }
}
