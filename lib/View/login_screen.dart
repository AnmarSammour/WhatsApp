import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  String _selectedCountryCode = '970';
  String _selectedCountryName = 'Palestine';

  void _showCountryPicker() {
    showCountryPicker(
      context: context,
      onSelect: (Country country) {
        setState(() {
          _selectedCountryCode = country.phoneCode;
          _selectedCountryName = country.name;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),

      ),
    );
  }
}
