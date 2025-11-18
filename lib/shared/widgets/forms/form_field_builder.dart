import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/settings_mode.dart';

/// Utility class for building form fields that adapt to different settings modes
class SettingsFormFields {
  /// Build a text field that can be read-only or editable based on mode
  static Widget buildTextField({
    required String label,
    required String? value,
    required SettingsMode mode,
    Function(String)? onChanged,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? helperText,
    String? prefix,
    int? maxLines = 1,
  }) {
    if (mode.isReadOnly) {
      return _buildViewField(label, value ?? 'Not set');
    }

    return TextFormField(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        prefixText: prefix,
        helperText: helperText,
      ),
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      onChanged: onChanged,
    );
  }

  /// Build a number field (integer or decimal)
  static Widget buildNumberField({
    required String label,
    required num? value,
    required SettingsMode mode,
    Function(num?)? onChanged,
    bool isDecimal = false,
    String? helperText,
    String? suffix,
  }) {
    if (mode.isReadOnly) {
      final displayValue = value != null
          ? (isDecimal ? value.toStringAsFixed(2) : value.toString())
          : 'Not set';
      final fullValue = suffix != null ? '$displayValue $suffix' : displayValue;
      return _buildViewField(label, fullValue);
    }

    return TextFormField(
      initialValue: value?.toString() ?? '',
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        helperText: helperText,
        suffixText: suffix,
      ),
      keyboardType: TextInputType.numberWithOptions(decimal: isDecimal),
      inputFormatters: [
        if (isDecimal)
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))
        else
          FilteringTextInputFormatter.digitsOnly,
      ],
      onChanged: (text) {
        if (text.isEmpty) {
          onChanged?.call(null);
        } else if (isDecimal) {
          onChanged?.call(double.tryParse(text));
        } else {
          onChanged?.call(int.tryParse(text));
        }
      },
    );
  }

  /// Build a dropdown field
  static Widget buildDropdownField<T>({
    required String label,
    required T? value,
    required List<T> items,
    required SettingsMode mode,
    Function(T?)? onChanged,
    required String Function(T) displayText,
  }) {
    if (mode.isReadOnly) {
      return _buildViewField(
        label,
        value != null ? displayText(value) : 'Not set',
      );
    }

    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      items: items
          .map((item) => DropdownMenuItem(
                value: item,
                child: Text(displayText(item)),
              ))
          .toList(),
      onChanged: onChanged,
    );
  }

  /// Build a switch/toggle field
  static Widget buildSwitchField({
    required String label,
    required bool value,
    required SettingsMode mode,
    Function(bool)? onChanged,
    String? subtitle,
  }) {
    return SwitchListTile(
      title: Text(label),
      subtitle: subtitle != null ? Text(subtitle) : null,
      value: value,
      onChanged: mode.isEditable ? onChanged : null,
    );
  }

  /// Build a read-only info row (used in view mode)
  static Widget _buildViewField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  /// Build a section header
  static Widget buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Build a horizontal divider
  static Widget buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
      child: Divider(),
    );
  }
}
