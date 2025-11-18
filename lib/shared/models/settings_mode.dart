/// Mode for displaying/editing settings
enum SettingsMode {
  /// Read-only display mode
  view,

  /// Editing existing settings
  edit,

  /// Creating new settings
  create,
}

extension SettingsModeExtension on SettingsMode {
  /// Returns true if the mode is read-only
  bool get isReadOnly => this == SettingsMode.view;

  /// Returns true if the mode allows editing
  bool get isEditable => this == SettingsMode.edit || this == SettingsMode.create;

  /// Returns true if creating new settings
  bool get isCreating => this == SettingsMode.create;
}
