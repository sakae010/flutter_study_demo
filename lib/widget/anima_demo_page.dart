import 'package:flutter/material.dart';

class AnimaDemoPage extends StatefulWidget {
  const AnimaDemoPage({Key? key}) : super(key: key);

  @override
  State<AnimaDemoPage> createState() => _AnimaDemoPageState();
}

class _AnimaDemoPageState extends State<AnimaDemoPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller1;

  Animation? animation1;

  late Animation animation2;

  @override
  void initState() {
    super.initState();
    _controller1 =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));
    animation1 = Tween(begin: 0.0, end: 200.0).animate(_controller1)
      ..addListener(() {
        setState(() {});
      });
    animation2 = Tween(begin: 0.0, end: 1.0).animate(_controller1);

    _controller1.repeat();
  }

  @override
  void dispose() {
    _controller1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AnimaDemoPage"),
      ),

      ///用封装好的 Transition 做动画
      body: RotationTransition(
        turns: animation2 as Animation<double>,
        child: Center(
          child: Container(
            height: 200,
            width: 200,
            color: Colors.greenAccent,
            child: CustomPaint(
                ///直接使用值做动画
                foregroundPainter: _AnimationPainter(animation1)),
          ),
        ),
      ),
    );
  }
}

class _AnimationPainter extends CustomPainter {
  final Paint _paint = Paint();

  Animation? animation;

  _AnimationPainter(this.animation);

  @override
  void paint(Canvas canvas, Size size) {
    _paint
      ..color = Colors.redAccent
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(const Offset(100, 100), animation!.value * 1.5, _paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
