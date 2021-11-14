import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TravelNavigationBar extends StatelessWidget {
  const TravelNavigationBar({
    Key? key,
    required this.items,
    required this.onPressed,
    this.currentIndex = 0,
  })  : assert(items.length == 2, ''),
        super(key: key);

  final List<TravelNavigationBarItem> items;
  final ValueChanged<int> onPressed;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _NavPainter(),
      child: SizedBox(
        height: kToolbarHeight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            items.length,
            (index) {
              return Expanded(
                child: IconButton(
                  onPressed: () => onPressed(index),
                  color: currentIndex == index
                      ? Theme.of(context).primaryColor
                      : null,
                  icon: currentIndex == index
                      ? Icon(items[index].selectedIcon)
                      : Icon(items[index].icon),
                ),
              );
            },
          )..insert(1, const Expanded(child: SizedBox())),
        ),
      ),
    );
  }
}

class TravelNavigationBarItem {
  TravelNavigationBarItem({
    required this.icon,
    this.selectedIcon,
  });

  final IconData icon;
  final IconData? selectedIcon;
}

class _NavPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final w5 = w * .5;
    final h5 = h * .5;
    final h6 = h * .6;

    final path = Path()
      ..lineTo(w5 - 80, 0)
      ..cubicTo((w5 - 40), 0, (w5 - 50), h5, w5 - 3, h6)
      ..lineTo(w5, h)
      ..lineTo(w, h)
      ..lineTo(w, 0)
      ..lineTo(w5 + 80, 0)
      ..cubicTo((w5 + 40), 0, (w5 + 50), h5, w5 + 3, h6)
      ..lineTo(w5 - 3, h6)
      ..lineTo(w5, h)
      ..lineTo(0, h);
    canvas.drawShadow(path, Colors.black26, 10, false);
    canvas.drawPath(path, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
