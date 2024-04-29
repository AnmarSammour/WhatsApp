import 'package:flutter/material.dart';
import 'custom_splach_foter.dart';
import 'custom_splach_img.dart';

class SplachViewBody extends StatelessWidget {
  const SplachViewBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.30,
          ),
          // Display the app icon
          const CustomSplachImg(),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.40,
          ),
          const CustomSplachFoter(),
        ],
      ),
    );
  }
}
