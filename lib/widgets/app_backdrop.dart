import 'package:flutter/material.dart';

class AppBackdrop extends StatelessWidget {
  const AppBackdrop({
    super.key,
    required this.child,
    this.dark = false,
  });

  final Widget child;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: dark
                  ? const <Color>[
                      Color(0xFF052942),
                      Color(0xFF0A4E78),
                      Color(0xFF0E7FB0),
                    ]
                  : const <Color>[
                      Color(0xFFF3F9FF),
                      Color(0xFFE4F1FE),
                      Color(0xFFD8EBFC),
                    ],
            ),
          ),
        ),
        _orb(
          top: -90,
          left: -70,
          size: 230,
          color: dark ? const Color(0x55A6F2FF) : const Color(0x66C4E7FF),
        ),
        _orb(
          top: 140,
          right: -90,
          size: 210,
          color: dark ? const Color(0x44B2FFD7) : const Color(0x55D7F3FF),
        ),
        _orb(
          bottom: -70,
          left: 40,
          size: 190,
          color: dark ? const Color(0x44D6D5FF) : const Color(0x55C9E8FF),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: Opacity(
              opacity: dark ? 0.055 : 0.035,
              child: Image.asset(
                'lib/images/icon/app-logo.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Positioned.fill(child: child),
      ],
    );
  }

  Widget _orb({
    double? top,
    double? right,
    double? bottom,
    double? left,
    required double size,
    required Color color,
  }) {
    return Positioned(
      top: top,
      right: right,
      bottom: bottom,
      left: left,
      child: IgnorePointer(
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: <Color>[
                color,
                color.withOpacity(0.1),
                Colors.transparent,
              ],
              stops: const <double>[0.0, 0.55, 1.0],
            ),
          ),
        ),
      ),
    );
  }
}
