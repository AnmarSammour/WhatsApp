import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp/view/login/widgets/boxwhats.dart';

class WhatsMynum extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(fontSize: 13.sp, color: Colors.black),
        children: [
          TextSpan(
            text:
                'WhatsApp will need to verify your phone number. Carrier charges may apply. ',
          ),
          WidgetSpan(
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: false, 
                  builder: (BuildContext context) {
                    return BoxWhats();
                  },
                );
              },
              child: Text(
                'What\'s my number?',
                style: TextStyle(
                  color: Color(0xFF02B099),
                  fontSize: 16.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
