library;

///Package imports
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

///Project imports
import 'package:hms_room_kit/hms_room_kit.dart';

///[HMSDropDown] is a dropdown that allows the user to select an item from a list of items
///It is wrapper around the [DropdownButton2] widget and uses 100ms default themes
class HMSDropDown extends StatefulWidget {
  final Key? dropdownKey;
  final Widget? dropdownHint;
  final Widget? dropdownButton;
  final ButtonStyleData? buttonStyleData;
  final DropdownStyleData? dropdownStyleData;
  final MenuItemStyleData? menuItemStyleData;
  final IconStyleData? iconStyleData;
  final List<DropdownMenuItem> dropDownItems;
  final dynamic selectedValue;
  final Function(dynamic) updateSelectedValue;
  final bool isExpanded;
  final double dropdownWidth;
  const HMSDropDown({
    super.key,
    this.dropdownKey,
    this.dropdownHint,
    this.dropdownButton,
    this.buttonStyleData,
    this.dropdownStyleData,
    this.menuItemStyleData,
    required this.dropDownItems,
    this.iconStyleData,
    required this.selectedValue,
    this.isExpanded = true,
    this.dropdownWidth = 48,
    required this.updateSelectedValue,
  });
  @override
  State<HMSDropDown> createState() => _HMSDropDownState();
}

class _HMSDropDownState extends State<HMSDropDown> {
  dynamic _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.selectedValue;
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width - widget.dropdownWidth;
    return DropdownButton2(
      key: widget.dropdownKey,
      hint: widget.dropdownHint,
      items: widget.dropDownItems,
      value: _selectedValue,
      onChanged: (dynamic newvalue) {
        widget.updateSelectedValue(newvalue);
        setState(() {
          _selectedValue = newvalue;
        });
      },
      isExpanded: widget.isExpanded,
      customButton: widget.dropdownButton,
      dropdownStyleData: widget.dropdownStyleData == null
          ? DropdownStyleData(
              width: width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: HMSThemeColors.surfaceDefault,
              ),
            )
          : widget.dropdownStyleData!,
      iconStyleData: widget.iconStyleData == null
          ? IconStyleData(
              icon: const Icon(Icons.keyboard_arrow_down),
              iconEnabledColor: HMSThemeColors.onSurfaceHighEmphasis)
          : widget.iconStyleData!,
      buttonStyleData: widget.buttonStyleData == null
          ? ButtonStyleData(
              width: width,
              height: 48,
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: HMSThemeColors.surfaceDefault,
                borderRadius: BorderRadius.circular(8),
              ),
            )
          : widget.buttonStyleData!,
      menuItemStyleData: widget.menuItemStyleData == null
          ? const MenuItemStyleData(
              height: 48,
            )
          : widget.menuItemStyleData!,
    );
  }
}
