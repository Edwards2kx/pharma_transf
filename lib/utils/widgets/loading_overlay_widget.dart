import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingOverlayWidget extends StatelessWidget {
  const LoadingOverlayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset('assets/loading_pills.json',
          width: MediaQuery.of(context).size.width * 0.5),
    );
    // return Center(
    //   child: Lottie.asset('assets/loading_animation.json',
    //       width: MediaQuery.of(context).size.width * 0.5),
    // );
  }
}
