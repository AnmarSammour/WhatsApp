import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import '../Model/country_model.dart';
import '../Model/login_verifyingc_model .dart';
import '../View/login_verifying.dart';

class LogInController {
  CountryModel selectedCountry =
      CountryModel(countryCode: '970', countryName: 'Palestine');

  void showCountryPickerDialog(BuildContext context, Function(CountryModel) onSelect) {
    showCountryPicker(
      context: context,
      onSelect: (Country country) {
        selectedCountry = CountryModel(
          countryCode: country.phoneCode,
          countryName: country.name,
        );
        onSelect(selectedCountry);
      },
    );
  }

void navigateToLoginVerifyingPage(BuildContext context, LoginVerifyingModel model) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => LoginVerifying(loginVerifyingModel: model),
    ),
  );
}

}
