import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fvf_flutter/app/data/config/app_colors.dart';

/// Custom Checkbox Widget
class CustomCheckbox extends StatelessWidget {
  /// Constructor for CustomCheckbox
  const CustomCheckbox({
    required this.value,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  /// Value
  final bool value;

  /// Callback when the checkbox value changes
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) => InkWell(
        borderRadius: BorderRadius.circular(8).r,
        focusColor: AppColors.k13C4E5,
        onTap: () => onChanged(!value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: Alignment.center,
          width: 24.w,
          height: 24.h,
          margin: REdgeInsets.only(top: 3, left: 3),
          decoration: BoxDecoration(
            color: value ? AppColors.k13C4E5 : Colors.transparent,
            border: !value ? Border.all(
              color: AppColors.k899699,
              width: 2.w,
            ) : null,
            borderRadius: BorderRadius.circular(8).r,
          ),
          child: value
              ?  Icon(
                  Icons.check,
                  size: 12.sp,
                  color: Colors.white,
                )
              : null,
        ),
      );
}
