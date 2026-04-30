// lib/widgets/particle_background.dart
//
// Animated floating particle layer rendered behind all screens.
// Uses a CustomPainter driven by an AnimationController so every frame
// moves particles upward, wrapping back to the bottom when they exit the top.
// Kept intentionally subtle (low opacity) to not compete with content.

import 'dart:math';
import 'package:flutter/material.dart';

// ── Public widget ─────────────────────────────────────────────────────────────

class ParticleBackground extends StatefulWidget {
  const ParticleBackground({super.key});

  @override
  State<ParticleBackground> createState() => _ParticleBackgroundState();
}

class _ParticleBackgroundState extends State<ParticleBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<_Particle> _particles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    for (int i = 0; i < 20; i++) {
      _particles.add(
        _Particle(
          x: _random.nextDouble(),
          y: _random.nextDouble(),
          speed: 0.05 + _random.nextDouble() * 0.1,
          radius: 2 + _random.nextDouble() * 4,
          opacity: 0.05 + _random.nextDouble() * 0.2,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        for (final p in _particles) {
          p.y -= p.speed * 0.01;
          if (p.y < -0.1) {
            p.y = 1.1;
            p.x = _random.nextDouble();
          }
        }
        return CustomPaint(
          painter: _ParticlePainter(particles: _particles),
          child: const SizedBox.expand(),
        );
      },
    );
  }
}

// ── Internal data + painter (not exported) ────────────────────────────────────

class _Particle {
  double x;
  double y;
  final double speed;
  final double radius;
  final double opacity;

  _Particle({
    required this.x,
    required this.y,
    required this.speed,
    required this.radius,
    required this.opacity,
  });
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;

  _ParticlePainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final paint = Paint()..color = Colors.white.withValues(alpha: p.opacity);
      canvas.drawCircle(
        Offset(p.x * size.width, p.y * size.height),
        p.radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
