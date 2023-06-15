// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui' show lerpDouble;
import 'dart:ui' as ui show BoxHeightStyle, BoxWidthStyle;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../adaptive_text_selection_toolbar.dart';
import '../color_extensions.dart';
import '../color_scheme.dart';
import '../colors.dart';
import '../desktop_text_selection.dart';
import '../magnifier.dart';
import '../material_state.dart';
import '../spell_check_suggestions_toolbar.dart';
import '../state_theme.dart';
import '../text_extensions.dart';
import '../text_selection.dart';
import '../text_theme.dart';
import '../theme.dart';
import '../theme_data.dart';
import 'input_decorator.dart';
import 'text_field.dart';
import 'widgets/editable_text.dart';
import 'widgets/proxies.dart';
import 'widgets/spell_check.dart';

/// Applies a text field theme to descendant [TextField]s.
class TextFieldTheme extends InheritedTheme {
  /// Applies the given theme [data] to [child].
  ///
  /// The [data] and [child] arguments must not be null.
  const TextFieldTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// Specifies the color, shape, and text style values for descendant
  /// text field widgets.
  final TextFieldThemeData data;

  /// Returns the data from the closest [TextFieldTheme] instance that encloses
  /// the given context.
  ///
  /// Defaults to the ambient [ThemeData.textFieldTheme] if there is no
  /// [TextFieldTheme] in the given build context.
  ///
  /// {@tool snippet}
  ///
  /// ```dart
  /// class Spaceship extends StatelessWidget {
  ///   const Spaceship({super.key});
  ///
  ///   @override
  ///   Widget build(BuildContext context) {
  ///     return TextFieldTheme(
  ///       data: TextFieldTheme.of(context).copyWith(backgroundColor: Colors.red),
  ///       child: TextField(
  ///       ),
  ///     );
  ///   }
  /// }
  /// ```
  /// {@end-tool}
  ///
  /// See also:
  ///
  ///  * [TextFieldThemeData], which describes the actual configuration of a chip
  ///    theme.
  static TextFieldThemeData of(BuildContext context) {
    final TextFieldTheme? inheritedTheme =
        context.dependOnInheritedWidgetOfExactType<TextFieldTheme>();
    return inheritedTheme?.data ?? Theme.of(context).textFieldTheme;
  }

  /// Return a [TextFieldThemeData] that merges the nearest ancestor [TextFieldTheme]
  /// and the [TextFieldThemeData] provided by the nearest [Theme].
  ///
  /// A current context theme can also be provided, used when the
  /// StateThemeData is passed as a parameter to a widget other than
  /// StateTheme.
  ///
  /// See also:
  ///
  /// * [BuildContext.dependOnInheritedWidgetOfExactType]
  static TextFieldThemeData resolve(
    BuildContext context, [
    TextFieldThemeData? currentContextTheme,
  ]) {
    final ancestorTheme =
        context.dependOnInheritedWidgetOfExactType<TextFieldTheme>()?.data;
    final List<TextFieldThemeData> ancestorThemes = [
      Theme.of(context).textFieldTheme,
      if (ancestorTheme != null) ancestorTheme,
      if (currentContextTheme != null) currentContextTheme,
    ];
    if (ancestorThemes.length > 1) {
      return ancestorThemes
          .reduce((acc, e) => acc.mergeWith(e))
          .withContext(context);
    }
    return ancestorThemes.first.withContext(context);
  }

  @override
  bool updateShouldNotify(TextFieldTheme oldWidget) {
    return oldWidget.data != data;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return TextFieldTheme(data: data, child: child);
  }
}

/// Holds the color, shape, and text styles for a Material Design text field.
@immutable
class TextFieldThemeData with Diagnosticable {
  ///
  const TextFieldThemeData({
    this.style = TextFieldStyle.filled,
    StateThemeData? stateTheme,
    StateLayerTheme? stateLayers,
    TextMagnifierConfiguration? magnifierConfiguration,
    TextStyle? textStyle,
    TextStyle? misspelledTextStyle,
    TextStyle? emptyLabelTextStyle,
    TextStyle? floatingLabelTextStyle,
    TextStyle? supportingTextStyle,
    int? supportingTextMinLines,
    int? supportingTextMaxLines,
    int? errorTextMaxLines,
    double? leadingIconSize,
    double? trailingIconSize,
    MouseCursor? leadingIconMouseCursor,
    MouseCursor? trailingIconMouseCursor,
    bool? alwaysShowPrefix,
    bool? alwaysShowSuffix,
    FloatingLabelBehavior? floatingLabelBehavior,
    MaterialStateProperty<Color>? textColor,
    MaterialStateProperty<Color>? labelColor,
    MaterialStateProperty<Color>? placeholderTextColor,
    MaterialStateProperty<Color>? prefixTextColor,
    MaterialStateProperty<Color>? suffixTextColor,
    MaterialStateProperty<Color>? supportingTextColor,
    MaterialStateProperty<Color>? leadingIconColor,
    MaterialStateProperty<Color>? trailingIconColor,
    StrutStyle? strutStyle,
    TextAlign? textAlign,
    String? obscuringCharacter,
    SmartDashesType? smartDashesType,
    SmartQuotesType? smartQuotesType,
    MaxLengthEnforcement? maxLengthEnforcement,
    double? cursorWidth,
    double? cursorHeight,
    Radius? cursorRadius,
    bool? cursorOpacityAnimates,
    MaterialStateProperty<Color>? cursorColor,
    MaterialStateProperty<double>? activityIndicatorHeight,
    MaterialStateProperty<Color>? activityIndicatorColor,
    MaterialStateProperty<double>? borderWidth,
    MaterialStateProperty<Color>? borderColor,
    BorderRadius? borderRadius,
    MaterialStateProperty<Color>? containerColor,
    double? containerHeight,
    double? verticalPadding,
    double? inputPadding,
    double? iconPadding,
    double? supportingTextTopPadding,
    double? supportingTextPadding,
    double? labelHorizontalPadding,
    ui.BoxHeightStyle? selectionHeightStyle,
    ui.BoxWidthStyle? selectionWidthStyle,
    Color? selectionColor,
    TextSelectionControls? selectionControls,
    Brightness? keyboardAppearance,
    EdgeInsets? scrollPadding,
    MaterialStateProperty<MouseCursor>? mouseCursor,
    MouseCursorExtent? mouseCursorExtent,
    ScrollPhysics? scrollPhysics,
    Clip? clipBehavior,
    bool? scribbleEnabled,
    bool? enableIMEPersonalizedLearning,
    ContentInsertionConfiguration? contentInsertionConfiguration,
    EditableTextContextMenuBuilderM3? contextMenuBuilder,
    SpellCheckConfigurationM3? spellCheckConfiguration,
    InputCounterWidgetBuilder? buildCounter,
    VisualDensity? visualDensity,
  })  : _stateTheme = stateTheme,
        _stateLayers = stateLayers,
        _magnifierConfiguration = magnifierConfiguration,
        _inputTextStyle = textStyle,
        _misspelledTextStyle = misspelledTextStyle,
        _emptyLabelTextStyle = emptyLabelTextStyle,
        _floatingLabelTextStyle = floatingLabelTextStyle,
        _supportingTextStyle = supportingTextStyle,
        _supportingTextMinLines = supportingTextMinLines,
        _supportingTextMaxLines = supportingTextMaxLines,
        _errorTextMaxLines = errorTextMaxLines,
        _leadingIconSize = leadingIconSize,
        _trailingIconSize = trailingIconSize,
        _leadingIconMouseCursor = leadingIconMouseCursor,
        _trailingIconMouseCursor = trailingIconMouseCursor,
        _alwaysShowPrefix = alwaysShowPrefix,
        _alwaysShowSuffix = alwaysShowSuffix,
        _floatingLabelBehavior = floatingLabelBehavior,
        _textColor = textColor,
        _labelColor = labelColor,
        _placeholderTextColor = placeholderTextColor,
        _prefixTextColor = prefixTextColor,
        _suffixTextColor = suffixTextColor,
        _supportingTextColor = supportingTextColor,
        _leadingIconColor = leadingIconColor,
        _trailingIconColor = trailingIconColor,
        _strutStyle = strutStyle,
        _textAlign = textAlign,
        _obscuringCharacter = obscuringCharacter,
        _smartDashesType = smartDashesType,
        _smartQuotesType = smartQuotesType,
        _maxLengthEnforcement = maxLengthEnforcement,
        _cursorWidth = cursorWidth,
        _cursorHeight = cursorHeight,
        _cursorRadius = cursorRadius,
        _cursorOpacityAnimates = cursorOpacityAnimates,
        _cursorColor = cursorColor,
        _activityIndicatorHeight = activityIndicatorHeight,
        _activityIndicatorColor = activityIndicatorColor,
        _borderWidth = borderWidth,
        _borderColor = borderColor,
        _borderRadius = borderRadius,
        _containerColor = containerColor,
        _containerHeight = containerHeight,
        _verticalPadding = verticalPadding,
        _inputPadding = inputPadding,
        _iconPadding = iconPadding,
        _supportingTextTopPadding = supportingTextTopPadding,
        _supportingTextPadding = supportingTextPadding,
        _labelHorizontalPadding = labelHorizontalPadding,
        _selectionHeightStyle = selectionHeightStyle,
        _selectionWidthStyle = selectionWidthStyle,
        _selectionColor = selectionColor,
        _selectionControls = selectionControls,
        _keyboardAppearance = keyboardAppearance,
        _scrollPadding = scrollPadding,
        _mouseCursor = mouseCursor,
        _mouseCursorExtent = mouseCursorExtent,
        _scrollPhysics = scrollPhysics,
        _clipBehavior = clipBehavior,
        _scribbleEnabled = scribbleEnabled,
        _enableIMEPersonalizedLearning = enableIMEPersonalizedLearning,
        _contentInsertionConfiguration = contentInsertionConfiguration,
        _contextMenuBuilder = contextMenuBuilder,
        _spellCheckConfiguration = spellCheckConfiguration,
        _buildCounter = buildCounter,
        _visualDensity = visualDensity;

  TextFieldThemeData._clone(TextFieldThemeData other)
      : style = other.style,
        _stateTheme = other._stateTheme,
        _stateLayers = other._stateLayers,
        _magnifierConfiguration = other._magnifierConfiguration,
        _inputTextStyle = other._inputTextStyle,
        _misspelledTextStyle = other._misspelledTextStyle,
        _emptyLabelTextStyle = other._emptyLabelTextStyle,
        _floatingLabelTextStyle = other._floatingLabelTextStyle,
        _supportingTextStyle = other._supportingTextStyle,
        _supportingTextMinLines = other._supportingTextMinLines,
        _supportingTextMaxLines = other._supportingTextMaxLines,
        _errorTextMaxLines = other._errorTextMaxLines,
        _leadingIconSize = other._leadingIconSize,
        _trailingIconSize = other._trailingIconSize,
        _leadingIconMouseCursor = other._leadingIconMouseCursor,
        _trailingIconMouseCursor = other._trailingIconMouseCursor,
        _alwaysShowPrefix = other._alwaysShowPrefix,
        _alwaysShowSuffix = other._alwaysShowSuffix,
        _floatingLabelBehavior = other._floatingLabelBehavior,
        _textColor = other._textColor,
        _labelColor = other._labelColor,
        _placeholderTextColor = other._placeholderTextColor,
        _prefixTextColor = other._prefixTextColor,
        _suffixTextColor = other._suffixTextColor,
        _supportingTextColor = other._supportingTextColor,
        _leadingIconColor = other._leadingIconColor,
        _trailingIconColor = other._trailingIconColor,
        _strutStyle = other._strutStyle,
        _textAlign = other._textAlign,
        _obscuringCharacter = other._obscuringCharacter,
        _smartDashesType = other._smartDashesType,
        _smartQuotesType = other._smartQuotesType,
        _maxLengthEnforcement = other._maxLengthEnforcement,
        _cursorWidth = other._cursorWidth,
        _cursorHeight = other._cursorHeight,
        _cursorRadius = other._cursorRadius,
        _cursorOpacityAnimates = other._cursorOpacityAnimates,
        _cursorColor = other._cursorColor,
        _activityIndicatorHeight = other._activityIndicatorHeight,
        _activityIndicatorColor = other._activityIndicatorColor,
        _borderWidth = other._borderWidth,
        _borderColor = other._borderColor,
        _borderRadius = other._borderRadius,
        _containerColor = other._containerColor,
        _containerHeight = other._containerHeight,
        _verticalPadding = other._verticalPadding,
        _inputPadding = other._inputPadding,
        _iconPadding = other._iconPadding,
        _supportingTextTopPadding = other._supportingTextTopPadding,
        _supportingTextPadding = other._supportingTextPadding,
        _labelHorizontalPadding = other._labelHorizontalPadding,
        _selectionHeightStyle = other._selectionHeightStyle,
        _selectionWidthStyle = other._selectionWidthStyle,
        _selectionColor = other._selectionColor,
        _selectionControls = other._selectionControls,
        _keyboardAppearance = other._keyboardAppearance,
        _scrollPadding = other._scrollPadding,
        _mouseCursor = other._mouseCursor,
        _mouseCursorExtent = other._mouseCursorExtent,
        _scrollPhysics = other._scrollPhysics,
        _clipBehavior = other._clipBehavior,
        _scribbleEnabled = other._scribbleEnabled,
        _enableIMEPersonalizedLearning = other._enableIMEPersonalizedLearning,
        _contentInsertionConfiguration = other._contentInsertionConfiguration,
        _contextMenuBuilder = other._contextMenuBuilder,
        _spellCheckConfiguration = other._spellCheckConfiguration,
        _buildCounter = other._buildCounter,
        _visualDensity = other._visualDensity;

  /// Copy this ChipThemeData and set any default values that
  /// require a [BuildContext] set, such as colors and text themes.
  TextFieldThemeData withContext(
    BuildContext context,
  ) =>
      _LateResolvingTextFieldThemeData(this, context);

  final TextFieldStyle style;

  /// Defines the state layer opacities applied to this chip.
  ///
  /// Default value is [ThemeData.stateTheme] .
  StateThemeData get stateTheme => _stateTheme!;
  final StateThemeData? _stateTheme;

  /// Defines the state layers applied to this text field.
  ///
  /// Default color values are [ColorScheme.onSurface] and the
  /// opacities are from [ListTileThemeData.stateThemeData].
  StateLayerTheme get stateLayers => _stateLayers!;
  final StateLayerTheme? _stateLayers;

  /// {@macro flutter.widgets.magnifier.TextMagnifierConfiguration.intro}
  ///
  /// {@macro flutter.widgets.magnifier.intro}
  ///
  /// {@macro flutter.widgets.magnifier.TextMagnifierConfiguration.details}
  ///
  /// By default, builds a [CupertinoTextMagnifier] on iOS and [TextMagnifier]
  /// on Android, and builds nothing on all other platforms. If it is desired to
  /// suppress the magnifier, consider passing [TextMagnifierConfiguration.disabled].
  ///
  /// {@tool dartpad}
  /// This sample demonstrates how to customize the magnifier that this text field uses.
  ///
  /// ** See code in examples/api/lib/widgets/text_magnifier/text_magnifier.0.dart **
  /// {@end-tool}
  TextMagnifierConfiguration get magnifierConfiguration =>
      _magnifierConfiguration ?? TextMagnifier.adaptiveMagnifierConfiguration;
  final TextMagnifierConfiguration? _magnifierConfiguration;

  /// The style to use for the text being edited.
  ///
  /// This text style is also used as the base style for the [decoration].
  ///
  /// If null, defaults to the `titleMedium` text style from the current [Theme].
  TextStyle get inputTextStyle => _inputTextStyle!;
  final TextStyle? _inputTextStyle;

  /// The [TextStyle] used to indicate misspelled words in the Material style.
  ///
  /// See also:
  ///  * [SpellCheckConfigurationM3.misspelledTextStyle], the style configured to
  ///    mark misspelled words with.
  ///  * [CupertinoTextField.cupertinoMisspelledTextStyle], the style configured
  ///    to mark misspelled words with in the Cupertino style.
  TextStyle get misspelledTextStyle => _misspelledTextStyle!;
  final TextStyle? _misspelledTextStyle;

  /// The style to use for the label when it is not floating.
  ///
  /// If null, defaults to [textStyle].
  TextStyle get emptyLabelTextStyle => _emptyLabelTextStyle ?? inputTextStyle;
  final TextStyle? _emptyLabelTextStyle;

  /// The style to use for the label when it is floating.
  ///
  /// If null, defaults to [TextStyle.bodySmall].
  TextStyle get floatingLabelTextStyle => _floatingLabelTextStyle!;
  final TextStyle? _floatingLabelTextStyle;

  /// The style to use for the supporting text and character counter.
  ///
  /// If null, defaults to [TextStyle.bodySmall].
  TextStyle get supportingTextStyle => _supportingTextStyle!;
  final TextStyle? _supportingTextStyle;

  /// The maximum number of lines the [InputDecoration.supportingText],
  /// [InputDecoration.errorText] and [InputDecoration.counterText]
  /// can occupy. If greater than 0, this will pad based on
  /// [supportingTextStyle.height] and [supportingTextTopPadding].
  ///
  /// This can be used to prevent height changes when supporting text
  /// is shown and hidden.
  ///
  /// The default value is 0.
  int get supportingTextMinLines => _supportingTextMinLines ?? 0;
  final int? _supportingTextMinLines;

  /// The maximum number of lines the [InputDecoration.supportingText] can occupy.
  ///
  /// Defaults value is, which means that the [InputDecoration.supportingText] will
  /// be limited to a single line with [TextOverflow.ellipsis].
  ///
  /// See also:
  ///
  ///  * [errorMaxLines], the equivalent but for the [InputDecoration.errorText].
  int get supportingTextMaxLines =>
      _supportingTextMaxLines ?? _supportingTextMinLines ?? 1;
  final int? _supportingTextMaxLines;

  /// The maximum number of lines the [InputDecoration.errorText] can occupy.
  ///
  /// The default value is [supportingTextMaxLines].
  int get errorTextMaxLines => _errorTextMaxLines ?? supportingTextMaxLines;
  final int? _errorTextMaxLines;

  /// Always show the prefix when the label is floating or hidden.
  ///
  /// Defaults to [true].
  bool get alwaysShowPrefix => _alwaysShowPrefix ?? true;
  final bool? _alwaysShowPrefix;

  /// Always show the suffix when the label is floating or hidden.
  ///
  /// Defaults to [true].
  bool get alwaysShowSuffix => _alwaysShowSuffix ?? true;
  final bool? _alwaysShowSuffix;

  /// The color of the text being edited.
  MaterialStateProperty<Color> get textColor => _textColor!;
  final MaterialStateProperty<Color>? _textColor;

  /// The size of the leading icon
  double get leadingIconSize => _leadingIconSize ?? 24.0;
  final double? _leadingIconSize;

  /// The size of the leading icon
  double get trailingIconSize => _trailingIconSize ?? 24.0;
  final double? _trailingIconSize;

  /// Override the default mouse cursor for the leading icon if present.
  ///
  /// The default value is null.
  MouseCursor? get leadingIconMouseCursor => _leadingIconMouseCursor;
  final MouseCursor? _leadingIconMouseCursor;

  /// Override the default mouse cursor for the trailing icon if present.
  ///
  /// The default value is null.
  MouseCursor? get trailingIconMouseCursor => _trailingIconMouseCursor;
  final MouseCursor? _trailingIconMouseCursor;

  /// {@macro flutter.material.inputDecoration.floatingLabelBehavior}
  ///
  /// Defaults to [FloatingLabelBehavior.auto].
  FloatingLabelBehavior get floatingLabelBehavior =>
      _floatingLabelBehavior ?? FloatingLabelBehavior.auto;
  final FloatingLabelBehavior? _floatingLabelBehavior;

  /// The color of the label.
  MaterialStateProperty<Color> get labelColor => _labelColor!;
  final MaterialStateProperty<Color>? _labelColor;

  /// Color of the placeholder text.
  MaterialStateProperty<Color> get placeholderTextColor =>
      _placeholderTextColor!;
  final MaterialStateProperty<Color>? _placeholderTextColor;

  /// Color of the placeholder text.
  ///
  /// Defaults to [placeholderTextColor].
  MaterialStateProperty<Color> get prefixTextColor =>
      _prefixTextColor ?? placeholderTextColor;
  final MaterialStateProperty<Color>? _prefixTextColor;

  /// Color of the placeholder text.
  ///
  /// Defaults to [placeholderTextColor].
  MaterialStateProperty<Color> get suffixTextColor =>
      _suffixTextColor ?? placeholderTextColor;
  final MaterialStateProperty<Color>? _suffixTextColor;

  /// Color of the supporting text.
  MaterialStateProperty<Color> get supportingTextColor => _supportingTextColor!;
  final MaterialStateProperty<Color>? _supportingTextColor;

  /// Color of the leading icon.
  ///
  /// Defaults to [placeholderTextColor].
  MaterialStateProperty<Color> get leadingIconColor =>
      _leadingIconColor ?? placeholderTextColor;
  final MaterialStateProperty<Color>? _leadingIconColor;

  /// Color of the trailing icon.
  MaterialStateProperty<Color> get trailingIconColor => _trailingIconColor!;
  final MaterialStateProperty<Color>? _trailingIconColor;

  /// {@macro flutter.widgets.editableText.strutStyle}
  StrutStyle? get strutStyle => _strutStyle;
  final StrutStyle? _strutStyle;

  /// {@macro flutter.widgets.editableText.textAlign}
  TextAlign get textAlign => _textAlign ?? TextAlign.start;
  final TextAlign? _textAlign;

  /// {@macro flutter.widgets.editableText.obscuringCharacter}
  String get obscuringCharacter => _obscuringCharacter ?? '•';
  final String? _obscuringCharacter;

  /// {@macro flutter.services.TextInputConfiguration.smartDashesType}
  SmartDashesType get smartDashesType =>
      _smartDashesType ?? SmartDashesType.enabled;
  final SmartDashesType? _smartDashesType;

  /// {@macro flutter.services.TextInputConfiguration.smartQuotesType}
  SmartQuotesType get smartQuotesType =>
      _smartQuotesType ?? SmartQuotesType.enabled;
  final SmartQuotesType? _smartQuotesType;

  /// Determines how the [maxLength] limit should be enforced.
  ///
  /// {@macro flutter.services.textFormatter.effectiveMaxLengthEnforcement}
  ///
  /// {@macro flutter.services.textFormatter.maxLengthEnforcement}
  MaxLengthEnforcement get maxLengthEnforcement => _maxLengthEnforcement!;
  final MaxLengthEnforcement? _maxLengthEnforcement;

  /// {@macro flutter.widgets.editableText.cursorWidth}
  double get cursorWidth => _cursorWidth ?? 2.0;
  final double? _cursorWidth;

  /// {@macro flutter.widgets.editableText.cursorHeight}
  double? get cursorHeight => _cursorHeight;
  final double? _cursorHeight;

  /// {@macro flutter.widgets.editableText.cursorRadius}
  Radius? get cursorRadius => _cursorRadius;
  final Radius? _cursorRadius;

  /// {@macro flutter.widgets.editableText.cursorOpacityAnimates}
  bool get cursorOpacityAnimates => _cursorOpacityAnimates!;
  final bool? _cursorOpacityAnimates;

  /// The color of the cursor.
  ///
  /// The cursor indicates the current location of text insertion point in
  /// the field.
  ///
  /// If this is null and the
  /// [ThemeData.platform] is [TargetPlatform.iOS] or [TargetPlatform.macOS]
  /// it will use [CupertinoThemeData.primaryColor]. Otherwise it will use
  /// the value of [ColorScheme.primary] of [ThemeData.colorScheme].
  MaterialStateProperty<Color> get cursorColor => _cursorColor!;
  final MaterialStateProperty<Color>? _cursorColor;

  /// The height of the activity indicator line, if present.
  MaterialStateProperty<double> get activityIndicatorHeight =>
      _activityIndicatorHeight ??
      MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return 1.0;
        }
        if (states.contains(MaterialState.focused)) {
          return 2.0;
        }
        return 1.0;
      });
  final MaterialStateProperty<double>? _activityIndicatorHeight;

  /// The color of the activity indicator line, if present.
  MaterialStateProperty<Color> get activityIndicatorColor =>
      _activityIndicatorColor!;
  final MaterialStateProperty<Color>? _activityIndicatorColor;

  /// The height of the activity indicator line, if present.
  MaterialStateProperty<double> get borderWidth =>
      _borderWidth ??
      MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return 1.0;
        }
        if (states.contains(MaterialState.focused)) {
          return 2.0;
        }
        return 1.0;
      });
  final MaterialStateProperty<double>? _borderWidth;

  /// The color of the box border, if present.
  MaterialStateProperty<Color> get borderColor => _borderColor!;
  final MaterialStateProperty<Color>? _borderColor;

  /// The color of the box border, if present.
  BorderRadius get borderRadius =>
      _borderRadius ?? const BorderRadius.all(Radius.circular(4.0));
  final BorderRadius? _borderRadius;

  MaterialStateProperty<InputBorder> get border => throw UnimplementedError();

  /// The color of the container if present.
  MaterialStateProperty<Color> get containerColor => _containerColor!;
  final MaterialStateProperty<Color>? _containerColor;

  /// The height of the container, excluding any floating
  /// labels when bordered or support text.
  ///
  /// The default value is 56.
  double get containerHeight => _containerHeight ?? 56.0;
  final double? _containerHeight;

  /// The vertical padding when the label is floated above the input text.
  ///
  /// The default value is 8.
  double get verticalPadding => _verticalPadding ?? 8.0;
  final double? _verticalPadding;

  /// The horizontal padding between the input text and the border, or icons if they are
  /// present. The outside horizontal padding of the supporting text and
  /// character counter.
  ///
  /// The default value is 16.
  double get inputPadding => _inputPadding ?? 16.0;
  final double? _inputPadding;

  /// The padding on the outside of an icon.
  ///
  /// The default value is 12.
  double get iconPadding => _iconPadding ?? 12.0;
  final double? _iconPadding;

  /// The supporting text and character counter top padding.
  ///
  /// The default value is 4.
  double get supportingTextTopPadding => _supportingTextTopPadding ?? 4.0;
  final double? _supportingTextTopPadding;

  /// The padding between supporting text and character counter.
  ///
  /// The default is 16.
  double get supportingTextPadding => _supportingTextPadding ?? 16.0;
  final double? _supportingTextPadding;

  /// The horizontal padding around the floating label in an outlined
  /// text field.
  ///
  /// The default value is 4.
  double get labelHorizontalPadding => _labelHorizontalPadding ?? 4.0;
  final double? _labelHorizontalPadding;

  /// Controls how tall the selection highlight boxes are computed to be.
  ///
  /// See [ui.BoxHeightStyle] for details on available styles.
  ui.BoxHeightStyle get selectionHeightStyle =>
      _selectionHeightStyle ?? ui.BoxHeightStyle.tight;
  final ui.BoxHeightStyle? _selectionHeightStyle;

  /// Controls how wide the selection highlight boxes are computed to be.
  ///
  /// See [ui.BoxWidthStyle] for details on available styles.
  ui.BoxWidthStyle get selectionWidthStyle =>
      _selectionWidthStyle ?? ui.BoxWidthStyle.tight;
  final ui.BoxWidthStyle? _selectionWidthStyle;

  /// The background color of selected text.
  Color get selectionColor => _selectionColor!;
  final Color? _selectionColor;

  /// {@macro flutter.widgets.editableText.selectionControls}
  TextSelectionControls get selectionControls => _selectionControls!;
  final TextSelectionControls? _selectionControls;

  /// The appearance of the keyboard.
  ///
  /// This setting is only honored on iOS devices.
  ///
  /// If unset, defaults to [ThemeData.brightness].
  Brightness get keyboardAppearance => _keyboardAppearance!;
  final Brightness? _keyboardAppearance;

  /// {@macro flutter.widgets.editableText.scrollPadding}
  EdgeInsets get scrollPadding => _scrollPadding ?? const EdgeInsets.all(20.0);
  final EdgeInsets? _scrollPadding;

  /// The cursor for a mouse pointer when it enters or is hovering over the
  /// widget.
  ///
  /// If [mouseCursor] is a [MaterialStateProperty<MouseCursor>],
  /// [MaterialStateProperty.resolve] is used for the following [MaterialState]s:
  ///
  ///  * [MaterialState.error].
  ///  * [MaterialState.hovered].
  ///  * [MaterialState.focused].
  ///  * [MaterialState.disabled].
  ///
  /// If this property is null, [MaterialStateMouseCursor.textable] will be used.
  ///
  /// The [mouseCursor] is the only property of [TextField] that controls the
  /// appearance of the mouse pointer. All other properties related to "cursor"
  /// stand for the text cursor, which is usually a blinking vertical line at
  /// the editing position.
  MaterialStateProperty<MouseCursor> get mouseCursor =>
      _mouseCursor ?? MaterialStateMouseCursor.textable;
  final MaterialStateProperty<MouseCursor>? _mouseCursor;

  /// {@macro flutter.widgets.textFieldTheme.TextCursorExtent}
  ///
  /// The default value is [MouseCursorExtent.input].
  MouseCursorExtent get mouseCursorExtent =>
      _mouseCursorExtent ?? MouseCursorExtent.input;
  final MouseCursorExtent? _mouseCursorExtent;

  /// {@macro flutter.widgets.editableText.scrollPhysics}
  ScrollPhysics? get scrollPhysics => _scrollPhysics;
  final ScrollPhysics? _scrollPhysics;

  /// {@macro flutter.material.Material.clipBehavior}
  ///
  /// Defaults to [Clip.hardEdge].
  Clip get clipBehavior => _clipBehavior ?? Clip.hardEdge;
  final Clip? _clipBehavior;

  /// {@macro flutter.widgets.editableText.scribbleEnabled}
  bool get scribbleEnabled => _scribbleEnabled ?? true;
  final bool? _scribbleEnabled;

  /// {@macro flutter.services.TextInputConfiguration.enableIMEPersonalizedLearning}
  bool get enableIMEPersonalizedLearning =>
      _enableIMEPersonalizedLearning ?? true;
  final bool? _enableIMEPersonalizedLearning;

  /// {@macro flutter.widgets.editableText.contentInsertionConfiguration}
  ContentInsertionConfiguration? get contentInsertionConfiguration =>
      _contentInsertionConfiguration;
  final ContentInsertionConfiguration? _contentInsertionConfiguration;

  /// {@macro flutter.widgets.EditableText.contextMenuBuilder}
  ///
  /// If not provided, will build a default menu based on the platform.
  ///
  /// See also:
  ///
  ///  * [AdaptiveTextSelectionToolbar], which is built by default.
  EditableTextContextMenuBuilderM3? get contextMenuBuilder =>
      _contextMenuBuilder ?? _defaultContextMenuBuilder;
  final EditableTextContextMenuBuilderM3? _contextMenuBuilder;

  static Widget _defaultContextMenuBuilder(
      BuildContext context, EditableTextM3State editableTextState) {
    return AdaptiveTextSelectionToolbar.editableText(
      editableTextState: editableTextState,
    );
  }

  /// {@macro flutter.widgets.EditableText.spellCheckConfiguration}
  ///
  /// If [SpellCheckConfigurationM3.misspelledTextStyle] is not specified in this
  /// configuration, then [materialMisspelledTextStyle] is used by default.
  SpellCheckConfigurationM3 get spellCheckConfiguration =>
      _spellCheckConfiguration!;
  final SpellCheckConfigurationM3? _spellCheckConfiguration;

  /// Callback that generates a custom [InputDecoration.counterText] widget.
  ///
  /// See [InputCounterWidgetBuilder] for an explanation of the passed in
  /// arguments. The returned widget will be placed below the line in place of
  /// the default widget built when [InputDecoration.counterText] is specified.
  ///
  /// The returned widget will be wrapped in a [Semantics] widget for
  /// accessibility, but it also needs to be accessible itself. For example,
  /// if returning a Text widget, set the [Text.semanticsLabel] property.
  ///
  /// {@tool snippet}
  /// ```dart
  /// Widget counter(
  ///   BuildContext context,
  ///   {
  ///     required int currentLength,
  ///     required int? maxLength,
  ///     required bool isFocused,
  ///   }
  /// ) {
  ///   return Text(
  ///     '$currentLength of $maxLength characters',
  ///     semanticsLabel: 'character count',
  ///   );
  /// }
  /// ```
  /// {@end-tool}
  ///
  /// If buildCounter returns null, then no counter and no Semantics widget will
  /// be created at all.
  InputCounterWidgetBuilder? get buildCounter => _buildCounter;
  final InputCounterWidgetBuilder? _buildCounter;

  /// {@template flutter.material.text_field.visualDensity}
  /// Defines how compact the text field's layout will be.
  /// {@endtemplate}
  ///
  /// {@macro flutter.material.themedata.visualDensity}
  ///
  /// The default value is [ThemeData.visualDensity].
  ///
  /// See also:
  ///
  ///  * [ThemeData.visualDensity], which specifies the [visualDensity] for all
  ///    widgets within a [Theme].
  VisualDensity get visualDensity => _visualDensity!;
  final VisualDensity? _visualDensity;

  /// Creates a copy of this object but with the given fields replaced with the
  /// new values.
  TextFieldThemeData copyWith({
    TextFieldStyle? style,
    StateThemeData? stateTheme,
    StateLayerTheme? stateLayers,
    TextMagnifierConfiguration? magnifierConfiguration,
    TextStyle? textStyle,
    TextStyle? misspelledTextStyle,
    TextStyle? emptyLabelTextStyle,
    TextStyle? floatingLabelTextStyle,
    TextStyle? supportingTextStyle,
    int? supportingTextMinLines,
    int? supportingTextMaxLines,
    int? errorTextMaxLines,
    double? leadingIconSize,
    double? trailingIconSize,
    MouseCursor? leadingIconMouseCursor,
    MouseCursor? trailingIconMouseCursor,
    bool? alwaysShowPrefix,
    bool? alwaysShowSuffix,
    FloatingLabelBehavior? floatingLabelBehavior,
    MaterialStateProperty<Color>? textColor,
    MaterialStateProperty<Color>? labelColor,
    MaterialStateProperty<Color>? placeholderTextColor,
    MaterialStateProperty<Color>? prefixTextColor,
    MaterialStateProperty<Color>? suffixTextColor,
    MaterialStateProperty<Color>? supportingTextColor,
    MaterialStateProperty<Color>? leadingIconColor,
    MaterialStateProperty<Color>? trailingIconColor,
    StrutStyle? strutStyle,
    TextAlign? textAlign,
    String? obscuringCharacter,
    SmartDashesType? smartDashesType,
    SmartQuotesType? smartQuotesType,
    MaxLengthEnforcement? maxLengthEnforcement,
    double? cursorWidth,
    double? cursorHeight,
    Radius? cursorRadius,
    bool? cursorOpacityAnimates,
    MaterialStateProperty<Color>? cursorColor,
    MaterialStateProperty<double>? activityIndicatorHeight,
    MaterialStateProperty<Color>? activityIndicatorColor,
    MaterialStateProperty<double>? borderWidth,
    MaterialStateProperty<Color>? borderColor,
    BorderRadius? borderRadius,
    MaterialStateProperty<Color>? containerColor,
    double? containerHeight,
    double? verticalPadding,
    double? inputPadding,
    double? iconPadding,
    double? supportingTextTopPadding,
    double? supportingTextPadding,
    double? labelHorizontalPadding,
    ui.BoxHeightStyle? selectionHeightStyle,
    ui.BoxWidthStyle? selectionWidthStyle,
    Color? selectionColor,
    TextSelectionControls? selectionControls,
    Brightness? keyboardAppearance,
    EdgeInsets? scrollPadding,
    MaterialStateProperty<MouseCursor>? mouseCursor,
    MouseCursorExtent? mouseCursorExtent,
    ScrollPhysics? scrollPhysics,
    Clip? clipBehavior,
    bool? scribbleEnabled,
    bool? enableIMEPersonalizedLearning,
    ContentInsertionConfiguration? contentInsertionConfiguration,
    EditableTextContextMenuBuilderM3? contextMenuBuilder,
    SpellCheckConfigurationM3? spellCheckConfiguration,
    InputCounterWidgetBuilder? buildCounter,
    VisualDensity? visualDensity,
  }) {
    return TextFieldThemeData(
      style: style ?? this.style,
      stateTheme: stateTheme ?? _stateTheme,
      stateLayers: stateLayers ?? _stateLayers,
      magnifierConfiguration: magnifierConfiguration ?? _magnifierConfiguration,
      textStyle: textStyle ?? _inputTextStyle,
      misspelledTextStyle: misspelledTextStyle ?? _misspelledTextStyle,
      emptyLabelTextStyle: emptyLabelTextStyle ?? _emptyLabelTextStyle,
      floatingLabelTextStyle: floatingLabelTextStyle ?? _floatingLabelTextStyle,
      supportingTextStyle: supportingTextStyle ?? _supportingTextStyle,
      supportingTextMinLines: supportingTextMinLines ?? _supportingTextMinLines,
      supportingTextMaxLines: supportingTextMaxLines ?? _supportingTextMaxLines,
      errorTextMaxLines: errorTextMaxLines ?? _errorTextMaxLines,
      leadingIconSize: leadingIconSize ?? _leadingIconSize,
      trailingIconSize: trailingIconSize ?? _trailingIconSize,
      leadingIconMouseCursor: leadingIconMouseCursor ?? _leadingIconMouseCursor,
      trailingIconMouseCursor:
          trailingIconMouseCursor ?? _trailingIconMouseCursor,
      alwaysShowPrefix: alwaysShowPrefix ?? _alwaysShowPrefix,
      alwaysShowSuffix: alwaysShowSuffix ?? _alwaysShowSuffix,
      floatingLabelBehavior: floatingLabelBehavior ?? _floatingLabelBehavior,
      textColor: textColor ?? _textColor,
      labelColor: labelColor ?? _labelColor,
      placeholderTextColor: placeholderTextColor ?? _placeholderTextColor,
      prefixTextColor: prefixTextColor ?? _prefixTextColor,
      suffixTextColor: suffixTextColor ?? _suffixTextColor,
      supportingTextColor: supportingTextColor ?? _supportingTextColor,
      leadingIconColor: leadingIconColor ?? _leadingIconColor,
      trailingIconColor: trailingIconColor ?? _trailingIconColor,
      strutStyle: strutStyle ?? _strutStyle,
      textAlign: textAlign ?? _textAlign,
      obscuringCharacter: obscuringCharacter ?? _obscuringCharacter,
      smartDashesType: smartDashesType ?? _smartDashesType,
      smartQuotesType: smartQuotesType ?? _smartQuotesType,
      maxLengthEnforcement: maxLengthEnforcement ?? _maxLengthEnforcement,
      cursorWidth: cursorWidth ?? _cursorWidth,
      cursorHeight: cursorHeight ?? _cursorHeight,
      cursorRadius: cursorRadius ?? _cursorRadius,
      cursorOpacityAnimates: cursorOpacityAnimates ?? _cursorOpacityAnimates,
      cursorColor: cursorColor ?? _cursorColor,
      activityIndicatorHeight:
          activityIndicatorHeight ?? _activityIndicatorHeight,
      activityIndicatorColor: activityIndicatorColor ?? _activityIndicatorColor,
      borderWidth: borderWidth ?? _borderWidth,
      borderColor: borderColor ?? _borderColor,
      borderRadius: borderRadius ?? _borderRadius,
      containerColor: containerColor ?? _containerColor,
      containerHeight: containerHeight ?? _containerHeight,
      verticalPadding: verticalPadding ?? _verticalPadding,
      inputPadding: inputPadding ?? _inputPadding,
      iconPadding: iconPadding ?? _iconPadding,
      supportingTextTopPadding:
          supportingTextTopPadding ?? _supportingTextTopPadding,
      supportingTextPadding: supportingTextPadding ?? _supportingTextPadding,
      labelHorizontalPadding: labelHorizontalPadding ?? _labelHorizontalPadding,
      selectionHeightStyle: selectionHeightStyle ?? _selectionHeightStyle,
      selectionWidthStyle: selectionWidthStyle ?? _selectionWidthStyle,
      selectionColor: selectionColor ?? _selectionColor,
      keyboardAppearance: keyboardAppearance ?? _keyboardAppearance,
      scrollPadding: scrollPadding ?? _scrollPadding,
      selectionControls: selectionControls ?? _selectionControls,
      mouseCursor: mouseCursor ?? _mouseCursor,
      mouseCursorExtent: mouseCursorExtent ?? _mouseCursorExtent,
      scrollPhysics: scrollPhysics ?? _scrollPhysics,
      clipBehavior: clipBehavior ?? _clipBehavior,
      scribbleEnabled: scribbleEnabled ?? _scribbleEnabled,
      enableIMEPersonalizedLearning:
          enableIMEPersonalizedLearning ?? _enableIMEPersonalizedLearning,
      contentInsertionConfiguration:
          contentInsertionConfiguration ?? _contentInsertionConfiguration,
      contextMenuBuilder: contextMenuBuilder ?? _contextMenuBuilder,
      spellCheckConfiguration:
          spellCheckConfiguration ?? _spellCheckConfiguration,
      buildCounter: buildCounter ?? _buildCounter,
      visualDensity: visualDensity ?? _visualDensity,
    );
  }

  /// Creates a copy of this object with fields replaced with the
  /// non-null values from [other].
  TextFieldThemeData mergeWith(TextFieldThemeData? other) {
    return copyWith(
      style: other?.style,
      stateTheme: other?._stateTheme,
      stateLayers: other?._stateLayers,
      textStyle: other?._inputTextStyle,
      misspelledTextStyle: other?._misspelledTextStyle,
      emptyLabelTextStyle: other?._emptyLabelTextStyle,
      floatingLabelTextStyle: other?._floatingLabelTextStyle,
      supportingTextStyle: other?._supportingTextStyle,
      supportingTextMinLines: other?._supportingTextMinLines,
      supportingTextMaxLines: other?._supportingTextMaxLines,
      errorTextMaxLines: other?._errorTextMaxLines,
      leadingIconSize: other?._leadingIconSize,
      trailingIconSize: other?._trailingIconSize,
      leadingIconMouseCursor: other?._leadingIconMouseCursor,
      trailingIconMouseCursor: other?._trailingIconMouseCursor,
      alwaysShowPrefix: other?._alwaysShowPrefix,
      alwaysShowSuffix: other?._alwaysShowSuffix,
      floatingLabelBehavior: other?._floatingLabelBehavior,
      textColor: other?._textColor,
      labelColor: other?._labelColor,
      placeholderTextColor: other?._placeholderTextColor,
      prefixTextColor: other?._prefixTextColor,
      suffixTextColor: other?._suffixTextColor,
      supportingTextColor: other?._supportingTextColor,
      leadingIconColor: other?._leadingIconColor,
      trailingIconColor: other?._trailingIconColor,
      strutStyle: other?._strutStyle,
      textAlign: other?._textAlign,
      obscuringCharacter: other?._obscuringCharacter,
      smartDashesType: other?._smartDashesType,
      smartQuotesType: other?._smartQuotesType,
      maxLengthEnforcement: other?._maxLengthEnforcement,
      cursorWidth: other?._cursorWidth,
      cursorHeight: other?._cursorHeight,
      cursorRadius: other?._cursorRadius,
      cursorOpacityAnimates: other?._cursorOpacityAnimates,
      cursorColor: other?._cursorColor,
      containerHeight: other?._containerHeight,
      verticalPadding: other?._verticalPadding,
      inputPadding: other?._inputPadding,
      iconPadding: other?._iconPadding,
      supportingTextTopPadding: other?._supportingTextTopPadding,
      supportingTextPadding: other?._supportingTextPadding,
      labelHorizontalPadding: other?._labelHorizontalPadding,
      activityIndicatorHeight: other?._activityIndicatorHeight,
      activityIndicatorColor: other?._activityIndicatorColor,
      borderWidth: other?._borderWidth,
      borderColor: other?._borderColor,
      borderRadius: other?._borderRadius,
      containerColor: other?._containerColor,
      selectionHeightStyle: other?._selectionHeightStyle,
      selectionWidthStyle: other?._selectionWidthStyle,
      selectionColor: other?._selectionColor,
      selectionControls: other?._selectionControls,
      keyboardAppearance: other?._keyboardAppearance,
      scrollPadding: other?._scrollPadding,
      mouseCursor: other?._mouseCursor,
      mouseCursorExtent: other?._mouseCursorExtent,
      scrollPhysics: other?._scrollPhysics,
      clipBehavior: other?._clipBehavior,
      scribbleEnabled: other?._scribbleEnabled,
      enableIMEPersonalizedLearning: other?._enableIMEPersonalizedLearning,
      contentInsertionConfiguration: other?._contentInsertionConfiguration,
      contextMenuBuilder: other?._contextMenuBuilder,
      spellCheckConfiguration: other?._spellCheckConfiguration,
      buildCounter: other?._buildCounter,
      visualDensity: other?._visualDensity,
    );
  }

  /// Linearly interpolate between two text field themes.
  ///
  /// The arguments must not be null.
  ///
  /// {@macro dart.ui.shadow.lerp}
  static TextFieldThemeData? lerp(
      TextFieldThemeData? a, TextFieldThemeData? b, double t) {
    return TextFieldThemeData(
      style: (t < 0.5 ? a?.style : b?.style) ?? TextFieldStyle.filled,
      stateTheme: StateThemeData.lerp(a?._stateTheme, b?._stateTheme, t),
      stateLayers: StateLayerTheme.lerp(a?._stateLayers, b?._stateLayers, t),
      magnifierConfiguration:
          t < 0.5 ? a?._magnifierConfiguration : b?._magnifierConfiguration,
      textStyle: TextStyle.lerp(a?._inputTextStyle, b?._inputTextStyle, t),
      misspelledTextStyle:
          TextStyle.lerp(a?._misspelledTextStyle, b?._misspelledTextStyle, t),
      emptyLabelTextStyle:
          TextStyle.lerp(a?._emptyLabelTextStyle, b?._emptyLabelTextStyle, t),
      floatingLabelTextStyle: TextStyle.lerp(
          a?._floatingLabelTextStyle, b?._floatingLabelTextStyle, t),
      supportingTextStyle:
          TextStyle.lerp(a?._supportingTextStyle, b?._supportingTextStyle, t),
      supportingTextMinLines:
          lerpDouble(a?._supportingTextMinLines, b?._supportingTextMinLines, t)
              ?.round(),
      supportingTextMaxLines:
          lerpDouble(a?._supportingTextMaxLines, b?._supportingTextMaxLines, t)
              ?.round(),
      errorTextMaxLines:
          lerpDouble(a?._errorTextMaxLines, b?._errorTextMaxLines, t)?.round(),
      leadingIconSize: lerpDouble(a?._leadingIconSize, b?._leadingIconSize, t),
      trailingIconSize:
          lerpDouble(a?._trailingIconSize, b?._trailingIconSize, t),
      leadingIconMouseCursor:
          t < 0.5 ? a?._leadingIconMouseCursor : b?._leadingIconMouseCursor,
      trailingIconMouseCursor:
          t < 0.5 ? a?._trailingIconMouseCursor : b?._trailingIconMouseCursor,
      alwaysShowPrefix: t < 0.5 ? a?._alwaysShowPrefix : b?._alwaysShowPrefix,
      alwaysShowSuffix: t < 0.5 ? a?._alwaysShowSuffix : b?._alwaysShowSuffix,
      floatingLabelBehavior:
          t < 0.5 ? a?._floatingLabelBehavior : b?._floatingLabelBehavior,
      textColor: MaterialStateProperty.lerpNonNull(
          a?._textColor, b?._textColor, t, ColorExtensions.lerpNonNull),
      labelColor: MaterialStateProperty.lerpNonNull(
          a?._labelColor, b?._labelColor, t, ColorExtensions.lerpNonNull),
      placeholderTextColor: MaterialStateProperty.lerpNonNull(
          a?._placeholderTextColor,
          b?._placeholderTextColor,
          t,
          ColorExtensions.lerpNonNull),
      prefixTextColor: MaterialStateProperty.lerpNonNull(a?._prefixTextColor,
          b?._prefixTextColor, t, ColorExtensions.lerpNonNull),
      suffixTextColor: MaterialStateProperty.lerpNonNull(a?._suffixTextColor,
          b?._suffixTextColor, t, ColorExtensions.lerpNonNull),
      supportingTextColor: MaterialStateProperty.lerpNonNull(
          a?._supportingTextColor,
          b?._supportingTextColor,
          t,
          ColorExtensions.lerpNonNull),
      leadingIconColor: MaterialStateProperty.lerpNonNull(a?._leadingIconColor,
          b?._leadingIconColor, t, ColorExtensions.lerpNonNull),
      trailingIconColor: MaterialStateProperty.lerpNonNull(
          a?._trailingIconColor,
          b?._trailingIconColor,
          t,
          ColorExtensions.lerpNonNull),
      strutStyle: t < 0.5 ? a?._strutStyle : b?._strutStyle,
      textAlign: t < 0.5 ? a?._textAlign : b?._textAlign,
      obscuringCharacter:
          t < 0.5 ? a?._obscuringCharacter : b?._obscuringCharacter,
      smartDashesType: t < 0.5 ? a?._smartDashesType : b?._smartDashesType,
      smartQuotesType: t < 0.5 ? a?._smartQuotesType : b?._smartQuotesType,
      maxLengthEnforcement:
          t < 0.5 ? a?._maxLengthEnforcement : b?._maxLengthEnforcement,
      cursorWidth: lerpDouble(a?._cursorWidth, b?._cursorWidth, t),
      cursorHeight: lerpDouble(a?._cursorHeight, b?._cursorHeight, t),
      cursorRadius: Radius.lerp(a?._cursorRadius, b?._cursorRadius, t),
      cursorOpacityAnimates:
          t < 0.5 ? a?._cursorOpacityAnimates : b?._cursorOpacityAnimates,
      cursorColor: MaterialStateProperty.lerpNonNull(
          a?._cursorColor, b?._cursorColor, t, ColorExtensions.lerpNonNull),
      activityIndicatorHeight: MaterialStateProperty.lerpNonNull(
          a?._activityIndicatorHeight,
          b?._activityIndicatorHeight,
          t,
          _lerpDoubleNonNull),
      activityIndicatorColor: MaterialStateProperty.lerpNonNull(
          a?._activityIndicatorColor,
          b?._activityIndicatorColor,
          t,
          ColorExtensions.lerpNonNull),
      borderWidth: MaterialStateProperty.lerpNonNull(
          a?._borderWidth, b?._borderWidth, t, _lerpDoubleNonNull),
      borderColor: MaterialStateProperty.lerpNonNull(
          a?._borderColor, b?._borderColor, t, ColorExtensions.lerpNonNull),
      borderRadius: BorderRadius.lerp(a?._borderRadius, b?._borderRadius, t),
      containerColor: MaterialStateProperty.lerpNonNull(a?._containerColor,
          b?._containerColor, t, ColorExtensions.lerpNonNull),
      containerHeight: lerpDouble(a?._containerHeight, b?._containerHeight, t),
      verticalPadding: lerpDouble(a?._verticalPadding, b?._verticalPadding, t),
      inputPadding: lerpDouble(a?._inputPadding, b?._inputPadding, t),
      iconPadding: lerpDouble(a?._iconPadding, b?._iconPadding, t),
      supportingTextTopPadding: lerpDouble(
          a?._supportingTextTopPadding, b?._supportingTextTopPadding, t),
      supportingTextPadding:
          lerpDouble(a?._supportingTextPadding, b?._supportingTextPadding, t),
      labelHorizontalPadding:
          lerpDouble(a?._labelHorizontalPadding, b?._labelHorizontalPadding, t),
      selectionHeightStyle:
          t < 0.5 ? a?._selectionHeightStyle : b?._selectionHeightStyle,
      selectionWidthStyle:
          t < 0.5 ? a?._selectionWidthStyle : b?._selectionWidthStyle,
      selectionColor: Color.lerp(a?._selectionColor, b?._selectionColor, t),
      selectionControls:
          t < 0.5 ? a?._selectionControls : b?._selectionControls,
      keyboardAppearance:
          t < 0.5 ? a?._keyboardAppearance : b?._keyboardAppearance,
      scrollPadding: EdgeInsets.lerp(a?._scrollPadding, b?._scrollPadding, t),
      mouseCursor: t < 0.5 ? a?._mouseCursor : b?._mouseCursor,
      mouseCursorExtent:
          t < 0.5 ? a?._mouseCursorExtent : b?._mouseCursorExtent,
      scrollPhysics: t < 0.5 ? a?._scrollPhysics : b?._scrollPhysics,
      clipBehavior: t < 0.5 ? a?._clipBehavior : b?._clipBehavior,
      scribbleEnabled: t < 0.5 ? a?._scribbleEnabled : b?._scribbleEnabled,
      enableIMEPersonalizedLearning: t < 0.5
          ? a?._enableIMEPersonalizedLearning
          : b?._enableIMEPersonalizedLearning,
      contentInsertionConfiguration: t < 0.5
          ? a?._contentInsertionConfiguration
          : b?._contentInsertionConfiguration,
      contextMenuBuilder:
          t < 0.5 ? a?._contextMenuBuilder : b?._contextMenuBuilder,
      spellCheckConfiguration:
          t < 0.5 ? a?._spellCheckConfiguration : b?._spellCheckConfiguration,
      buildCounter: t < 0.5 ? a?._buildCounter : b?._buildCounter,
      visualDensity:
          VisualDensity.lerp(a?._visualDensity, b?._visualDensity, t),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is TextFieldThemeData &&
        other.style == style &&
        other._stateTheme == _stateTheme &&
        other._stateLayers == _stateLayers &&
        other._magnifierConfiguration == _magnifierConfiguration &&
        other._inputTextStyle == _inputTextStyle &&
        other._misspelledTextStyle == _misspelledTextStyle &&
        other._emptyLabelTextStyle == _emptyLabelTextStyle &&
        other._floatingLabelTextStyle == _floatingLabelTextStyle &&
        other._supportingTextStyle == _supportingTextStyle &&
        other._supportingTextMinLines == _supportingTextMinLines &&
        other._supportingTextMaxLines == _supportingTextMaxLines &&
        other._errorTextMaxLines == _errorTextMaxLines &&
        other._leadingIconSize == _leadingIconSize &&
        other._trailingIconSize == _trailingIconSize &&
        other._leadingIconMouseCursor == _leadingIconMouseCursor &&
        other._trailingIconMouseCursor == _trailingIconMouseCursor &&
        other._alwaysShowPrefix == _alwaysShowPrefix &&
        other._alwaysShowSuffix == _alwaysShowSuffix &&
        other._floatingLabelBehavior == _floatingLabelBehavior &&
        other._textColor == _textColor &&
        other._labelColor == _labelColor &&
        other._placeholderTextColor == _placeholderTextColor &&
        other._suffixTextColor == _suffixTextColor &&
        other._suffixTextColor == _suffixTextColor &&
        other._supportingTextColor == _supportingTextColor &&
        other._leadingIconColor == _leadingIconColor &&
        other._trailingIconColor == _trailingIconColor &&
        other._strutStyle == _strutStyle &&
        other._textAlign == _textAlign &&
        other._obscuringCharacter == _obscuringCharacter &&
        other._smartDashesType == _smartDashesType &&
        other._smartQuotesType == _smartQuotesType &&
        other._maxLengthEnforcement == _maxLengthEnforcement &&
        other._cursorWidth == _cursorWidth &&
        other._cursorHeight == _cursorHeight &&
        other._cursorRadius == _cursorRadius &&
        other._cursorOpacityAnimates == _cursorOpacityAnimates &&
        other._cursorColor == _cursorColor &&
        other._containerHeight == _containerHeight &&
        other._verticalPadding == _verticalPadding &&
        other._inputPadding == _inputPadding &&
        other._iconPadding == _iconPadding &&
        other._supportingTextTopPadding == _supportingTextTopPadding &&
        other._supportingTextPadding == _supportingTextPadding &&
        other._labelHorizontalPadding == _labelHorizontalPadding &&
        other._activityIndicatorHeight == _activityIndicatorHeight &&
        other._activityIndicatorColor == _activityIndicatorColor &&
        other._borderWidth == _borderWidth &&
        other._borderColor == _borderColor &&
        other._borderRadius == _borderRadius &&
        other._containerColor == _containerColor &&
        other._selectionHeightStyle == _selectionHeightStyle &&
        other._selectionWidthStyle == _selectionWidthStyle &&
        other._selectionColor == _selectionColor &&
        other._selectionControls == _selectionControls &&
        other._keyboardAppearance == _keyboardAppearance &&
        other._scrollPadding == _scrollPadding &&
        other._mouseCursor == _mouseCursor &&
        other._mouseCursorExtent == _mouseCursorExtent &&
        other._scrollPhysics == _scrollPhysics &&
        other._clipBehavior == _clipBehavior &&
        other._scribbleEnabled == _scribbleEnabled &&
        other._enableIMEPersonalizedLearning ==
            _enableIMEPersonalizedLearning &&
        other._contentInsertionConfiguration ==
            _contentInsertionConfiguration &&
        other._contextMenuBuilder == _contextMenuBuilder &&
        other._spellCheckConfiguration == _spellCheckConfiguration &&
        other._buildCounter == _buildCounter &&
        other._visualDensity == _visualDensity;
  }

  @override
  int get hashCode => Object.hashAll([
        style,
        _stateTheme,
        _stateLayers,
        _magnifierConfiguration,
        _inputTextStyle,
        _misspelledTextStyle,
        _emptyLabelTextStyle,
        _floatingLabelTextStyle,
        _supportingTextStyle,
        _supportingTextMinLines,
        _supportingTextMaxLines,
        _errorTextMaxLines,
        _leadingIconSize,
        _trailingIconSize,
        _leadingIconMouseCursor,
        _trailingIconMouseCursor,
        _alwaysShowPrefix,
        _alwaysShowSuffix,
        _floatingLabelBehavior,
        _textColor,
        _labelColor,
        _placeholderTextColor,
        _prefixTextColor,
        _suffixTextColor,
        _supportingTextColor,
        _leadingIconColor,
        _trailingIconColor,
        _strutStyle,
        _textAlign,
        _obscuringCharacter,
        _smartDashesType,
        _smartQuotesType,
        _maxLengthEnforcement,
        _cursorWidth,
        _cursorHeight,
        _cursorRadius,
        _cursorOpacityAnimates,
        _cursorColor,
        _activityIndicatorHeight,
        _activityIndicatorColor,
        _borderWidth,
        _borderColor,
        _borderRadius,
        _containerColor,
        _containerHeight,
        _verticalPadding,
        _inputPadding,
        _iconPadding,
        _supportingTextTopPadding,
        _supportingTextPadding,
        _labelHorizontalPadding,
        _selectionHeightStyle,
        _selectionWidthStyle,
        _selectionColor,
        _selectionControls,
        _keyboardAppearance,
        _scrollPadding,
        _mouseCursor,
        _mouseCursorExtent,
        _scrollPhysics,
        _clipBehavior,
        _scribbleEnabled,
        _enableIMEPersonalizedLearning,
        _contentInsertionConfiguration,
        _contextMenuBuilder,
        _spellCheckConfiguration,
        _buildCounter,
        _visualDensity,
      ]);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<TextFieldStyle>('style', style,
        defaultValue: null));
    properties.add(DiagnosticsProperty<StateThemeData>(
        'stateTheme', _stateTheme,
        defaultValue: null));
    properties.add(DiagnosticsProperty<StateLayerTheme>(
        'stateLayers', _stateLayers,
        defaultValue: null));
    properties.add(DiagnosticsProperty<TextMagnifierConfiguration>(
        'magnifierConfiguration', _magnifierConfiguration,
        defaultValue: null));
    properties.add(DiagnosticsProperty<TextStyle>('textStyle', _inputTextStyle,
        defaultValue: null));
    properties.add(DiagnosticsProperty<TextStyle>(
        'misspelledTextStyle', _misspelledTextStyle,
        defaultValue: null));
    properties.add(DiagnosticsProperty<TextStyle>(
        'emptyLabelTextStyle', _emptyLabelTextStyle,
        defaultValue: null));
    properties.add(DiagnosticsProperty<TextStyle>(
        'floatingLabelTextStyle', _floatingLabelTextStyle,
        defaultValue: null));
    properties.add(DiagnosticsProperty<TextStyle>(
        'supportingTextStyle', _supportingTextStyle,
        defaultValue: null));
    properties.add(DiagnosticsProperty<int>(
        'supportingTextMinLines', _supportingTextMinLines,
        defaultValue: null));
    properties.add(DiagnosticsProperty<int>(
        'supportingTextMaxLines', _supportingTextMaxLines,
        defaultValue: null));
    properties.add(DiagnosticsProperty<int>(
        'errorTextMaxLines', _errorTextMaxLines,
        defaultValue: null));
    properties.add(DiagnosticsProperty<double>(
        'leadingIconSize', _leadingIconSize,
        defaultValue: null));
    properties.add(DiagnosticsProperty<double>(
        'trailingIconSize', _trailingIconSize,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MouseCursor>(
        'leadingIconMouseCursor', _leadingIconMouseCursor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MouseCursor>(
        'trailingIconMouseCursor', _trailingIconMouseCursor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<bool>(
        'alwaysShowPrefix', _alwaysShowPrefix,
        defaultValue: null));
    properties.add(DiagnosticsProperty<bool>(
        'alwaysShowSuffix', _alwaysShowSuffix,
        defaultValue: null));
    properties.add(DiagnosticsProperty<FloatingLabelBehavior>(
        'floatingLabelBehavior', _floatingLabelBehavior,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<Color>>(
        'textColor', _textColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<Color>>(
        'labelColor', _labelColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<Color>>(
        'placeholderTextColor', _placeholderTextColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<Color>>(
        'prefixTextColor', _prefixTextColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<Color>>(
        'suffixTextColor', _suffixTextColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<Color>>(
        'supportingTextColor', _supportingTextColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<Color>>(
        'leadingIconColor', _leadingIconColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<Color>>(
        'trailingIconColor', _trailingIconColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<StrutStyle>('strutStyle', _strutStyle,
        defaultValue: null));
    properties.add(DiagnosticsProperty<TextAlign>('textAlign', _textAlign,
        defaultValue: null));
    properties.add(DiagnosticsProperty<String>(
        'obscuringCharacter', _obscuringCharacter,
        defaultValue: null));
    properties.add(DiagnosticsProperty<SmartDashesType>(
        'smartDashesType', _smartDashesType,
        defaultValue: null));
    properties.add(DiagnosticsProperty<SmartQuotesType>(
        'smartQuotesType', _smartQuotesType,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaxLengthEnforcement>(
        'maxLengthEnforcement', _maxLengthEnforcement,
        defaultValue: null));
    properties.add(DiagnosticsProperty<double>('cursorWidth', _cursorWidth,
        defaultValue: null));
    properties.add(DiagnosticsProperty<double>('cursorHeight', _cursorHeight,
        defaultValue: null));
    properties.add(DiagnosticsProperty<Radius>('cursorRadius', _cursorRadius,
        defaultValue: null));
    properties.add(DiagnosticsProperty<bool>(
        'cursorOpacityAnimates', _cursorOpacityAnimates,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<Color>>(
        'cursorColor', _cursorColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<Color>>(
        'containerColor', _containerColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<double>(
        'containerHeight', _containerHeight,
        defaultValue: null));
    properties.add(DiagnosticsProperty<double>(
        'verticalPadding', _verticalPadding,
        defaultValue: null));
    properties.add(DiagnosticsProperty<double>('inputPadding', _inputPadding,
        defaultValue: null));
    properties.add(DiagnosticsProperty<double>('iconPadding', _iconPadding,
        defaultValue: null));
    properties.add(DiagnosticsProperty<double>(
        'supportingTextTopPadding', _supportingTextTopPadding,
        defaultValue: null));
    properties.add(DiagnosticsProperty<double>(
        'supportingTextPadding', _supportingTextPadding,
        defaultValue: null));
    properties.add(DiagnosticsProperty<double>(
        'labelHorizontalPadding', _labelHorizontalPadding,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<double>>(
        'activityIndicatorHeight', _activityIndicatorHeight,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<Color>>(
        'activityIndicatorColor', _activityIndicatorColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<double>>(
        'borderWidth', _borderWidth,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<Color>>(
        'borderColor', _borderColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<BorderRadius>(
        'borderRadius', _borderRadius,
        defaultValue: null));
    properties.add(DiagnosticsProperty<ui.BoxHeightStyle>(
        'selectionHeightStyle', _selectionHeightStyle,
        defaultValue: null));
    properties.add(DiagnosticsProperty<ui.BoxWidthStyle>(
        'selectionWidthStyle', _selectionWidthStyle,
        defaultValue: null));
    properties.add(DiagnosticsProperty<Color>('selectionColor', _selectionColor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<TextSelectionControls>(
        'selectionControls', _selectionControls,
        defaultValue: null));
    properties.add(DiagnosticsProperty<Brightness>(
        'keyboardAppearance', _keyboardAppearance,
        defaultValue: null));
    properties.add(DiagnosticsProperty<EdgeInsets>(
        'scrollPadding', _scrollPadding,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MaterialStateProperty<MouseCursor>>(
        'mouseCursor', _mouseCursor,
        defaultValue: null));
    properties.add(DiagnosticsProperty<MouseCursorExtent>(
        'mouseCursorExtent', _mouseCursorExtent,
        defaultValue: null));
    properties.add(DiagnosticsProperty<ScrollPhysics>(
        'scrollPhysics', _scrollPhysics,
        defaultValue: null));
    properties.add(DiagnosticsProperty<Clip>('clipBehavior', _clipBehavior,
        defaultValue: null));
    properties.add(DiagnosticsProperty<bool>(
        'scribbleEnabled', _scribbleEnabled,
        defaultValue: null));
    properties.add(DiagnosticsProperty<bool>(
        'enableIMEPersonalizedLearning', _enableIMEPersonalizedLearning,
        defaultValue: null));
    properties.add(DiagnosticsProperty<ContentInsertionConfiguration>(
        'contentInsertionConfiguration', _contentInsertionConfiguration,
        defaultValue: null));
    properties.add(DiagnosticsProperty<EditableTextContextMenuBuilderM3>(
        'contextMenuBuilder', _contextMenuBuilder,
        defaultValue: null));
    properties.add(DiagnosticsProperty<SpellCheckConfigurationM3>(
        'spellCheckConfiguration', _spellCheckConfiguration,
        defaultValue: null));
    properties.add(DiagnosticsProperty<Function>('buildCounter', _buildCounter,
        defaultValue: null));
    properties.add(DiagnosticsProperty<VisualDensity>(
        'visualDensity', _visualDensity,
        defaultValue: null));
  }
}

/// {@template flutter.widgets.textFieldTheme.TextCursorExtent}
/// Defines where the cursor will show as [TextFieldThemeData.mouseCursor].
/// {@endtemplate}
enum MouseCursorExtent {
  /// Show [TextFieldThemeData.mouseCursor] when any part of the container
  /// is hovered.
  container,

  /// Show [TextFieldThemeData.mouseCursor] only when the input,
  /// non-floating label or placeholder is hovered.
  input,
}

/// The Material 3 decoration style.
enum TextFieldStyle {
  /// A text field with no decoration. These may be collapsed, with
  /// no padding.
  plain,

  /// The filled text field, with a transparent container.
  underlined,

  /// The standard Material 3 filled text field.
  filled,

  /// The standard Material 3 outlined text field.
  outlined,
}

class _LateResolvingTextFieldThemeData extends TextFieldThemeData {
  _LateResolvingTextFieldThemeData(
    super.other,
    this.context,
  ) : super._clone();

  final BuildContext context;

  late final ThemeData _theme = Theme.of(context);
  late final ColorScheme _colors = _theme.colorScheme;
  late final TextTheme _textTheme = _theme.textTheme;

  @override
  StateThemeData get stateTheme => _stateTheme ?? _theme.stateTheme;

  @override
  StateLayerTheme get stateLayers =>
      _stateLayers ??
      (style == TextFieldStyle.outlined
          ? StateLayerTheme()
          : StateLayerTheme(
              hoverColor: StateLayer(
                _colors.onSurface,
                stateTheme.hoverOpacity,
              ),
            ));

  @override
  TextStyle get inputTextStyle => _inputTextStyle ?? _textTheme.titleMedium;

  @override
  TextStyle get misspelledTextStyle => TextStyle(
        decoration: TextDecoration.underline,
        decorationColor: _colors.error,
        decorationStyle: TextDecorationStyle.wavy,
      );

  @override
  TextStyle get floatingLabelTextStyle =>
      _floatingLabelTextStyle ?? _textTheme.bodySmall;

  @override
  TextStyle get supportingTextStyle =>
      _supportingTextStyle ?? _textTheme.bodySmall;

  @override
  MaterialStateProperty<Color> get textColor =>
      _textColor ??
      MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return _colors.onSurface.withOpacity(stateTheme.disabledOpacity);
        }
        return _colors.onSurface;
      });

  @override
  MaterialStateProperty<Color> get labelColor =>
      _labelColor ??
      MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.error)) {
          if (states.contains(MaterialState.hovered)) {
            return _colors.onErrorContainer;
          }
          return _colors.error;
        }
        if (states.contains(MaterialState.disabled)) {
          return _colors.onSurface.withOpacity(stateTheme.disabledOpacity);
        }
        return _colors.onSurfaceVariant;
      });

  @override
  MaterialStateProperty<Color> get placeholderTextColor =>
      _placeholderTextColor ??
      MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return _colors.onSurfaceVariant
              .withOpacity(stateTheme.disabledOpacity);
        }
        return _colors.onSurfaceVariant;
      });

  @override
  MaterialStateProperty<Color> get trailingIconColor =>
      _placeholderTextColor ??
      MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.error)) {
          if (states.contains(MaterialState.hovered)) {
            return _colors.onErrorContainer;
          }
          return _colors.error;
        }
        if (states.contains(MaterialState.disabled)) {
          return _colors.onSurfaceVariant
              .withOpacity(stateTheme.disabledOpacity);
        }
        return _colors.onSurfaceVariant;
      });

  @override
  MaterialStateProperty<Color> get supportingTextColor =>
      _placeholderTextColor ??
      MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.error)) {
          return _colors.error;
        }
        if (states.contains(MaterialState.disabled)) {
          return _colors.onSurfaceVariant
              .withOpacity(stateTheme.disabledOpacity);
        }
        return _colors.onSurfaceVariant;
      });

  @override
  MaxLengthEnforcement get maxLengthEnforcement =>
      _maxLengthEnforcement ??
      LengthLimitingTextInputFormatter.getDefaultMaxLengthEnforcement(
          _theme.platform);

  @override
  bool get cursorOpacityAnimates {
    if (_cursorOpacityAnimates != null) {
      return _cursorOpacityAnimates!;
    }
    switch (_theme.platform) {
      case TargetPlatform.iOS:
        return true;
      case TargetPlatform.macOS:
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return false;
    }
  }

  @override
  MaterialStateProperty<Color> get cursorColor =>
      _cursorColor ??
      MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.error)) {
          return _colors.error;
        }
        switch (_theme.platform) {
          case TargetPlatform.iOS:
          case TargetPlatform.macOS:
            return CupertinoTheme.of(context).primaryColor;
          case TargetPlatform.android:
          case TargetPlatform.fuchsia:
          case TargetPlatform.linux:
          case TargetPlatform.windows:
            return _colors.primary;
        }
      });

  @override
  double? get cursorHeight => _cursorHeight ?? (inputTextStyle.heightInDps);

  @override
  Brightness get keyboardAppearance => _keyboardAppearance ?? _theme.brightness;

  @override
  MaterialStateProperty<Color> get activityIndicatorColor =>
      _activityIndicatorColor ??
      MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return _colors.onSurface.withOpacity(stateTheme.disabledOpacity);
        }
        if (states.contains(MaterialState.error)) {
          if (states.contains(MaterialState.hovered)) {
            return _colors.onErrorContainer;
          }
          return _colors.error;
        }
        if (states.contains(MaterialState.focused)) {
          return _colors.primary;
        }
        if (states.contains(MaterialState.hovered)) {
          return _colors.onSurface;
        }
        return _colors.onSurfaceVariant;
      });

  @override
  MaterialStateProperty<Color> get borderColor =>
      _activityIndicatorColor ??
      MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return _colors.onSurface.withOpacity(stateTheme.disabledOpacityLight);
        }
        if (states.contains(MaterialState.error)) {
          if (states.contains(MaterialState.hovered)) {
            return _colors.onErrorContainer;
          }
          return _colors.error;
        }
        if (states.contains(MaterialState.focused)) {
          return _colors.primary;
        }
        if (states.contains(MaterialState.hovered)) {
          return _colors.onSurface;
        }
        return _colors.outline;
      });

  @override
  MaterialStateProperty<InputBorder> get border =>
      MaterialStateProperty.resolveWith((states) {
        switch (style) {
          case TextFieldStyle.plain:
            return InputBorder.none;
          case TextFieldStyle.underlined:
          case TextFieldStyle.filled:
            return UnderlineInputBorder(
              borderSide: BorderSide(
                color: activityIndicatorColor.resolve(states),
                width: activityIndicatorHeight.resolve(states),
              ),
            );
          case TextFieldStyle.outlined:
            return OutlineInputBorder(
              borderSide: BorderSide(
                color: borderColor.resolve(states),
                width: borderWidth.resolve(states),
              ),
              borderRadius: borderRadius,
              gapPadding: labelHorizontalPadding,
            );
        }
      });

  @override
  MaterialStateProperty<Color> get containerColor =>
      _containerColor ??
      (style == TextFieldStyle.filled
          ? MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.disabled)) {
                return _colors.onSurface
                    .withOpacity(stateTheme.disabledOpacityLightest);
              }
              return _colors.surfaceVariant;
            })
          : const MaterialStatePropertyAll(Colors.transparent));

  @override
  TextSelectionControls get selectionControls {
    if (_selectionControls != null) {
      return _selectionControls!;
    }
    switch (_theme.platform) {
      case TargetPlatform.iOS:
        return cupertinoTextSelectionControls;
      case TargetPlatform.macOS:
        return cupertinoDesktopTextSelectionControls;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        return materialTextSelectionControls;
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return desktopTextSelectionControls;
    }
  }

  @override
  Color get selectionColor {
    if (_selectionColor != null) {
      return _selectionColor!;
    }
    final selectionStyleColor =
        DefaultSelectionStyle.of(context).selectionColor;
    if (selectionStyleColor != null) {
      return selectionStyleColor;
    }
    switch (_theme.platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return CupertinoTheme.of(context).primaryColor.withOpacity(0.40);
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return _colors.primary.withOpacity(0.40);
    }
  }

  @override
  SpellCheckConfigurationM3 get spellCheckConfiguration {
    switch (_theme.platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return SpellCheckConfigutationM3Proxy(
          CupertinoTextField.inferIOSSpellCheckConfiguration(
            _spellCheckConfiguration != null
                ? SpellCheckConfigutationProxy(_spellCheckConfiguration!)
                : null,
          ),
        );
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        if (_spellCheckConfiguration == null ||
            _spellCheckConfiguration ==
                const SpellCheckConfigurationM3.disabled()) {
          return const SpellCheckConfigurationM3.disabled();
        }
        return _spellCheckConfiguration!.copyWith(
          misspelledTextStyle: misspelledTextStyle,
          spellCheckSuggestionsToolbarBuilder:
              _spellCheckConfiguration?.spellCheckSuggestionsToolbarBuilder ??
                  defaultSpellCheckSuggestionsToolbarBuilder,
        );
    }
  }

  @override
  VisualDensity get visualDensity => _visualDensity ?? _theme.visualDensity;

  /// Default builder for [TextField]'s spell check suggestions toolbar.
  ///
  /// On Apple platforms, builds an iOS-style toolbar. Everywhere else, builds
  /// an Android-style toolbar.
  ///
  /// See also:
  ///  * [spellCheckConfiguration], where this is typically specified for
  ///    [TextField].
  ///  * [SpellCheckConfigurationM3.spellCheckSuggestionsToolbarBuilder], the
  ///    parameter for which this is the default value for [TextField].
  ///  * [CupertinoTextField.defaultSpellCheckSuggestionsToolbarBuilder], which
  ///    is like this but specifies the default for [CupertinoTextField].
  @visibleForTesting
  static Widget defaultSpellCheckSuggestionsToolbarBuilder(
    BuildContext context,
    EditableTextM3State editableTextState,
  ) {
    switch (defaultTargetPlatform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return CupertinoSpellCheckSuggestionsToolbar.editableText(
          editableTextState: EditableTextStateProxy(editableTextState),
        );
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return SpellCheckSuggestionsToolbar.editableText(
          editableTextState: editableTextState,
        );
    }
  }
}

double _lerpDoubleNonNull(num? a, num? b, double t) {
  if ((a == b || (a?.isNaN ?? false) && (b?.isNaN ?? false)) && a != null) {
    return a.toDouble();
  }
  a ??= 0.0;
  b ??= 0.0;
  assert(a.isFinite, 'Cannot interpolate between finite and non-finite values');
  assert(b.isFinite, 'Cannot interpolate between finite and non-finite values');
  assert(t.isFinite, 't must be finite when interpolating between values');
  return a * (1.0 - t) + b * t;
}
