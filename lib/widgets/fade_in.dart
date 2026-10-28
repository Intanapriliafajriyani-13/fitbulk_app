import 'package:flutter/material.dart';

/// Animasi eksplisit pemudaran masuk (bab 6): membungkus anak dengan
/// FadeTransition yang digerakkan AnimationController sendiri.
///
/// Mengapa bukan widget animasi implisit? Untuk mendemonstrasikan pola
/// AnimationController + CurvedAnimation secara utuh: dan pola inilah
/// yang dipakai saat Anda butuh kontrol penuh atas durasi, kurva,
/// arah putar, dan listener tiap tick.
class FadeIn extends StatefulWidget {
  const FadeIn({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
  });

  final Widget child;
  final Duration duration;

  @override
  State<FadeIn> createState() => _FadeInState();
}

class _FadeInState extends State<FadeIn> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _opacity = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    // AnimationController adalah resource ticker: wajib dibuang,
    // kalau tidak ticker terus berjalan setelah widget hilang.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: widget.child,
    );
  }
}
