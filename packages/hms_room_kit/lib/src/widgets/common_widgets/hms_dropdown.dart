import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:hms_room_kit/src/common/app_color.dart';

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
  const HMSDropDown(
      {super.key,
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
      required this.updateSelectedValue});
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
    final width = MediaQuery.of(context).size.width;
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
              width: width * 0.7,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: themeSurfaceColor,
                  border: Border.all(color: borderColor)),
              offset: const Offset(-10, -10),
            )
          : widget.dropdownStyleData!,
      iconStyleData: widget.iconStyleData == null
          ? IconStyleData(
              icon: const Icon(Icons.keyboard_arrow_down),
              iconEnabledColor: iconColor)
          : widget.iconStyleData!,
      buttonStyleData: widget.buttonStyleData == null
          ? ButtonStyleData(
              width: width * 0.7,
              height: 48,
              decoration: BoxDecoration(
                color: themeSurfaceColor,
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
