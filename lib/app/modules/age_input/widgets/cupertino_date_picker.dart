import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fvf_flutter/app/data/config/app_colors.dart';
import 'package:fvf_flutter/app/utils/app_text_style.dart';

/// Cupertino Date Picker Widget
class CupertinoDatePickerWidget extends StatelessWidget {
  /// Constructor
  const CupertinoDatePickerWidget({
    required this.onDateChanged,
    this.initialDate,
    super.key,
  });

  /// On date changed callback
  final ValueChanged<DateTime> onDateChanged;

  /// Initial date
  final DateTime? initialDate;

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();

    final DateTime selectedInitialDate = initialDate ??
        DateTime(
          now.year - 18,
          now.month,
          now.day,
        );

    final int currentYear = now.year;
    final int initialYear = selectedInitialDate.year;

    final int minYear = currentYear - 100;
    final int maxYear = currentYear;

    final List<int> years =
        List<int>.generate(maxYear - minYear + 1, (int i) => minYear + i);

    final FixedExtentScrollController yearController =
        FixedExtentScrollController(initialItem: initialYear - minYear);
    final FixedExtentScrollController monthController =
        FixedExtentScrollController(initialItem: selectedInitialDate.month - 1);
    final FixedExtentScrollController dayController =
        FixedExtentScrollController(initialItem: selectedInitialDate.day - 1);

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        onDateChanged(selectedInitialDate);
      },
    );

    final List<String> months = <String>[
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    final List<int> days = List<int>.generate(31, (int i) => i + 1);

    return Align(
      child: Container(
        height: 300.h,
        width: 335.w,
        color: Colors.transparent,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              height: 56.h,
              decoration: BoxDecoration(
                color: AppColors.kF1F2F2.withValues(alpha: 0.36),
                borderRadius: BorderRadius.circular(28).r,
              ),
            ),
            Row(
              children: <Widget>[
                _buildColumn<String>(
                  flex: 7,
                  items: months,
                  controller: monthController,
                  onSelected: (int index) {
                    onDateChanged(
                      DateTime(
                        years[yearController.selectedItem],
                        index + 1,
                        days[dayController.selectedItem],
                      ),
                    );
                  },
                ),
                _buildColumn<int>(
                  flex: 3,
                  items: days,
                  controller: dayController,
                  onSelected: (int index) {
                    onDateChanged(
                      DateTime(
                        years[yearController.selectedItem],
                        monthController.selectedItem + 1,
                        days[index],
                      ),
                    );
                  },
                ),
                _buildColumn<int>(
                  flex: 4,
                  items: years,
                  controller: yearController,
                  onSelected: (int index) {
                    onDateChanged(
                      DateTime(
                        years[index],
                        monthController.selectedItem + 1,
                        days[dayController.selectedItem],
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColumn<T>({
    required int flex,
    required List<T> items,
    required FixedExtentScrollController controller,
    required ValueChanged<int> onSelected,
  }) =>
      Expanded(
        flex: flex,
        child: CupertinoPicker.builder(
          scrollController: controller,
          itemExtent: 56.h,
          useMagnifier: true,
          selectionOverlay: const SizedBox.shrink(),
          onSelectedItemChanged: onSelected,
          childCount: items.length,
          itemBuilder: (BuildContext context, int index) => AnimatedBuilder(
            animation: controller,
            builder: (BuildContext context, _) {
              int? selected;
              try {
                selected = controller.selectedItem % items.length;
              } catch (_) {
                selected = null;
              }

              final bool isSelected = selected == index;

              return Center(
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: AppTextStyle.openRunde(
                    fontSize: isSelected ? 24.sp : 18.sp,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: isSelected
                        ? AppColors.kffffff
                        : AppColors.kffffff.withValues(alpha: 0.56),
                  ),
                  child: Text(
                    items[index].toString(),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              );
            },
          ),
        ),
      );
}
