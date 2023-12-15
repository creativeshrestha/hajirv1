import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShrimmerList extends StatelessWidget {
  final Widget child;
  const ShrimmerList({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade100,
      highlightColor: Colors.white,
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: 10,
        itemBuilder: (_, i) => child,
        separatorBuilder: (_, i) => const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Divider(),
        ),
      ),
    );
  }
}

class ShrimmerLoading extends StatelessWidget {
  const ShrimmerLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return ShrimmerList(
        child: Container(
            height: 50,
            margin: const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8))));
  }
}
