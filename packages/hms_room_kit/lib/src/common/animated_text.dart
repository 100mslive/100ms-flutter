import 'package:flutter/material.dart';

class AnimatedTextWidget extends StatefulWidget {
  final String text;
  final Duration duration;

  const AnimatedTextWidget(
      {super.key, required this.text, required this.duration});

  @override
  AnimatedTextWidgetState createState() => AnimatedTextWidgetState();
}

class AnimatedTextWidgetState extends State<AnimatedTextWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();

    // Create an animation controller
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    // Create a tween animation for vertical offset
    _animation = Tween<Offset>(
      begin: const Offset(0.0, 1.0), // Start from the bottom of the screen
      end: const Offset(0.0, 0.0), // Fly to the top of the screen
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // Start the animation
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: Text(
        widget.text,
        style: const TextStyle(fontSize: 24),
      ),
    );
  }
}
