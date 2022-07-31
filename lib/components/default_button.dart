import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  final Function()? onPressed;
  final double height;
  final double width;
  final double radius;
  final Color color;
  final Widget widget;
  const DefaultButton({
    Key? key,
    required this.onPressed,
    required this.height,
    required this.width,
    required this.radius,
    required this.color,
    required this.widget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 3,
        ),
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(radius),
          ),
          child: TextButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(radius)),
              ),
              child: widget),
        ),
        const SizedBox(
          height: 3,
        ),
      ],
    );
  }
}
