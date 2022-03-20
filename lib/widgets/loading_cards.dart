import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class LoadingCard extends StatelessWidget {
  const LoadingCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Shimmer(
        child: Container(
          height: 200,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        color: Colors.grey[300]!,
        colorOpacity: 0.3,
        direction: const ShimmerDirection.fromLBRT(),
        enabled: true,
        interval: const Duration(
          milliseconds: 50,
        ),
      ),
    );
  }
}
