import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:whatsapp/controller/cubit/phone_auth/phone_auth_cubit.dart';
import 'package:whatsapp/model/login_model.dart';

class CountryPickerButton {
  static void show(BuildContext context) {
    showCountryPicker(
        context: context,
        onSelect: (Country country) {
          final selectedCountry = LoginModel(
            countryCode: country.phoneCode,
            countryName: country.name,
            phoneNum: '',
          );
          BlocProvider.of<PhoneAuthCubit>(context)
              .selectCountry(selectedCountry);
        });
  }
}
