import 'package:flutter/material.dart';

class AnimatedCounter extends StatefulWidget {
  final num count;
  final int decimal;
  const AnimatedCounter(
      {super.key, required this.count, required this.decimal});

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation _animation;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _animation = _animationController;
    setState(() {
      _animation = Tween(begin: _animation.value, end: widget.count)
          .animate(_animationController);
    });
    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _animation,
        builder: (ctx, child) {
          return Center(
            child: Text(
              _animation.value.toStringAsFixed(widget.decimal) +
                  ' ${widget.decimal > 0 ? '\$' : ''}',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 30,
                fontWeight: FontWeight.bold,
                fontFamily: 'Acme',
                letterSpacing: 2,
              ),
            ),
          );
        });
  }
}
