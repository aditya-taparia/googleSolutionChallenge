import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// TextFormField
class TextInputField extends StatelessWidget {
  final String label;
  final bool autoFocus;
  final TextEditingController controller;
  final int maxLines;
  final TextInputType? keyboardType;
  final bool? readOnly;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final Widget? prefix;
  final String? Function(String?)? validator;
  final Function()? onTap;
  const TextInputField({
    Key? key,
    required this.label,
    this.autoFocus = true,
    required this.controller,
    this.maxLines = 1,
    this.keyboardType,
    this.readOnly,
    this.maxLength,
    this.validator,
    this.textInputAction,
    this.prefix,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        autofocus: autoFocus,
        onTap: onTap,
        enableInteractiveSelection: true,
        enableIMEPersonalizedLearning: true,
        textInputAction: textInputAction ?? TextInputAction.next,
        decoration: InputDecoration(
          prefix: prefix,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 10.0,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color.fromRGBO(66, 103, 178, 1),
              width: 1.75,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.grey[700]!,
              width: 1.5,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 1.5,
            ),
          ),
          enabled: true,
          labelText: label,
          floatingLabelStyle: const TextStyle(
            color: Color.fromRGBO(66, 103, 178, 1),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          labelStyle: TextStyle(
            color: Colors.grey[700],
            fontSize: 16,
          ),
          alignLabelWithHint: true,
          hintText: 'Enter $label',
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
        cursorColor: const Color.fromRGBO(66, 103, 178, 1),
        cursorHeight: 24,
        textAlignVertical: TextAlignVertical.top,
        autocorrect: true,
        enableSuggestions: true,
        maxLength: maxLength,
        readOnly: readOnly ?? false,
        keyboardType: keyboardType ?? TextInputType.text,
        maxLines: maxLines,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
        onChanged: (value) {},
        onFieldSubmitted: (value) {
          controller.text = value;
        },
        validator: validator,
      ),
    );
  }
}

// DateTime Picker
class DateTimePicker extends StatelessWidget {
  final String label;
  final String? hintText;
  final TextEditingController controller;
  final TextEditingController sendcontroller;
  final String? Function(String?)? validator;
  final bool isEdit;
  const DateTimePicker({
    Key? key,
    required this.label,
    this.hintText,
    required this.controller,
    required this.sendcontroller,
    this.validator,
    this.isEdit = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isEdit) {
      sendcontroller.text = DateTime.now().toString();
    }
    if (!isEdit) {
      controller.text = DateFormat.yMMMMd().format(DateTime.now()).toString();
    }
    DateTime _dateTime = DateTime.now();
    if (isEdit) {
      _dateTime = DateTime.parse(sendcontroller.text);
      if (_dateTime.compareTo(DateTime.now()) > 0) {
        _dateTime = DateTime.now();
      }
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        onTap: () async {
          final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: sendcontroller.text.isNotEmpty ? DateTime.parse(sendcontroller.text) : DateTime.now(),
            initialDatePickerMode: DatePickerMode.day,
            firstDate: !isEdit ? DateTime.now() : _dateTime,
            lastDate: DateTime(
              DateTime.now().year + 1,
            ),
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.light(
                    primary: Color.fromRGBO(66, 103, 178, 1), // header background color
                    onPrimary: Colors.white, // header text color
                    onSurface: Colors.black, // body text color
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                      primary: const Color.fromRGBO(66, 103, 178, 1), // button text color
                    ),
                  ),
                ),
                child: child!,
              );
            },
          );
          if (picked != null) {
            controller.text = DateFormat.yMMMMd().format(picked).toString();
            sendcontroller.text = picked.toString();
          }
        },
        autofocus: true,
        enableInteractiveSelection: true,
        enableIMEPersonalizedLearning: true,
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 10.0,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color.fromRGBO(66, 103, 178, 1),
              width: 1.75,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.grey[700]!,
              width: 1.5,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 1.5,
            ),
          ),
          enabled: true,
          labelText: label,
          floatingLabelStyle: const TextStyle(
            color: Color.fromRGBO(66, 103, 178, 1),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          labelStyle: TextStyle(
            color: Colors.grey[700],
            fontSize: 16,
          ),
          alignLabelWithHint: true,
          hintText: 'Enter $label',
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
        cursorColor: const Color.fromRGBO(66, 103, 178, 1),
        cursorHeight: 24,
        textAlignVertical: TextAlignVertical.top,
        autocorrect: true,
        enableSuggestions: true,
        readOnly: true,
        keyboardType: TextInputType.text,
        maxLines: 1,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
        onChanged: (value) {
          if (controller.text.isEmpty) {
            controller.text = DateFormat.yMMMMd().format(DateTime.now()).toString();
          }
        },
        onFieldSubmitted: (value) {
          controller.text = value;
        },
        validator: validator,
      ),
    );
  }
}

// Dropdown
class DropdownField extends StatelessWidget {
  final String label;
  final void Function(String?)? onChanged;
  final String? Function(String?)? validator;
  final List<String> options;
  final String? initialValue;
  const DropdownField({
    Key? key,
    required this.label,
    this.onChanged,
    this.validator,
    required this.options,
    this.initialValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> _items = options;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DropdownButtonFormField(
        validator: validator,
        value: initialValue,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10.0,
            vertical: 10.0,
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Color.fromRGBO(66, 103, 178, 1),
              width: 1.75,
            ),
            borderRadius: BorderRadius.circular(5),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colors.grey[700]!,
              width: 1.5,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 1.5,
            ),
          ),
          enabled: true,
          labelText: label,
          floatingLabelStyle: const TextStyle(
            color: Color.fromRGBO(66, 103, 178, 1),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          labelStyle: TextStyle(
            color: Colors.grey[700],
            fontSize: 16,
          ),
          alignLabelWithHint: true,
          hintText: 'Select $label',
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
        ),
        items: _items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}
