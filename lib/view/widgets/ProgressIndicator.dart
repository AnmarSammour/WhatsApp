import 'package:flutter/material.dart';

class ProgressIndicatorWidget {
  static void show(BuildContext context) {
    showDialog(
      barrierColor: Colors.white.withOpacity(0),
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        content: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
          ),
        ),
      ),
    );
  }
}








// import 'package:flutter/material.dart';

// class ProgressIndicatorWidget {
//   // This function displays a progress indicator in an AlertDialog
//   void showProgressIndicator(BuildContext context) {
//     AlertDialog alertDialog = const AlertDialog(
//       backgroundColor: Colors.transparent,
//       elevation: 0,
//       content: Center(
//         child: CircularProgressIndicator(
//           valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
//         ),
//       ),
//     );

//     // Show the AlertDialog with the CircularProgressIndicator
//     showDialog(
//       barrierColor: Colors.white.withOpacity(0),
//       barrierDismissible: false,
//       context: context,
//       builder: (context) {
//         return alertDialog;
//       },
//     );
//   }
// }
