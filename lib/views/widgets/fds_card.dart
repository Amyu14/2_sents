import 'package:flutter/material.dart';

class FdsCard extends StatelessWidget {
  final Widget child;
  const FdsCard(this.child, {super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10)
          ),
          elevation: 3,
          child: Container(
           decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10)
           ),
            width: double.infinity,
            height: double.infinity,
            padding: const EdgeInsets.all(12),
            alignment: Alignment.center,
            child: child,
          ),
        ),
        const Positioned(
            right: 10,
            bottom: 10,
            child: Icon(
              Icons.arrow_circle_right_outlined,
              size: 28,
            ))
      ],
    );
  }
}
