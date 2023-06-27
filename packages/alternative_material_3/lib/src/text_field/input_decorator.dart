// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../buttons/button.dart';
import '../color_extensions.dart';
import '../colors.dart';
import '../constants.dart';
import '../material.dart';
import '../material_state.dart';
import '../text_extensions.dart';
import '../theme_data.dart';
import 'input_border.dart';
import 'text_field_theme.dart';

// The duration value extracted from:
// https://github.com/material-components/material-components-android/blob/master/lib/java/com/google/android/material/textfield/TextInputLayout.java
const Duration _kTransitionDuration = Duration(milliseconds: 167);
const Curve _kTransitionCurve = Curves.fastOutSlowIn;

// Defines the gap in the InputDecorator's outline border where the
// floating label will appear.
class _InputBorderGap extends ChangeNotifier {
  double? _start;

  double? get start => _start;

  set start(double? value) {
    if (value != _start) {
      _start = value;
      notifyListeners();
    }
  }

  double _extent = 0.0;

  double get extent => _extent;

  set extent(double value) {
    if (value != _extent) {
      _extent = value;
      notifyListeners();
    }
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes, this class is not used in collection
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is _InputBorderGap &&
        other.start == start &&
        other.extent == extent;
  }

  @override
  // ignore: avoid_equals_and_hash_code_on_mutable_classes, this class is not used in collection
  int get hashCode => Object.hash(start, extent);

  @override
  String toString() => describeIdentity(this);
}

// Used to interpolate between two InputBorders.
class _InputBorderTween extends Tween<InputBorder> {
  _InputBorderTween({super.begin, super.end});

  @override
  InputBorder lerp(double t) => ShapeBorder.lerp(begin, end, t)! as InputBorder;
}

// Passes the _InputBorderGap parameters along to an InputBorder's paint method.
class _InputBorderPainter extends CustomPainter {
  _InputBorderPainter({
    required Listenable repaint,
    required this.borderAnimation,
    required this.border,
    required this.gapAnimation,
    required this.gap,
    required this.textDirection,
    required this.fillColor,
    required this.hoverAnimation,
    required this.hoverColorTween,
  }) : super(repaint: repaint);

  final Animation<double> borderAnimation;
  final _InputBorderTween border;
  final Animation<double> gapAnimation;
  final _InputBorderGap gap;
  final TextDirection textDirection;
  final Color fillColor;
  final ColorTween hoverColorTween;
  final Animation<double> hoverAnimation;

  Color get blendedColor {
    return Color.alphaBlend(
        hoverColorTween.evaluate(hoverAnimation)!, fillColor);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final InputBorder borderValue = border.evaluate(borderAnimation);
    final Rect canvasRect = Offset.zero & size;
    final Color blendedFillColor = blendedColor;
    if (blendedFillColor.alpha > 0) {
      canvas.drawPath(
        borderValue.getOuterPath(canvasRect, textDirection: textDirection),
        Paint()
          ..color = blendedFillColor
          ..style = PaintingStyle.fill,
      );
    }

    borderValue.paint(
      canvas,
      canvasRect,
      gapStart: gap.start,
      gapExtent: gap.extent,
      gapPercentage: gapAnimation.value,
      textDirection: textDirection,
    );
  }

  @override
  bool shouldRepaint(_InputBorderPainter oldPainter) {
    return borderAnimation != oldPainter.borderAnimation ||
        hoverAnimation != oldPainter.hoverAnimation ||
        gapAnimation != oldPainter.gapAnimation ||
        border != oldPainter.border ||
        gap != oldPainter.gap ||
        textDirection != oldPainter.textDirection;
  }

  @override
  String toString() => describeIdentity(this);
}

// An analog of AnimatedContainer, which can animate its shaped border, for
// _InputBorder. This specialized animated container is needed because the
// _InputBorderGap, which is computed at layout time, is required by the
// _InputBorder's paint method.
class _BorderContainer extends StatefulWidget {
  const _BorderContainer({
    required this.border,
    required this.gap,
    required this.gapAnimation,
    required this.fillColor,
    required this.hoverColor,
    required this.isHovering,
  });

  final InputBorder border;
  final _InputBorderGap gap;
  final Animation<double> gapAnimation;
  final Color fillColor;
  final Color hoverColor;
  final bool isHovering;

  @override
  _BorderContainerState createState() => _BorderContainerState();
}

class _BorderContainerState extends State<_BorderContainer>
    with TickerProviderStateMixin {
  static const Duration _kHoverDuration = Duration(milliseconds: 15);

  late AnimationController _controller;
  late AnimationController _hoverColorController;
  late Animation<double> _borderAnimation;
  late _InputBorderTween _border;
  late Animation<double> _hoverAnimation;
  late ColorTween _hoverColorTween;

  @override
  void initState() {
    super.initState();
    _hoverColorController = AnimationController(
      duration: _kHoverDuration,
      value: widget.isHovering ? 1.0 : 0.0,
      vsync: this,
    );
    _controller = AnimationController(
      duration: _kTransitionDuration,
      vsync: this,
    );
    _borderAnimation = CurvedAnimation(
      parent: _controller,
      curve: _kTransitionCurve,
      reverseCurve: _kTransitionCurve.flipped,
    );
    _border = _InputBorderTween(
      begin: widget.border,
      end: widget.border,
    );
    _hoverAnimation = CurvedAnimation(
      parent: _hoverColorController,
      curve: Curves.linear,
    );
    _hoverColorTween = ColorTweenNonNull(end: widget.hoverColor);
  }

  @override
  void dispose() {
    _controller.dispose();
    _hoverColorController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(_BorderContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.border != oldWidget.border) {
      _border = _InputBorderTween(
        begin: oldWidget.border,
        end: widget.border,
      );
      _controller
        ..value = 0.0
        ..forward();
    }
    if (widget.hoverColor != oldWidget.hoverColor) {
      _hoverColorTween = ColorTweenNonNull(end: widget.hoverColor);
    }
    if (widget.isHovering != oldWidget.isHovering) {
      if (widget.isHovering) {
        _hoverColorController.forward();
      } else {
        _hoverColorController.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: _InputBorderPainter(
        repaint: Listenable.merge(<Listenable>[
          _borderAnimation,
          widget.gap,
          _hoverColorController,
        ]),
        borderAnimation: _borderAnimation,
        border: _border,
        gapAnimation: widget.gapAnimation,
        gap: widget.gap,
        textDirection: Directionality.of(context),
        fillColor: widget.fillColor,
        hoverColorTween: _hoverColorTween,
        hoverAnimation: _hoverAnimation,
      ),
    );
  }
}

// Used to "shake" the floating label to the left to the left and right
// when the errorText first appears.
class _Shaker extends AnimatedWidget {
  const _Shaker({
    required Animation<double> animation,
    this.child,
  }) : super(listenable: animation);

  final Widget? child;

  Animation<double> get animation => listenable as Animation<double>;

  double get translateX {
    const double shakeDelta = 4.0;
    final double t = animation.value;
    if (t <= 0.25) {
      return -t * shakeDelta;
    } else if (t < 0.75) {
      return (t - 0.5) * shakeDelta;
    } else {
      return (1.0 - t) * 4.0 * shakeDelta;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.translationValues(translateX, 0.0, 0.0),
      child: child,
    );
  }
}

// Display the helper and error text. When the error text appears
// it fades and the helper text fades out. The error text also
// slides upwards a little when it first appears.
class _SupportingText extends StatefulWidget {
  const _SupportingText({
    this.textAlign,
    this.supportingText,
    this.nonErrorStyle,
    this.supportingTextMaxLines,
    this.errorText,
    this.errorStyle,
    this.errorMaxLines,
  });

  final TextAlign? textAlign;
  final String? supportingText;
  final TextStyle? nonErrorStyle;
  final int? supportingTextMaxLines;
  final String? errorText;
  final TextStyle? errorStyle;
  final int? errorMaxLines;

  @override
  _SupportingTextState createState() => _SupportingTextState();
}

class _SupportingTextState extends State<_SupportingText>
    with SingleTickerProviderStateMixin {
  // If the height of this widget and the counter are zero ("empty") at
  // layout time, no space is allocated for the subtext.
  static const Widget empty = SizedBox.shrink();

  late AnimationController _controller;
  Widget? _supportingText;
  Widget? _error;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: _kTransitionDuration,
      vsync: this,
    );
    if (widget.errorText != null) {
      _error = _buildError();
      _controller.value = 1.0;
    } else if (widget.supportingText != null) {
      _supportingText = _buildSupportingText();
    }
    _controller.addListener(_handleChange);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleChange() {
    setState(() {
      // The _controller's value has changed.
    });
  }

  @override
  void didUpdateWidget(_SupportingText old) {
    super.didUpdateWidget(old);

    final String? newErrorText = widget.errorText;
    final String? newHelperText = widget.supportingText;
    final String? oldErrorText = old.errorText;
    final String? oldHelperText = old.supportingText;

    final bool errorTextStateChanged =
        (newErrorText != null) != (oldErrorText != null);
    final bool helperTextStateChanged = newErrorText == null &&
        (newHelperText != null) != (oldHelperText != null);

    if (errorTextStateChanged || helperTextStateChanged) {
      if (newErrorText != null) {
        _error = _buildError();
        _controller.forward();
      } else if (newHelperText != null) {
        _supportingText = _buildSupportingText();
        _controller.reverse();
      } else {
        _controller.reverse();
      }
    }
  }

  Widget _buildSupportingText() {
    assert(widget.supportingText != null);
    return Semantics(
      container: true,
      child: FadeTransition(
        opacity: Tween<double>(begin: 1.0, end: 0.0).animate(_controller),
        child: Text(
          widget.supportingText!,
          style: widget.nonErrorStyle,
          textAlign: widget.textAlign,
          overflow: TextOverflow.ellipsis,
          maxLines: widget.supportingTextMaxLines,
        ),
      ),
    );
  }

  Widget _buildError() {
    assert(widget.errorText != null);
    return Semantics(
      container: true,
      child: FadeTransition(
        opacity: _controller,
        child: FractionalTranslation(
          translation: Tween<Offset>(
            begin: const Offset(0.0, -0.25),
            end: Offset.zero,
          ).evaluate(_controller.view),
          child: Text(
            widget.errorText!,
            style: widget.errorStyle,
            textAlign: widget.textAlign,
            overflow: TextOverflow.ellipsis,
            maxLines: widget.errorMaxLines,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_controller.isDismissed) {
      _error = null;
      if (widget.supportingText != null) {
        return _supportingText = _buildSupportingText();
      } else {
        _supportingText = null;
        return empty;
      }
    }

    if (_controller.isCompleted) {
      _supportingText = null;
      if (widget.errorText != null) {
        return _error = _buildError();
      } else {
        _error = null;
        return empty;
      }
    }

    if (_supportingText == null && widget.errorText != null) {
      return _buildError();
    }

    if (_error == null && widget.supportingText != null) {
      return _buildSupportingText();
    }

    if (widget.errorText != null) {
      return Stack(
        children: <Widget>[
          FadeTransition(
            opacity: Tween<double>(begin: 1.0, end: 0.0).animate(_controller),
            child: _supportingText,
          ),
          _buildError(),
        ],
      );
    }

    if (widget.supportingText != null) {
      return Stack(
        children: <Widget>[
          _buildSupportingText(),
          FadeTransition(
            opacity: _controller,
            child: _error,
          ),
        ],
      );
    }

    return empty;
  }
}

/// Defines **how** the floating label should behave.
///
/// See also:
///
///  * [InputDecoration.floatingLabelBehavior] which defines the behavior for
///    [InputDecoration.label] or [InputDecoration.labelText].
///  * [FloatingLabelAlignment] which defines **where** the floating label
///    should displayed.
enum FloatingLabelBehavior {
  /// The label will always be positioned within the content, or hidden.
  never,

  /// The label will float when the input is focused, or has content.
  auto,

  /// The label will always float above the content.
  always,
}

// Identifies the children of a _RenderDecorationElement.
enum _DecorationSlot {
  input,
  label,
  hint,
  prefix,
  suffix,
  prefixIcon,
  suffixIcon,
  supportingText,
  counter,
  container,
}

// An analog of InputDecoration for the _Decorator widget.
@immutable
class _Decoration {
  const _Decoration({
    required this.style,
    required this.theme,
    required this.isCollapsed,
    required this.floatingLabelProgress,
    required this.border,
    required this.borderGap,
    required this.isDense,
    this.input,
    this.label,
    this.placeholder,
    this.prefix,
    this.suffix,
    this.prefixIcon,
    this.suffixIcon,
    this.supportingText,
    this.counter,
    this.container,
  });

  final TextFieldStyle style;
  final TextFieldThemeData theme;
  final bool isCollapsed;
  final double floatingLabelProgress;
  final InputBorder border;
  final _InputBorderGap borderGap;
  final bool isDense;
  final Widget? input;
  final Widget? label;
  final Widget? placeholder;
  final Widget? prefix;
  final Widget? suffix;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Widget? supportingText;
  final Widget? counter;
  final Widget? container;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is _Decoration &&
        other.theme == theme &&
        other.isCollapsed == isCollapsed &&
        other.floatingLabelProgress == floatingLabelProgress &&
        other.border == border &&
        other.borderGap == borderGap &&
        other.isDense == isDense &&
        other.input == input &&
        other.label == label &&
        other.placeholder == placeholder &&
        other.prefix == prefix &&
        other.suffix == suffix &&
        other.prefixIcon == prefixIcon &&
        other.suffixIcon == suffixIcon &&
        other.supportingText == supportingText &&
        other.counter == counter &&
        other.container == container;
  }

  @override
  int get hashCode => Object.hash(
        theme,
        floatingLabelProgress,
        border,
        borderGap,
        isDense,
        input,
        label,
        placeholder,
        prefix,
        suffix,
        prefixIcon,
        suffixIcon,
        supportingText,
        counter,
        container,
      );
}

// The workhorse: layout and paint a _Decorator widget's _Decoration.
class _RenderDecoration extends RenderBox
    with SlottedContainerRenderObjectMixin<_DecorationSlot> {
  _RenderDecoration({
    required _Decoration decoration,
    required TextDirection textDirection,
    required bool isFocused,
    required bool expands,
  })  : _decoration = decoration,
        _textDirection = textDirection,
        _isFocused = isFocused,
        _expands = expands;

  RenderBox? get input => childForSlot(_DecorationSlot.input);

  RenderBox? get label => childForSlot(_DecorationSlot.label);

  RenderBox? get placeholder => childForSlot(_DecorationSlot.hint);

  RenderBox? get prefix => childForSlot(_DecorationSlot.prefix);

  RenderBox? get suffix => childForSlot(_DecorationSlot.suffix);

  RenderBox? get prefixIcon => childForSlot(_DecorationSlot.prefixIcon);

  RenderBox? get suffixIcon => childForSlot(_DecorationSlot.suffixIcon);

  RenderBox? get supportingText => childForSlot(_DecorationSlot.supportingText);

  RenderBox? get counter => childForSlot(_DecorationSlot.counter);

  RenderBox? get container => childForSlot(_DecorationSlot.container);

  // The returned list is ordered for hit testing.
  @override
  Iterable<RenderBox> get children {
    return <RenderBox>[
      if (input != null) input!,
      if (prefixIcon != null) prefixIcon!,
      if (suffixIcon != null) suffixIcon!,
      if (prefix != null) prefix!,
      if (suffix != null) suffix!,
      if (label != null) label!,
      if (placeholder != null) placeholder!,
      if (supportingText != null) supportingText!,
      if (counter != null) counter!,
      if (container != null) container!,
    ];
  }

  _Decoration get decoration => _decoration;
  _Decoration _decoration;

  set decoration(_Decoration value) {
    if (_decoration == value) {
      return;
    }
    _decoration = value;
    markNeedsLayout();
  }

  TextDirection get textDirection => _textDirection;
  TextDirection _textDirection;

  set textDirection(TextDirection value) {
    if (_textDirection == value) {
      return;
    }
    _textDirection = value;
    markNeedsLayout();
  }

  bool get isFocused => _isFocused;
  bool _isFocused;

  set isFocused(bool value) {
    if (_isFocused == value) {
      return;
    }
    _isFocused = value;
    markNeedsSemanticsUpdate();
  }

  bool get expands => _expands;
  bool _expands = false;

  set expands(bool value) {
    if (_expands == value) {
      return;
    }
    _expands = value;
    markNeedsLayout();
  }

  bool get hasPrefixIcon => prefixIcon != null;

  bool get hasSuffixIcon => prefixIcon != null;

  bool get hasLabel => label != null;

  bool get hasSupportingText => supportingText != null;

  bool get hasCounter => counter != null || counter?.size.width == 0.0;

  bool get hasSupportingTextBox => hasSupportingText || hasCounter;

  @override
  void visitChildrenForSemantics(RenderObjectVisitor visitor) {
    if (prefix != null) {
      visitor(prefix!);
    }
    if (prefixIcon != null) {
      visitor(prefixIcon!);
    }

    if (label != null) {
      visitor(label!);
    }
    if (placeholder != null &&
        (label == null || decoration.floatingLabelProgress > 0.0)) {
      visitor(placeholder!);
    }

    if (input != null) {
      visitor(input!);
    }
    if (suffixIcon != null) {
      visitor(suffixIcon!);
    }
    if (suffix != null) {
      visitor(suffix!);
    }
    if (container != null) {
      visitor(container!);
    }
    if (supportingText != null) {
      visitor(supportingText!);
    }
    if (counter != null) {
      visitor(counter!);
    }
  }

  @override
  bool get sizedByParent => false;

  double get supportingTextMinHeight =>
      decoration.theme.supportingTextMinLines > 0 || hasSupportingTextBox
          ? decoration.theme.supportingTextTopPadding +
              (decoration.theme.supportingTextStyle.heightInDps *
                  decoration.theme.supportingTextMinLines)
          : 0.0;

  static double _minWidth(RenderBox? box, double height) {
    return box == null ? 0.0 : box.getMinIntrinsicWidth(height);
  }

  static double _maxWidth(RenderBox? box, double height) {
    return box == null ? 0.0 : box.getMaxIntrinsicWidth(height);
  }

  static double _minHeight(RenderBox? box, double width) {
    return box == null ? 0.0 : box.getMinIntrinsicHeight(width);
  }

  static BoxParentData _boxParentData(RenderBox box) =>
      box.parentData! as BoxParentData;

  static Size _layoutBox(RenderBox? box, BoxConstraints constraints) {
    if (box == null) {
      return Size.zero;
    }
    box.layout(constraints, parentUsesSize: true);
    return box.size;
  }

  static void _positionBox(RenderBox? box, Offset offset) {
    if (box != null) {
      final BoxParentData parentData = box.parentData! as BoxParentData;
      parentData.offset = offset;
    }
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    final theme = decoration.theme;
    return (hasPrefixIcon ? theme.iconPadding : 0.0) +
        _minWidth(prefixIcon, height) +
        theme.labelHorizontalPadding +
        _minWidth(prefix, height) +
        math.max(_minWidth(input, height), _minWidth(placeholder, height)) +
        _minWidth(suffix, height) +
        theme.labelHorizontalPadding +
        _minWidth(suffixIcon, height) +
        (hasSuffixIcon ? theme.iconPadding : 0.0);
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    final theme = decoration.theme;
    return (hasPrefixIcon ? theme.iconPadding : 0.0) +
        _maxWidth(prefixIcon, height) +
        theme.labelHorizontalPadding +
        _maxWidth(prefix, height) +
        math.max(_maxWidth(input, height), _maxWidth(placeholder, height)) +
        _maxWidth(suffix, height) +
        theme.labelHorizontalPadding +
        _maxWidth(suffixIcon, height) +
        (hasSuffixIcon ? theme.iconPadding : 0.0);
  }

  double _lineHeight(double width, List<RenderBox?> boxes) {
    double height = 0.0;
    for (final RenderBox? box in boxes) {
      if (box == null) {
        continue;
      }
      height = math.max(_minHeight(box, width), height);
    }
    return height;
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    final theme = decoration.theme;

    final double prefixIconHeight = _minHeight(prefixIcon, width);
    final double prefixIconWidth = _minWidth(prefixIcon, prefixIconHeight);

    final double suffixIconHeight = _minHeight(suffixIcon, width);
    final double suffixIconWidth = _minWidth(suffixIcon, suffixIconHeight);

    final double allHorizontalPadding = (hasPrefixIcon
            ? theme.iconPadding +
                theme.labelHorizontalPadding -
                math.max(prefixIconWidth - theme.leadingIconSize, 0.0)
            : theme.labelHorizontalPadding) +
        (hasSuffixIcon
            ? theme.iconPadding +
                theme.labelHorizontalPadding -
                math.max(suffixIconWidth - theme.leadingIconSize, 0.0)
            : theme.labelHorizontalPadding);
    final containerWidth = math.max(width - allHorizontalPadding, 0.0);

    final double counterHeight =
        _minHeight(counter, width - theme.supportingTextPadding * 2);
    final double counterWidth = _minWidth(counter, counterHeight);

    final double helperErrorAvailableWidth = math.max(
      width -
          (counterWidth == 0.0
              ? theme.supportingTextPadding * 2
              : counterWidth + theme.supportingTextPadding),
      0.0,
    );
    final double helperErrorHeight =
        _minHeight(supportingText, helperErrorAvailableWidth);
    double supportingTextHeight = math.max(counterHeight, helperErrorHeight);
    if (supportingTextHeight > 0.0) {
      supportingTextHeight += theme.supportingTextTopPadding;
    }
    supportingTextHeight = math.max(
      supportingTextHeight,
      supportingTextMinHeight,
    );

    final double prefixHeight = _minHeight(prefix, containerWidth);
    final double prefixWidth = _minWidth(prefix, prefixHeight);

    final double suffixHeight = _minHeight(suffix, containerWidth);
    final double suffixWidth = _minWidth(suffix, suffixHeight);

    final double availableInputWidth = math.max(
        containerWidth -
            prefixWidth -
            suffixWidth -
            prefixIconWidth -
            suffixIconWidth,
        0.0);
    final double inputHeight =
        _lineHeight(availableInputWidth, <RenderBox?>[input, placeholder]);
    final double inputMaxHeight =
        <double>[inputHeight, prefixHeight, suffixHeight].reduce(math.max);

    final Offset densityOffset = theme.visualDensity.baseSizeAdjustment;
    final double contentHeight = theme.verticalPadding +
        (!hasLabel ? 0.0 : theme.floatingLabelTextStyle.heightInDps) +
        inputMaxHeight +
        theme.verticalPadding +
        densityOffset.dy;
    final double containerHeight = <double>[
      contentHeight,
      prefixIconHeight,
      suffixIconHeight
    ].reduce(math.max);
    final double minContainerHeight =
        decoration.isDense || expands ? 0.0 : kMinInteractiveDimension;
    return math.max(containerHeight, minContainerHeight) + supportingTextHeight;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return computeMinIntrinsicHeight(width);
  }

  @override
  double computeDistanceToActualBaseline(TextBaseline baseline) {
    return _boxParentData(input!).offset.dy +
        (input?.computeDistanceToActualBaseline(baseline) ?? 0.0);
  }

  // Records where the label was painted.
  Matrix4? _labelTransform;

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    assert(debugCannotComputeDryLayout(
      reason:
          'Layout requires baseline metrics, which are only available after a full layout.',
    ));
    return Size.zero;
  }

  ChildSemanticsConfigurationsResult _childSemanticsConfigurationDelegate(
      List<SemanticsConfiguration> childConfigs) {
    final ChildSemanticsConfigurationsResultBuilder builder =
        ChildSemanticsConfigurationsResultBuilder();
    List<SemanticsConfiguration>? prefixMergeGroup;
    List<SemanticsConfiguration>? suffixMergeGroup;
    for (final SemanticsConfiguration childConfig in childConfigs) {
      if (childConfig
          .tagsChildrenWith(_InputDecoratorState._kPrefixSemanticsTag)) {
        prefixMergeGroup ??= <SemanticsConfiguration>[];
        prefixMergeGroup.add(childConfig);
      } else if (childConfig
          .tagsChildrenWith(_InputDecoratorState._kSuffixSemanticsTag)) {
        suffixMergeGroup ??= <SemanticsConfiguration>[];
        suffixMergeGroup.add(childConfig);
      } else {
        builder.markAsMergeUp(childConfig);
      }
    }
    if (prefixMergeGroup != null) {
      builder.markAsSiblingMergeGroup(prefixMergeGroup);
    }
    if (suffixMergeGroup != null) {
      builder.markAsSiblingMergeGroup(suffixMergeGroup);
    }
    return builder.build();
  }

  @override
  void describeSemanticsConfiguration(SemanticsConfiguration config) {
    config.childConfigurationsDelegate = _childSemanticsConfigurationDelegate;
  }

  bool get isOutlined => decoration.style == TextFieldStyle.outlined;

  @override
  void performLayout() {
    final BoxConstraints constraints = this.constraints;
    final BoxConstraints looseConstraints = constraints.loosen();

    final theme = decoration.theme;

    /////////////////////////
    // Container
    //
    // layout fixed elements
    final floatingLabelMiddle = theme.floatingLabelTextStyle.heightInDps / 2.0;
    final paddingAboveContainer = isOutlined && theme.includeFloatingLabelInSize
        ? floatingLabelMiddle
        : 0.0;

    final Size prefixIconSize = _layoutBox(prefixIcon, looseConstraints);
    final double prefixIconPaddingAdjustment =
        (prefixIconSize.width - theme.leadingIconSize) / 2.0;
    final Size prefixSize = _layoutBox(prefix, looseConstraints);
    final Size suffixSize = _layoutBox(suffix, looseConstraints);
    final Size suffixIconSize = _layoutBox(suffixIcon, looseConstraints);
    final double suffixIconPaddingAdjustment =
        (suffixIconSize.width - theme.leadingIconSize) / 2.0;

    final double startPadding = hasPrefixIcon
        ? theme.iconPadding - prefixIconPaddingAdjustment
        : theme.inputPadding;
    final double endPrefixIconPadding =
        hasPrefixIcon ? theme.inputPadding - prefixIconPaddingAdjustment : 0.0;
    final double startSuffixIconPadding =
        hasPrefixIcon ? theme.inputPadding - suffixIconPaddingAdjustment : 0.0;
    final double endPadding = hasSuffixIcon
        ? theme.iconPadding - suffixIconPaddingAdjustment
        : theme.inputPadding;

    final BoxConstraints inputConstraints = looseConstraints.copyWith(
      maxWidth: looseConstraints.maxWidth -
          startPadding -
          prefixIconSize.width -
          endPrefixIconPadding -
          prefixSize.width -
          startSuffixIconPadding -
          suffixSize.width -
          suffixIconSize.width -
          endPadding,
    );

    final Size labelSize = _layoutBox(label, inputConstraints);
    final Size placeholderSize = _layoutBox(placeholder, inputConstraints);
    final Size inputSize = _layoutBox(input, inputConstraints);

    // always centered w.r.t. single line height
    final double prefixIconTop = paddingAboveContainer +
        (theme.containerHeight - prefixIconSize.height) / 2.0;
    final double prefixIconStart = startPadding;
    final double prefixIconEnd = prefixIconStart + prefixIconSize.width;

    final double prefixStart = prefixIconEnd + endPrefixIconPadding;
    final double prefixEnd = prefixStart + prefixSize.width;

    final double maxInputElementHeight = math.max(
      labelSize.height,
      math.max(
        placeholderSize.height,
        math.max(
          inputSize.height,
          theme.inputTextStyle.heightInDps,
        ),
      ),
    );

    final double labelFloatingTop;
    if (isOutlined) {
      if (theme.includeFloatingLabelInSize) {
        labelFloatingTop = 0.0;
      } else {
        labelFloatingTop = -floatingLabelMiddle;
      }
    } else {
      labelFloatingTop = theme.verticalPadding;
    }
    final double centeredInputTop = paddingAboveContainer +
        (theme.containerHeight - theme.inputTextStyle.heightInDps) / 2.0;

    final labelFloatingStart =
        _decoration.style == TextFieldStyle.outlined && hasPrefixIcon
            ? prefixIconStart + _decoration.theme.labelHorizontalPadding
            : prefixStart;

    final double labelTop;
    final double labelStart;
    switch (theme.floatingLabelBehavior) {
      case FloatingLabelBehavior.always:
        labelTop = labelFloatingTop;
        labelStart = labelFloatingStart;
      case FloatingLabelBehavior.auto:
        labelTop = lerpDouble(
          centeredInputTop,
          labelFloatingTop,
          decoration.floatingLabelProgress,
        )!;
        labelStart = lerpDouble(
          prefixStart,
          labelFloatingStart,
          decoration.floatingLabelProgress,
        )!;
      case FloatingLabelBehavior.never:
        labelTop = centeredInputTop;
        labelStart = prefixStart;
    }

    final labelEnd = labelStart - labelSize.width;

    final double inputTop = isOutlined || !hasLabel
        ? centeredInputTop
        : lerpDouble(
            centeredInputTop,
            labelTop + theme.floatingLabelTextStyle.heightInDps,
            decoration.floatingLabelProgress,
          )!;
    final double inputStart = prefixEnd;
    final double inputEnd = inputStart + inputSize.width;

    final double suffixStart = inputEnd;
    final double suffixEnd = suffixStart + suffixSize.width;

    final double suffixIconTop = paddingAboveContainer +
        (theme.containerHeight - suffixIconSize.height) / 2.0;
    final double suffixIconStart = suffixEnd + startSuffixIconPadding;
    final double suffixIconEnd = suffixIconStart + suffixIconSize.width;

    final double containerTop = isOutlined ? paddingAboveContainer : 0.0;
    final double containerBottom = containerTop +
        math.max(
          inputTop + maxInputElementHeight + theme.verticalPadding,
          theme.containerHeight,
        );
    const double containerStart = 0.0;
    final double containerEnd = suffixIconEnd + endPadding;

    _layoutBox(
      container,
      BoxConstraints.tightFor(
        width: containerEnd - containerStart,
        height: containerBottom - containerTop,
      ),
    );

    //////////////////////
    // Supporting text
    final Size counterSize = _layoutBox(counter, looseConstraints);
    final BoxConstraints supportingTextConstraints = looseConstraints.tighten(
      width: looseConstraints.maxWidth -
          counterSize.width -
          (hasCounter
              ? (theme.supportingTextPadding * 3)
              : (theme.supportingTextPadding * 2)),
    );
    final Size supportingTextSize =
        _layoutBox(supportingText, supportingTextConstraints);

    final double supportingTextTop =
        containerBottom + theme.supportingTextTopPadding;
    final double supportingTextStart = theme.supportingTextPadding;
    final double supportingTextEnd =
        supportingTextStart + supportingTextSize.width;

    final double counterEnd = containerEnd - theme.supportingTextPadding;
    final double counterStart = counterEnd - counterSize.width;

    //////////////////////
    // Position boxes
    if (textDirection == TextDirection.ltr) {
      _positionBox(container, Offset(containerStart, containerTop));

      _positionBox(label, Offset(labelStart, labelTop));

      _positionBox(input, Offset(inputStart, inputTop));
      _positionBox(placeholder, Offset(inputStart, inputTop));

      _positionBox(prefix, Offset(prefixStart, inputTop));
      _positionBox(suffix, Offset(suffixStart, inputTop));

      _positionBox(prefixIcon, Offset(prefixIconStart, prefixIconTop));
      _positionBox(suffixIcon, Offset(suffixIconStart, suffixIconTop));

      _positionBox(
        supportingText,
        Offset(supportingTextStart, supportingTextTop),
      );
      _positionBox(counter, Offset(counterStart, supportingTextTop));

      if (hasLabel) {
        decoration.borderGap.start = labelStart;
        decoration.borderGap.extent = labelSize.width;

        final double gapStart = labelStart;
        final double gapMiddle = gapStart + labelSize.width / 2.0;
        decoration.borderGap.start = lerpDouble(
          gapMiddle,
          gapStart,
          decoration.floatingLabelProgress,
        );
        decoration.borderGap.extent = lerpDouble(
          0.0,
          labelSize.width,
          decoration.floatingLabelProgress,
        )!;
      } else {
        decoration.borderGap.start = null;
        decoration.borderGap.extent = 0.0;
      }
    } else {
      _positionBox(container, Offset(containerStart, containerTop));

      _positionBox(label, Offset(containerEnd - labelEnd, labelTop));

      _positionBox(input, Offset(containerEnd - inputEnd, inputTop));
      _positionBox(placeholder, Offset(containerEnd - inputEnd, inputTop));

      _positionBox(prefix, Offset(containerEnd - prefixEnd, inputTop));
      _positionBox(suffix, Offset(containerEnd - suffixEnd, inputTop));

      _positionBox(
          prefixIcon, Offset(containerEnd - prefixIconEnd, prefixIconTop));
      _positionBox(
          suffixIcon, Offset(containerEnd - suffixIconEnd, suffixIconTop));

      _positionBox(
        supportingText,
        Offset(containerEnd - supportingTextEnd, supportingTextTop),
      );
      _positionBox(
          counter, Offset(containerEnd - counterEnd, supportingTextTop));

      if (hasLabel) {
        final double gapStart = containerEnd - labelEnd;
        final double gapMiddle = gapStart + labelSize.width / 2.0;
        decoration.borderGap.start = lerpDouble(
          gapMiddle,
          gapStart,
          decoration.floatingLabelProgress,
        );
        decoration.borderGap.extent = lerpDouble(
          0.0,
          labelSize.width,
          decoration.floatingLabelProgress,
        )!;
      } else {
        decoration.borderGap.start = null;
        decoration.borderGap.extent = 0.0;
      }
    }

    //////////////////////
    // Size this
    final double overallWidth = containerEnd;
    final double overallHeight = hasSupportingTextBox
        ? supportingTextTop +
            math.max(
              supportingTextSize.height,
              math.max(
                counterSize.height,
                supportingTextMinHeight,
              ),
            )
        : containerBottom + supportingTextMinHeight;

    size = constraints.constrain(Size(overallWidth, overallHeight));
    assert(size.width == constraints.constrainWidth(overallWidth));
    assert(size.height == constraints.constrainHeight(overallHeight));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    void doPaint(RenderBox? child) {
      if (child != null) {
        context.paintChild(child, _boxParentData(child).offset + offset);
      }
    }

    doPaint(container);
    doPaint(label);

    doPaint(prefix);
    doPaint(suffix);
    doPaint(prefixIcon);
    doPaint(suffixIcon);
    doPaint(placeholder);
    doPaint(input);
    doPaint(supportingText);
    doPaint(counter);
  }

  @override
  bool hitTestSelf(Offset position) => true;

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    for (final RenderBox child in children) {
      // The label must be handled specially since we've transformed it.
      final Offset offset = _boxParentData(child).offset;
      final bool isHit = result.addWithPaintOffset(
        offset: offset,
        position: position,
        hitTest: (BoxHitTestResult result, Offset transformed) {
          assert(transformed == position - offset);
          return child.hitTest(result, position: transformed);
        },
      );
      if (isHit) {
        return true;
      }
    }
    return false;
  }

  @override
  void applyPaintTransform(RenderObject child, Matrix4 transform) {
    if (child == label && _labelTransform != null) {
      final Offset labelOffset = _boxParentData(label!).offset;
      transform
        ..multiply(_labelTransform!)
        ..translate(-labelOffset.dx, -labelOffset.dy);
    }
    super.applyPaintTransform(child, transform);
  }
}

class _Decorator extends RenderObjectWidget
    with SlottedMultiChildRenderObjectWidgetMixin<_DecorationSlot> {
  const _Decorator({
    required this.decoration,
    required this.textDirection,
    required this.isFocused,
    required this.expands,
  });

  final _Decoration decoration;
  final TextDirection textDirection;
  final bool isFocused;
  final bool expands;

  @override
  Iterable<_DecorationSlot> get slots => _DecorationSlot.values;

  @override
  Widget? childForSlot(_DecorationSlot slot) {
    switch (slot) {
      case _DecorationSlot.input:
        return decoration.input;
      case _DecorationSlot.label:
        return decoration.label;
      case _DecorationSlot.hint:
        return decoration.placeholder;
      case _DecorationSlot.prefix:
        return decoration.prefix;
      case _DecorationSlot.suffix:
        return decoration.suffix;
      case _DecorationSlot.prefixIcon:
        return decoration.prefixIcon;
      case _DecorationSlot.suffixIcon:
        return decoration.suffixIcon;
      case _DecorationSlot.supportingText:
        return decoration.supportingText;
      case _DecorationSlot.counter:
        return decoration.counter;
      case _DecorationSlot.container:
        return decoration.container;
    }
  }

  @override
  _RenderDecoration createRenderObject(BuildContext context) {
    return _RenderDecoration(
      decoration: decoration,
      textDirection: textDirection,
      isFocused: isFocused,
      expands: expands,
    );
  }

  @override
  void updateRenderObject(
      BuildContext context, _RenderDecoration renderObject) {
    renderObject
      ..decoration = decoration
      ..expands = expands
      ..isFocused = isFocused
      ..textDirection = textDirection;
  }
}

class _AffixText extends StatelessWidget {
  const _AffixText({
    required this.showAffix,
    this.style,
    required this.child,
    this.semanticsSortKey,
    required this.semanticsTag,
  });

  final bool showAffix;
  final TextStyle? style;
  final Widget child;
  final SemanticsSortKey? semanticsSortKey;
  final SemanticsTag semanticsTag;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle.merge(
      style: style,
      child: AnimatedOpacity(
        duration: _kTransitionDuration,
        curve: _kTransitionCurve,
        opacity: showAffix ? 1.0 : 0.0,
        child: Semantics(
          sortKey: semanticsSortKey,
          tagForChildren: semanticsTag,
          child: child,
        ),
      ),
    );
  }
}

/// Defines the appearance of a Material Design text field.
///
/// [InputDecorator] displays the visual elements of a Material Design text
/// field around its input [child]. The visual elements themselves are defined
/// by an [InputDecoration] object and their layout and appearance depend
/// on the `baseStyle`, `textAlign`, `isFocused`, and `isEmpty` parameters.
///
/// [TextField] uses this widget to decorate its [EditableText] child.
///
/// [InputDecorator] can be used to create widgets that look and behave like a
/// [TextField] but support other kinds of input.
///
/// Requires one of its ancestors to be a [Material] widget. The [child] widget,
/// as well as the decorative widgets specified in [decoration], must have
/// non-negative baselines.
///
/// See also:
///
///  * [TextField], which uses an [InputDecorator] to display a border,
///    labels, and icons, around its [EditableText] child.
///  * [Decoration] and [DecoratedBox], for drawing arbitrary decorations
///    around other widgets.
class InputDecorator extends StatefulWidget {
  /// Creates a widget that displays a border, labels, and icons,
  /// for a [TextField].
  ///
  /// The [expands], and [isEmpty] arguments must not
  /// be null.
  const InputDecorator({
    super.key,
    required this.style,
    required this.theme,
    required this.materialStates,
    required this.decoration,
    this.minLines,
    this.maxLines,
    this.expands = false,
    this.isEmpty = false,
    this.constraints,
    required this.child,
  });

  /// The style used to dertermine layout.
  final TextFieldStyle style;

  /// A resolved [TextFieldThemeData].
  final TextFieldThemeData theme;

  /// The material state to apply.
  final Set<MaterialState> materialStates;

  /// If false [supportingText],[errorText], and [counterText] are not displayed,
  /// and the opacity of the remaining visual elements is reduced.
  ///
  /// This property is true by default.
  bool get enabled => !materialStates.contains(MaterialState.disabled);

  /// The text and styles to use when decorating the child.
  ///
  /// Null [InputDecoration] properties are initialized with the corresponding
  /// values from [ThemeData.inputDecorationTheme].
  ///
  /// Must not be null.
  final InputDecoration decoration;

  /// {@macro flutter.widgets.editableText.maxLines}
  ///  * [expands], which determines whether the field should fill the height of
  ///    its parent.
  final int? maxLines;

  /// {@macro flutter.widgets.editableText.minLines}
  ///  * [expands], which determines whether the field should fill the height of
  ///    its parent.
  final int? minLines;

  /// Whether the input field has focus.
  ///
  /// Determines the position of the label text and the color and weight of the
  /// border.
  ///
  /// Defaults to false.
  ///
  /// See also:
  ///
  ///  * [InputDecoration.hoverColor], which is also blended into the focus
  ///    color and fill color when the [isHovering] is true to produce the final
  ///    color.
  bool get isFocused => materialStates.contains(MaterialState.focused);

  /// Whether the input field is being hovered over by a mouse pointer.
  ///
  /// Determines the container fill color, which is a blend of
  /// [InputDecoration.hoverColor] with [InputDecoration.fillColor] when
  /// true, and [InputDecoration.fillColor] when not.
  ///
  /// Defaults to false.
  bool get isHovering => materialStates.contains(MaterialState.hovered);

  /// If true, the height of the input field will be as large as possible.
  ///
  /// If wrapped in a widget that constrains its child's height, like Expanded
  /// or SizedBox, the input field will only be affected if [expands] is set to
  /// true.
  ///
  /// See [TextField.minLines] and [TextField.maxLines] for related ways to
  /// affect the height of an input. When [expands] is true, both must be null
  /// in order to avoid ambiguity in determining the height.
  ///
  /// Defaults to false.
  final bool expands;

  /// Whether the input field is empty.
  ///
  /// Determines the position of the label text and whether to display the hint
  /// text.
  ///
  /// Defaults to false.
  final bool isEmpty;

  /// Defines minimum and maximum sizes for the [InputDecorator].
  final BoxConstraints? constraints;

  /// The widget below this widget in the tree.
  ///
  /// Typically an [EditableText], [DropdownButton], or [InkWell].
  final Widget child;

  /// Whether the label needs to get out of the way of the input, either by
  /// floating or disappearing.
  ///
  /// Will withdraw when not empty, or when focused while enabled.
  bool get _labelShouldWithdraw => !isEmpty || (isFocused && enabled);

  @override
  State<InputDecorator> createState() => _InputDecoratorState();

  /// The RenderBox that defines this decorator's "container". That's the
  /// area which is filled if [InputDecoration.filled] is true. It's the area
  /// adjacent to [InputDecoration.icon] and above the widgets that contain
  /// [InputDecoration.supportingText], [InputDecoration.errorText], and
  /// [InputDecoration.counterText].
  ///
  /// [TextField] renders ink splashes within the container.
  static RenderBox? containerOf(BuildContext context) {
    final _RenderDecoration? result =
        context.findAncestorRenderObjectOfType<_RenderDecoration>();
    return result?.container;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(DiagnosticsProperty<InputDecoration>('decoration', decoration));
    properties.add(DiagnosticsProperty<bool>('isFocused', isFocused));
    properties.add(
        DiagnosticsProperty<bool>('expands', expands, defaultValue: false));
    properties.add(DiagnosticsProperty<bool>('isEmpty', isEmpty));
  }
}

class _InputDecoratorState extends State<InputDecorator>
    with TickerProviderStateMixin {
  late final AnimationController _floatingLabelController;
  late final Animation<double> _floatingLabelAnimation;
  late final AnimationController _shakingLabelController;
  final _InputBorderGap _borderGap = _InputBorderGap();
  static const OrdinalSortKey _kPrefixSemanticsSortOrder = OrdinalSortKey(0);
  static const OrdinalSortKey _kInputSemanticsSortOrder = OrdinalSortKey(1);
  static const OrdinalSortKey _kSuffixSemanticsSortOrder = OrdinalSortKey(2);
  static const SemanticsTag _kPrefixSemanticsTag =
      SemanticsTag('_InputDecoratorState.prefix');
  static const SemanticsTag _kSuffixSemanticsTag =
      SemanticsTag('_InputDecoratorState.suffix');

  @override
  void initState() {
    super.initState();

    final bool labelIsInitiallyFloating = widget.theme.floatingLabelBehavior ==
            FloatingLabelBehavior.always ||
        (widget.theme.floatingLabelBehavior != FloatingLabelBehavior.never &&
            widget._labelShouldWithdraw);

    _floatingLabelController = AnimationController(
      duration: _kTransitionDuration,
      vsync: this,
      value: labelIsInitiallyFloating ? 1.0 : 0.0,
    );
    _floatingLabelController.addListener(_handleChange);
    _floatingLabelAnimation = CurvedAnimation(
      parent: _floatingLabelController,
      curve: _kTransitionCurve,
      reverseCurve: _kTransitionCurve.flipped,
    );

    _shakingLabelController = AnimationController(
      duration: _kTransitionDuration,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _floatingLabelController.dispose();
    _shakingLabelController.dispose();
    super.dispose();
  }

  void _handleChange() {
    setState(() {
      // The _floatingLabelController's value has changed.
    });
  }

  InputDecoration get decoration => widget.decoration;

  TextAlign? get textAlign => widget.theme.textAlign;

  bool get isFocused => widget.isFocused;

  bool get isHovering =>
      widget.isHovering && widget.enabled && !_suffixIconHovered;

  bool get isEmpty => widget.isEmpty;

  bool get _floatingLabelEnabled {
    return widget.theme.floatingLabelBehavior != FloatingLabelBehavior.never;
  }

  bool _suffixIconHovered = false;

  void _handleSuppressHover(bool entered) {
    if (_suffixIconHovered != entered) {
      setState(() {
        _suffixIconHovered = entered;
      });
    }
  }

  @override
  void didUpdateWidget(InputDecorator old) {
    super.didUpdateWidget(old);
    final bool floatBehaviorChanged =
        widget.theme.floatingLabelBehavior != old.theme.floatingLabelBehavior;

    if (widget._labelShouldWithdraw != old._labelShouldWithdraw ||
        floatBehaviorChanged) {
      if (_floatingLabelEnabled &&
          (widget._labelShouldWithdraw ||
              widget.theme.floatingLabelBehavior ==
                  FloatingLabelBehavior.always)) {
        _floatingLabelController.forward();
      } else {
        _floatingLabelController.reverse();
      }
    }

    final String? errorText = decoration.errorText;
    final String? oldErrorText = old.decoration.errorText;

    if (_floatingLabelController.isCompleted &&
        errorText != null &&
        errorText != oldErrorText) {
      _shakingLabelController
        ..value = 0.0
        ..forward();
    }

    if (old.decoration.suffixIconHasOwnHover !=
        widget.decoration.suffixIconHasOwnHover) {
      _suffixIconHovered = false;
    }
  }

  // True if the label will be shown and the hint will not.
  // If we're not focused, there's no value, labelText was provided, and
  // floatingLabelBehavior isn't set to always, then the label appears where the
  // hint would.
  bool get _hasInlineLabel {
    return !widget._labelShouldWithdraw &&
        decoration.label != null &&
        widget.theme.floatingLabelBehavior != FloatingLabelBehavior.always;
  }

  // If the label is a floating placeholder, it's always shown.
  bool get _shouldShowLabel => _hasInlineLabel || _floatingLabelEnabled;

  Widget wrapMouseCursor({
    required MouseCursor? cursor,
    required Widget child,
    bool suppressHover = false,
  }) {
    if (cursor == null && !suppressHover) {
      return child;
    } else if (cursor == null) {
      return MouseRegion(
        onEnter: suppressHover ? (_) => _handleSuppressHover(true) : null,
        onExit: suppressHover ? (_) => _handleSuppressHover(false) : null,
        child: child,
      );
    }
    return MouseRegion(
      cursor: cursor,
      onEnter: suppressHover ? (_) => _handleSuppressHover(true) : null,
      onExit: suppressHover ? (_) => _handleSuppressHover(false) : null,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final states = widget.materialStates;
    final theme = widget.theme;

    final mouseCursor = theme.mouseCursor.resolve(states);
    final inputMouseCursor =
        theme.mouseCursorExtent == MouseCursorExtent.input ? mouseCursor : null;
    final Widget? placeholder = decoration.placeholderText == null
        ? null
        : wrapMouseCursor(
            cursor: inputMouseCursor,
            child: AnimatedOpacity(
              opacity: (isEmpty && !_hasInlineLabel) ? 1.0 : 0.0,
              duration: _kTransitionDuration,
              curve: _kTransitionCurve,
              alwaysIncludeSemantics: isEmpty || decoration.label == null,
              child: Text(
                decoration.placeholderText!,
                style: theme.inputTextStyle.copyWith(
                    color: theme.placeholderTextColor.resolve(states)),
                overflow:
                    theme.inputTextStyle.overflow ?? TextOverflow.ellipsis,
                textAlign: textAlign,
                maxLines: widget.maxLines,
              ),
            ),
          );

    final Color containerColor = theme.containerColor.resolve(states);
    final InputBorder border = theme.border.resolve(states);

    final Widget container = _BorderContainer(
      border: border,
      gap: _borderGap,
      gapAnimation: _floatingLabelAnimation,
      fillColor: containerColor,
      hoverColor: theme.stateLayers.hoverColor ?? Colors.transparent,
      isHovering: isHovering,
    );

    final Widget? label = decoration.label == null
        ? null
        : wrapMouseCursor(
            cursor: theme.mouseCursorExtent == MouseCursorExtent.input &&
                    _shouldShowLabel &&
                    _floatingLabelAnimation.isDismissed
                ? mouseCursor
                : null,
            child: _Shaker(
              animation: _shakingLabelController.view,
              child: AnimatedOpacity(
                duration: _kTransitionDuration,
                curve: _kTransitionCurve,
                opacity: _shouldShowLabel ? 1.0 : 0.0,
                child: DefaultTextStyle(
                  style: TextStyle.lerp(
                      theme.inputTextStyle
                          .copyWith(color: theme.labelColor.resolve(states)),
                      theme.floatingLabelTextStyle
                          .copyWith(color: theme.labelColor.resolve(states)),
                      _floatingLabelAnimation.value)!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  child: decoration.label!,
                ),
              ),
            ),
          );

    final bool hasPrefix = decoration.prefix != null;
    final bool hasSuffix = decoration.suffix != null;

    Widget input = widget.child;

    // If at least two out of the three are visible, it needs semantics sort
    // order.
    final bool needsSemanticsSortOrder =
        widget._labelShouldWithdraw && (hasPrefix || hasSuffix);

    if (needsSemanticsSortOrder) {
      input = Semantics(
        sortKey: _kInputSemanticsSortOrder,
        child: input,
      );
    }

    final Widget? prefix = hasPrefix
        ? wrapMouseCursor(
            cursor: inputMouseCursor,
            child: _AffixText(
              showAffix: widget._labelShouldWithdraw ||
                  (theme.alwaysShowPrefix && !_hasInlineLabel),
              style: theme.inputTextStyle
                  .copyWith(color: theme.prefixTextColor.resolve(states)),
              semanticsSortKey:
                  needsSemanticsSortOrder ? _kPrefixSemanticsSortOrder : null,
              semanticsTag: _kPrefixSemanticsTag,
              child: decoration.prefix!,
            ),
          )
        : null;

    final Widget? suffix = hasSuffix
        ? wrapMouseCursor(
            cursor: inputMouseCursor,
            child: _AffixText(
              showAffix: widget._labelShouldWithdraw ||
                  (theme.alwaysShowSuffix && !_hasInlineLabel),
              style: theme.inputTextStyle
                  .copyWith(color: theme.suffixTextColor.resolve(states)),
              semanticsSortKey:
                  needsSemanticsSortOrder ? _kSuffixSemanticsSortOrder : null,
              semanticsTag: _kSuffixSemanticsTag,
              child: decoration.suffix!,
            ),
          )
        : null;

    final hasPrefixIcon = decoration.prefixIcon != null;
    final Widget? prefixIcon = !hasPrefixIcon
        ? null
        : Center(
            widthFactor: 1.0,
            heightFactor: 1.0,
            child: wrapMouseCursor(
              cursor: theme.leadingIconMouseCursor,
              child: IconTheme.merge(
                data: IconThemeData(
                  color: theme.leadingIconColor.resolve(states),
                  size: theme.leadingIconSize,
                ),
                child: IconButtonTheme(
                  data: IconButtonThemeData(
                    style: ButtonStyle(
                      labelColor: theme.leadingIconColor,
                      iconSize: theme.leadingIconSize,
                    ),
                  ),
                  child: Semantics(
                    child: decoration.prefixIcon,
                  ),
                ),
              ),
            ),
          );

    final hasSuffixIcon = decoration.suffixIcon != null;
    final Widget? suffixIcon = !hasSuffixIcon
        ? null
        : Center(
            widthFactor: 1.0,
            heightFactor: 1.0,
            child: wrapMouseCursor(
              cursor: theme.trailingIconMouseCursor,
              suppressHover: widget.decoration.suffixIconHasOwnHover,
              child: IconTheme.merge(
                data: IconThemeData(
                  color: theme.trailingIconColor.resolve(states),
                  size: theme.trailingIconSize,
                ),
                child: IconButtonTheme(
                  data: IconButtonThemeData(
                    style: ButtonStyle(
                      labelColor: theme.trailingIconColor,
                      iconSize: theme.trailingIconSize,
                    ),
                  ),
                  child: Semantics(
                    child: decoration.suffixIcon,
                  ),
                ),
              ),
            ),
          );

    final hasSupportingText =
        decoration.placeholderText != null || decoration.errorText != null;
    final Widget? supportingText = hasSupportingText
        ? _SupportingText(
            textAlign: textAlign,
            supportingText: decoration.supportingText,
            nonErrorStyle: theme.supportingTextStyle
                .copyWith(color: theme.supportingTextColor.resolve(states)),
            supportingTextMaxLines: theme.supportingTextMaxLines,
            errorText: decoration.errorText,
            errorStyle: theme.supportingTextStyle.copyWith(
                color:
                    theme.supportingTextColor.resolve({MaterialState.error})),
            errorMaxLines: theme.errorTextMaxLines,
          )
        : null;

    Widget? counter;
    if (decoration.counter != null) {
      counter = decoration.counter;
    } else if (decoration.counterText != null &&
        decoration.counterText!.isNotEmpty) {
      counter = Semantics(
        container: true,
        liveRegion: isFocused,
        child: Text(
          decoration.counterText!,
          style: theme.supportingTextStyle
              .copyWith(color: theme.supportingTextColor.resolve(states)),
          overflow: TextOverflow.ellipsis,
          semanticsLabel: decoration.semanticCounterText,
        ),
      );
    }

    final _Decorator decorator = _Decorator(
      decoration: _Decoration(
        style: widget.style,
        theme: widget.theme,
        isCollapsed: decoration.isCollapsed,
        floatingLabelProgress: _floatingLabelAnimation.value,
        border: border,
        borderGap: _borderGap,
        isDense: decoration.isDense ?? false,
        input: input,
        label: label,
        placeholder: placeholder,
        prefix: prefix,
        suffix: suffix,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        supportingText: supportingText,
        counter: counter,
        container: container,
      ),
      textDirection: Directionality.maybeOf(context) ?? TextDirection.ltr,
      isFocused: isFocused,
      expands: widget.expands,
    );

    final BoxConstraints? constraints = widget.constraints;
    if (constraints != null) {
      return wrapMouseCursor(
        cursor: theme.mouseCursorExtent == MouseCursorExtent.container
            ? mouseCursor
            : null,
        child: ConstrainedBox(
          constraints: constraints,
          child: decorator,
        ),
      );
    }
    return decorator;
  }
}

/// The border, labels, icons, and styles used to decorate a Material
/// Design text field.
///
/// The [TextField] and [InputDecorator] classes use [InputDecoration] objects
/// to describe their decoration. (In fact, this class is merely the
/// configuration of an [InputDecorator], which does all the heavy lifting.)
///
/// {@tool dartpad}
/// This sample shows how to style a `TextField` using an `InputDecorator`. The
/// TextField displays a "send message" icon to the left of the input area,
/// which is surrounded by a border an all sides. It displays the `hintText`
/// inside the input area to help the user understand what input is required. It
/// displays the `helperText` and `counterText` below the input area.
///
/// ![](https://flutter.github.io/assets-for-api-docs/assets/material/input_decoration.png)
///
/// ** See code in examples/api/lib/material/input_decorator/input_decoration.0.dart **
/// {@end-tool}
///
/// {@tool dartpad}
/// This sample shows how to style a "collapsed" `TextField` using an
/// `InputDecorator`. The collapsed `TextField` surrounds the hint text and
/// input area with a border, but does not add padding around them.
///
/// ![](https://flutter.github.io/assets-for-api-docs/assets/material/input_decoration_collapsed.png)
///
/// ** See code in examples/api/lib/material/input_decorator/input_decoration.1.dart **
/// {@end-tool}
///
/// {@tool dartpad}
/// This sample shows how to create a `TextField` with hint text, a red border
/// on all sides, and an error message. To display a red border and error
/// message, provide `errorText` to the [InputDecoration] constructor.
///
/// ![](https://flutter.github.io/assets-for-api-docs/assets/material/input_decoration_error.png)
///
/// ** See code in examples/api/lib/material/input_decorator/input_decoration.2.dart **
/// {@end-tool}
///
/// {@tool dartpad}
/// This sample shows how to style a `TextField` with a round border and
/// additional text before and after the input area. It displays "Prefix" before
/// the input area, and "Suffix" after the input area.
///
/// ![](https://flutter.github.io/assets-for-api-docs/assets/material/input_decoration_prefix_suffix.png)
///
/// ** See code in examples/api/lib/material/input_decorator/input_decoration.3.dart **
/// {@end-tool}
///
/// {@tool dartpad}
/// This sample shows how to style a `TextField` with a prefixIcon that changes color
/// based on the `MaterialState`. The color defaults to gray, be blue while focused
/// and red if in an error state.
///
/// ** See code in examples/api/lib/material/input_decorator/input_decoration.material_state.0.dart **
/// {@end-tool}
///
/// {@tool dartpad}
/// This sample shows how to style a `TextField` with a prefixIcon that changes color
/// based on the `MaterialState` through the use of `ThemeData`. The color defaults
/// to gray, be blue while focused and red if in an error state.
///
/// ** See code in examples/api/lib/material/input_decorator/input_decoration.material_state.1.dart **
/// {@end-tool}
///
/// See also:
///
///  * [TextField], which is a text input widget that uses an
///    [InputDecoration].
///  * [InputDecorator], which is a widget that draws an [InputDecoration]
///    around an input child widget.
///  * [Decoration] and [DecoratedBox], for drawing borders and backgrounds
///    around a child widget.
@immutable
class InputDecoration {
  /// Creates a bundle of the border, labels, icons, and styles used to
  /// decorate a Material Design text field.
  ///
  /// Unless specified by [ThemeData.inputDecorationTheme], [InputDecorator]
  /// defaults [isDense] to false and [filled] to false. The default border is
  /// an instance of [UnderlineInputBorder]. If [border] is [InputBorder.none]
  /// then no border is drawn.
  ///
  /// The [enabled] argument must not be null.
  ///
  /// Only one of [prefix] and [prefixText] can be specified.
  ///
  /// Similarly, only one of [suffix] and [suffixText] can be specified.
  const InputDecoration({
    this.label,
    this.supportingText,
    this.placeholderText,
    this.errorText,
    this.isCollapsed = false,
    this.isDense,
    this.prefixIcon,
    this.prefix,
    this.suffixIcon,
    this.suffixIconHasOwnHover = false,
    this.suffix,
    this.counter,
    this.counterText,
    this.semanticCounterText,
  });

  /// Defines an [InputDecorator] that is the same size as the input field.
  ///
  /// This type of input decoration does not include a border by default.
  ///
  /// Sets the [isCollapsed] property to true.
  const InputDecoration.collapsed({
    required this.placeholderText,
  })  : label = null,
        supportingText = null,
        errorText = null,
        isDense = false,
        isCollapsed = true,
        prefixIcon = null,
        suffixIconHasOwnHover = false,
        prefix = null,
        suffix = null,
        suffixIcon = null,
        counter = null,
        counterText = null,
        semanticCounterText = null;

  /// Optional widget that describes the input field.
  ///
  /// {@template flutter.material.inputDecoration.label}
  /// When the input field is empty and unfocused, the label is displayed on
  /// top of the input field (i.e., at the same location on the screen where
  /// text may be entered in the input field). When the input field receives
  /// focus (or if the field is non-empty), depending on [floatingLabelAlignment],
  /// the label moves above, either vertically adjacent to, or to the center of
  /// the input field.
  /// {@endtemplate}
  ///
  /// This can be used, for example, to add multiple [TextStyle]'s to a label that would
  /// otherwise be specified using [labelText], which only takes one [TextStyle].
  ///
  /// {@tool dartpad}
  /// This example shows a `TextField` with a [Text.rich] widget as the [label].
  /// The widget contains multiple [Text] widgets with different [TextStyle]'s.
  ///
  /// ** See code in examples/api/lib/material/input_decorator/input_decoration.label.0.dart **
  /// {@end-tool}
  ///
  /// Only one of [label] and [labelText] can be specified.
  final Widget? label;

  /// Text that provides context about the [InputDecorator.child]'s value, such
  /// as how the value will be used.
  ///
  /// If non-null, the text is displayed below the [InputDecorator.child], in
  /// the same location as [errorText]. If a non-null [errorText] value is
  /// specified then the helper text is not shown.
  final String? supportingText;

  /// Text that suggests what sort of input the field accepts.
  ///
  /// Displayed on top of the [InputDecorator.child] (i.e., at the same location
  /// on the screen where text may be entered in the [InputDecorator.child])
  /// when the input [isEmpty] and either (a) [labelText] is null or (b) the
  /// input has the focus.
  final String? placeholderText;

  /// Text that appears below the [InputDecorator.child] and the border.
  ///
  /// If non-null, the border's color animates to red and the [supportingText] is
  /// not shown.
  ///
  /// In a [TextFormField], this is overridden by the value returned from
  /// [TextFormField.validator], if that is not null.
  final String? errorText;

  /// Whether the [InputDecorator.child] is part of a dense form (i.e., uses less vertical
  /// space).
  ///
  /// Defaults to false.
  final bool? isDense;

  /// Whether the decoration is the same size as the input field.
  ///
  /// A collapsed decoration cannot have [labelText], [errorText], an [icon].
  ///
  /// To create a collapsed input decoration, use [InputDecoration.collapsed].
  final bool isCollapsed;

  /// An icon that appears before the [prefix] or [prefixText] and before
  /// the editable part of the text field, within the decoration's container.
  ///
  /// The size and color of the prefix icon is configured automatically using an
  /// [IconTheme] and therefore does not need to be explicitly given in the
  /// icon widget.
  ///
  /// The prefix icon is constrained with a minimum size of 48px by 48px, but
  /// can be expanded beyond that. Anything larger than 24px will require
  /// additional padding to ensure it matches the Material Design spec of 12px
  /// padding between the left edge of the input and leading edge of the prefix
  /// icon. The following snippet shows how to pad the leading edge of the
  /// prefix icon:
  ///
  /// ```dart
  /// prefixIcon: Padding(
  ///   padding: const EdgeInsetsDirectional.only(start: 12.0),
  ///   child: _myIcon, // _myIcon is a 48px-wide widget.
  /// )
  /// ```
  ///
  /// {@macro flutter.material.input_decorator.container_description}
  ///
  /// The prefix icon alignment can be changed using [Align] with a fixed `widthFactor` and
  /// `heightFactor`.
  ///
  /// {@tool dartpad}
  /// This example shows how the prefix icon alignment can be changed using [Align] with
  /// a fixed `widthFactor` and `heightFactor`.
  ///
  /// ** See code in examples/api/lib/material/input_decorator/input_decoration.prefix_icon.0.dart **
  /// {@end-tool}
  ///
  /// See also:
  ///
  ///  * [Icon] and [ImageIcon], which are typically used to show icons.
  ///  * [prefix] and [prefixText], which are other ways to show content
  ///    before the text field (but after the icon).
  ///  * [suffixIcon], which is the same but on the trailing edge.
  ///  * [Align] A widget that aligns its child within itself and optionally
  ///    sizes itself based on the child's size.
  final Widget? prefixIcon;

  /// Optional widget to place on the line before the input.
  ///
  /// This can be used, for example, to add some padding to text that would
  /// otherwise be specified using [prefixText], or to add a custom widget in
  /// front of the input. The widget's baseline is lined up with the input
  /// baseline.
  ///
  /// Only one of [prefix] and [prefixText] can be specified.
  ///
  /// The [prefix] appears after the [prefixIcon], if both are specified.
  ///
  /// See also:
  ///
  ///  * [suffix], the equivalent but on the trailing edge.
  final Widget? prefix;

  /// An icon that appears after the editable part of the text field and
  /// after the [suffix] or [suffixText], within the decoration's container.
  ///
  /// The size and color of the suffix icon is configured automatically using an
  /// [IconTheme] and therefore does not need to be explicitly given in the
  /// icon widget.
  ///
  /// The suffix icon is constrained with a minimum size of 48px by 48px, but
  /// can be expanded beyond that. Anything larger than 24px will require
  /// additional padding to ensure it matches the Material Design spec of 12px
  /// padding between the right edge of the input and trailing edge of the
  /// prefix icon. The following snippet shows how to pad the trailing edge of
  /// the suffix icon:
  ///
  /// ```dart
  /// suffixIcon: Padding(
  ///   padding: const EdgeInsetsDirectional.only(end: 12.0),
  ///   child: _myIcon, // myIcon is a 48px-wide widget.
  /// )
  /// ```
  ///
  /// The decoration's container is the area which is filled if [filled] is
  /// true and bordered per the [border]. It's the area adjacent to
  /// [icon] and above the widgets that contain [supportingText],
  /// [errorText], and [counterText].
  ///
  /// The suffix icon alignment can be changed using [Align] with a fixed `widthFactor` and
  /// `heightFactor`.
  ///
  /// {@tool dartpad}
  /// This example shows how the suffix icon alignment can be changed using [Align] with
  /// a fixed `widthFactor` and `heightFactor`.
  ///
  /// ** See code in examples/api/lib/material/input_decorator/input_decoration.suffix_icon.0.dart **
  /// {@end-tool}
  ///
  /// See also:
  ///
  ///  * [Icon] and [ImageIcon], which are typically used to show icons.
  ///  * [suffix] and [suffixText], which are other ways to show content
  ///    after the text field (but before the icon).
  ///  * [prefixIcon], which is the same but on the leading edge.
  ///  * [Align] A widget that aligns its child within itself and optionally
  ///    sizes itself based on the child's size.
  final Widget? suffixIcon;

  /// When true, the hover state of the container will depend on the
  /// hover state of the suffix icon. This can be used to suppress
  /// the hover state layer when the suffix icon is a button so there
  /// is only a single state layer active.
  ///
  /// Defaults to false.
  final bool suffixIconHasOwnHover;

  /// Optional widget to place on the line after the input.
  ///
  /// This can be used, for example, to add some padding to the text that would
  /// otherwise be specified using [suffixText], or to add a custom widget after
  /// the input. The widget's baseline is lined up with the input baseline.
  ///
  /// Only one of [suffix] and [suffixText] can be specified.
  ///
  /// The [suffix] appears before the [suffixIcon], if both are specified.
  ///
  /// See also:
  ///
  ///  * [prefix], the equivalent but on the leading edge.
  final Widget? suffix;

  /// Optional custom counter widget to go in the place otherwise occupied by
  /// [counterText]. If this property is non null, then [counterText] is
  /// ignored.
  final Widget? counter;

  /// Optional custom counter widget to go in the place otherwise occupied by
  /// [counterText]. If this property is non null, then [counterText] is
  /// ignored.
  final String? counterText;

  /// A semantic label for the [counterText].
  ///
  /// Defaults to null.
  ///
  /// If provided, this replaces the semantic label of the [counterText].
  final String? semanticCounterText;

  /// Creates a copy of this input decoration with the given fields replaced
  /// by the new values.
  InputDecoration copyWith({
    Widget? icon,
    Widget? label,
    String? supportingText,
    String? placeholderText,
    String? errorText,
    bool? isCollapsed,
    bool? isDense,
    Widget? prefixIcon,
    Widget? prefix,
    Widget? suffixIcon,
    Widget? suffix,
    Widget? counter,
    String? counterText,
    String? semanticCounterText,
  }) {
    return InputDecoration(
      label: label ?? this.label,
      supportingText: supportingText ?? this.supportingText,
      placeholderText: placeholderText ?? this.placeholderText,
      errorText: errorText ?? this.errorText,
      isCollapsed: isCollapsed ?? this.isCollapsed,
      isDense: isDense ?? this.isDense,
      prefixIcon: prefixIcon ?? this.prefixIcon,
      prefix: prefix ?? this.prefix,
      suffixIcon: suffixIcon ?? this.suffixIcon,
      suffix: suffix ?? this.suffix,
      counter: counter ?? this.counter,
      counterText: counterText ?? this.counterText,
      semanticCounterText: semanticCounterText ?? this.semanticCounterText,
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
    return other is InputDecoration &&
        other.label == label &&
        other.supportingText == supportingText &&
        other.placeholderText == placeholderText &&
        other.errorText == errorText &&
        other.isDense == isDense &&
        other.isCollapsed == isCollapsed &&
        other.prefixIcon == prefixIcon &&
        other.prefix == prefix &&
        other.suffixIcon == suffixIcon &&
        other.suffix == suffix &&
        other.counterText == counterText &&
        other.semanticCounterText == semanticCounterText;
  }

  @override
  int get hashCode {
    final List<Object?> values = <Object?>[
      label,
      supportingText,
      placeholderText,
      errorText,
      isDense,
      isCollapsed,
      prefixIcon,
      prefix,
      suffixIcon,
      suffix,
      counterText,
      semanticCounterText,
    ];
    return Object.hashAll(values);
  }

  @override
  String toString() {
    final List<String> description = <String>[
      if (label != null) 'label: $label',
      if (supportingText != null) 'helperText: "$supportingText"',
      if (placeholderText != null) 'hintText: "$placeholderText"',
      if (errorText != null) 'errorText: "$errorText"',
      if (isDense ?? false) 'isDense: $isDense',
      if (isCollapsed) 'isCollapsed: $isCollapsed',
      if (prefixIcon != null) 'prefixIcon: $prefixIcon',
      if (prefix != null) 'prefix: $prefix',
      if (suffixIcon != null) 'suffixIcon: $suffixIcon',
      if (suffix != null) 'suffix: $suffix',
      if (counterText != null) 'counter: $counterText',
      if (semanticCounterText != null)
        'semanticCounterText: $semanticCounterText',
    ];
    return 'InputDecoration(${description.join(', ')})';
  }
}
