import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:whatsapp/controller/cubit/login_cubit.dart';
import 'package:whatsapp/model/login_model.dart';

class CountryPickerButton extends StatelessWidget {
  final LoginModel selectedCountry;

  const CountryPickerButton({
    Key? key,
    required this.selectedCountry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showCountryPickerDialog(context);
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            height: 48.h,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    selectedCountry.countryName,
                    style: TextStyle(fontSize: 16.sp),
                    textAlign: TextAlign.center,
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: Color(0xFF02B099),
                ),
              ],
            ),
          ),
          Divider(
            height: 2.h,
            color: Color(0xFF02B099),
          ),
        ],
      ),
    );
  }

  // Show country picker dialog
  void showCountryPickerDialog(BuildContext context) {
    showCountryPicker(
      context: context,
      onSelect: (Country country) {
        final selectedCountry = LoginModel(
          countryCode: country.phoneCode,
          countryName: country.name,
          phoneNum: '',
        );

        BlocProvider.of<LoginCubit>(context).selectCountry(selectedCountry);
      },
    );
  }
}
