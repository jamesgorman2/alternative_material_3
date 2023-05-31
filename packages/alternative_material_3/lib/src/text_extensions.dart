import 'dart:ui' as ui show TextHeightBehavior;
import 'package:flutter/widgets.dart';

/// Utility functions on the [Text] object.
extension MaterialTextExtensions on Text {
  /// Produce a copy of the Text with new values.
  ///
  /// Exactly one of [data] or [textSpan] must be supplied.
  Text copyWith({
    String? data,
    InlineSpan? textSpan,
    StrutStyle? strutStyle,
    TextAlign? textAlign,
    TextDirection? textDirection,
    Locale? locale,
    bool? softWrap,
    TextOverflow? overflow,
    double? textScaleFactor,
    int? maxLines,
    String? semanticsLabel,
    TextWidthBasis? textWidthBasis,
    ui.TextHeightBehavior? textHeightBehavior,
    Color? selectionColor,
  }) {
    assert((data != null && textSpan == null) ||
        (data == null && textSpan != null) ||
        (data == null && textSpan == null));

    if (this.data != null) {
      return Text(
        data ?? this.data!,
        strutStyle: strutStyle ?? this.strutStyle,
        textAlign: textAlign ?? this.textAlign,
        textDirection: textDirection ?? this.textDirection,
        locale: locale ?? this.locale,
        softWrap: softWrap ?? this.softWrap,
        overflow: overflow ?? this.overflow,
        textScaleFactor: textScaleFactor ?? this.textScaleFactor,
        maxLines: maxLines ?? this.maxLines,
        semanticsLabel: semanticsLabel ?? this.semanticsLabel,
        textWidthBasis: textWidthBasis ?? this.textWidthBasis,
        textHeightBehavior: textHeightBehavior ?? this.textHeightBehavior,
        selectionColor: selectionColor ?? this.selectionColor,
      );
    }
    return Text.rich(
      textSpan ?? this.textSpan!,
      strutStyle: strutStyle ?? this.strutStyle,
      textAlign: textAlign ?? this.textAlign,
      textDirection: textDirection ?? this.textDirection,
      locale: locale ?? this.locale,
      softWrap: softWrap ?? this.softWrap,
      overflow: overflow ?? this.overflow,
      textScaleFactor: textScaleFactor ?? this.textScaleFactor,
      maxLines: maxLines ?? this.maxLines,
      semanticsLabel: semanticsLabel ?? this.semanticsLabel,
      textWidthBasis: textWidthBasis ?? this.textWidthBasis,
      textHeightBehavior: textHeightBehavior ?? this.textHeightBehavior,
      selectionColor: selectionColor ?? this.selectionColor,
    );
  }
}

/// Utility functions on the [TextStyle] object
extension MaterialTextStyleExtensions on TextStyle {
  /// Return the height in dps.
  ///
  /// Uses defaults of 14 for [fontSize] and 1 for [height].
  double get heightInDps =>
      ((fontSize ?? 14.0) * (height ?? 1)).roundToDouble();
}
