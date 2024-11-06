import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp/view/login/widgets/boxwhats.dart';

class WhatsMynum extends StatelessWidget {
  const WhatsMynum({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: TextStyle(fontSize: 13.sp, color: Colors.black),
        children: [
          const TextSpan(
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
                    return const BoxWhats();
                  },
                );
              },
              child: Text(
                'What\'s my number?',
                style: TextStyle(
                  color: const Color(0xFF02B099),
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
