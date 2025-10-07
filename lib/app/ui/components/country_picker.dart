import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/config/app_colors.dart';

/// Country Picker
class CountryPicker {
  /// Show country picker
  static void show(
    BuildContext context, {
    required void Function(Country country) onSelect,
  }) {
    showCountryPicker(
      context: context,
      countryListTheme: CountryListThemeData(
        flagSize: 16.h,
        backgroundColor: AppColors.kffffff,
        textStyle: GoogleFonts.poppins(
          fontSize: 14.sp,
          color: AppColors.k000000,
          fontWeight: FontWeight.w400,
        ),
        bottomSheetHeight: 550.h,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(20).r,
          topRight: const Radius.circular(20).r,
        ),
        //Optional. Styles the search field.
        inputDecoration: const InputDecoration(
          labelText: 'Search',
          hintText: 'Start typing to search',
          prefixIcon: Icon(Icons.search),
          enabledBorder: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(),
          border: OutlineInputBorder(),
        ),
      ),
      favorite: <String>[
        'US',
      ],
      showPhoneCode: true,
      onSelect: onSelect,
    );
  }
}
