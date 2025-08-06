import 'package:flutter/material.dart';

class ControlIconButton extends StatefulWidget {
  final IconData? icon;
  final Color color;
  final Color? iconColor;
  final VoidCallback? onPressed;
  final bool isRounded;
  final double iconSize;

  const ControlIconButton({
    super.key,
    this.icon,
    required this.color,
    required this.onPressed,
    this.isRounded = true,
    this.iconSize = 20,
    this.iconColor = Colors.white,
  });

  @override
  State<ControlIconButton> createState() => _BabyButtonState();
}

class _BabyButtonState extends State<ControlIconButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
      },
      onTap: widget.onPressed,
      onTapCancel: () => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(widget.isRounded ? 30 : 16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                widget.color,
                Color.lerp(widget.color, Colors.white, 0.1)!,
              ],
            ),
            border: Border.all(
              color: widget.iconColor!,
              width: 2,
            ),
          ),
          child: Icon(
            widget.icon,
            color: widget.iconColor,
            size: widget.iconSize,
          ),
        ),
      ),
    );
  }
}
