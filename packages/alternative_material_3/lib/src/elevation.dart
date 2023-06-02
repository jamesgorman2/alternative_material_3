import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/widgets.dart';

import 'theme.dart';

/// The elevation of a surface.
///
/// See also:
///
///  * [Elevation]
///  * https://m3.material.io/styles/elevation/overview
enum ElevationLevel {
  /// Components: Assist Chip (Flat), Carousel Item, Filled Button,
  /// Filled Tonal Button, Filled Card, Filter Chip (Flat), Full Screen Dialog,
  /// List Item, Input Chip, Navigation Rail, Primary Navigation Tabs,
  /// Secondary Navigation Tabs, Outlined Card, Side Sheet (Docked),
  /// Slider (Track), Suggestion Chip (Flat), Top App Bar.
  ///
  /// Height is 0dp.
  level0(0.0, 'Level 0'),

  /// Components: Assist Chip (Elevated), Banner, Bottom Sheet (Modal),
  /// Elevated Button,Elevated Card, Extended FAB (Lowered), FAB (Lowered),
  /// Filter Chip (Elevated), Navigation Drawer (Modal), Side Sheet (Modal),
  /// Slider (Handle), Suggestion Chip (Elevated).
  ///
  /// Height is 1dp.
  level1(1.0, 'Level 1'),

  /// Components: Autocomplete Menu, Bottom App Bar, Dropdown Menu, Menu,
  /// Navigation Bar, Select Menu, Rich Tooltip, Top App Bar (Scrolled).
  ///
  /// Height is 3dp.
  level2(3.0, 'Level 2'),

  /// Components: FAB, Extended FAB, Modal Date Picker, Docked Date Picker,
  /// Modal Date Input, Dialog, Search Bar, Search View, Time Picker,
  /// Time Input.
  ///
  /// Height is 6dp.
  level3(6.0, 'Level 3'),

  /// Not assigned as resting level. Reserved for user-interacted states such
  /// as hover and dragged.
  ///
  /// Height is 8dp.
  level4(8.0, 'Level 4'),

  /// Not assigned as resting level. Reserved for user-interacted states such
  /// as hover and dragged.
  ///
  /// Height is 12dp.
  level5(12.0, 'Level 5');

  const ElevationLevel(this.height, this.label);
  final double height;
  final String label;

  /// Compare two ElevationLevels based on their level number.
  bool operator <(ElevationLevel other) {
    return ElevationLevel.values.indexOf(this) <
        ElevationLevel.values.indexOf(other);
  }

  /// Add two levels, capped at Level 5.
  ElevationLevel operator +(ElevationLevel other) {
    return ElevationLevel.values.elementAt(
      math.min(
        4,
        ElevationLevel.values.indexOf(this) +
            ElevationLevel.values.indexOf(other),
      ),
    );
  }

  /// Subtract two levels, with a floor of Level 0.
  ElevationLevel operator -(ElevationLevel other) {
    return ElevationLevel.values.elementAt(
      math.max(
        0,
        ElevationLevel.values.indexOf(this) -
            ElevationLevel.values.indexOf(other),
      ),
    );
  }
}

/// Elevation is measured as the distance between components along the
/// z-axis in density-independent pixels (dps).
///
/// See also
///
/// * https://m3.material.io/styles/elevation/overview
@immutable
class Elevation {
  /// Create an Elevation in dps.
  ///
  /// The height must be greater than or equal to 0.
  const Elevation(this.height) : assert(height >= 0.0);

  /// Return the elevation of a particular level
  factory Elevation.atLevel(ElevationLevel level) {
    switch (level) {
      case ElevationLevel.level0:
        return level0;
      case ElevationLevel.level1:
        return level1;
      case ElevationLevel.level2:
        return level2;
      case ElevationLevel.level3:
        return level3;
      case ElevationLevel.level4:
        return level4;
      case ElevationLevel.level5:
        return level5;
    }
  }

  /// Components: Assist Chip (Flat), Carousel Item, Filled Button,
  /// Filled Tonal Button, Filled Card, Filter Chip (Flat), Full Screen Dialog,
  /// List Item, Input Chip, Navigation Rail, Primary Navigation Tabs,
  /// Secondary Navigation Tabs, Outlined Card, Side Sheet (Docked),
  /// Slider (Track), Suggestion Chip (Flat), Top App Bar.
  ///
  /// Height is 0dp.
  static const Elevation level0 = Elevation(0.0);

  /// Components: Assist Chip (Elevated), Banner, Bottom Sheet (Modal),
  /// Elevated Button,Elevated Card, Extended FAB (Lowered), FAB (Lowered),
  /// Filter Chip (Elevated), Navigation Drawer (Modal), Side Sheet (Modal),
  /// Slider (Handle), Suggestion Chip (Elevated).
  ///
  /// Height is 1dp.
  static const Elevation level1 = Elevation(1.0);

  /// Components: Autocomplete Menu, Bottom App Bar, Dropdown Menu, Menu,
  /// Navigation Bar, Select Menu, Rich Tooltip, Top App Bar (Scrolled).
  ///
  /// Height is 3dp.
  static const Elevation level2 = Elevation(3.0);

  /// Components: FAB, Extended FAB, Modal Date Picker, Docked Date Picker,
  /// Modal Date Input, Dialog, Search Bar, Search View, Time Picker,
  /// Time Input.
  ///
  /// Height is 6dp.
  static const Elevation level3 = Elevation(6.0);

  /// Not assigned as resting level. Reserved for user-interacted states such
  /// as hover and dragged.
  ///
  /// Height is 8dp.
  static const Elevation level4 = Elevation(8.0);

  /// Not assigned as resting level. Reserved for user-interacted states such
  /// as hover and dragged.
  ///
  /// Height is 12dp.
  static const Elevation level5 = Elevation(12.0);

  /// The height of this Elevation in dps.
  final double height;

  /// The level that contains this Elevation.
  ///
  /// See also
  ///
  /// * https://m3.material.io/styles/elevation/tokens
  ElevationLevel get level {
    if (height < level1.height) {
      return ElevationLevel.level0;
    } else if (height < level2.height) {
      return ElevationLevel.level1;
    } else if (height < level3.height) {
      return ElevationLevel.level2;
    } else if (height < level4.height) {
      return ElevationLevel.level3;
    } else if (height < level5.height) {
      return ElevationLevel.level4;
    }
    return ElevationLevel.level5;
  }

  /// Return the closest Elevation equal to or lower than this Elevation.
  Elevation get baseElevation {
    return Elevation.atLevel(level);
  }

  /// Return a human readable label of the elevation's level.
  String get label => level.label;

  /// Returns a new Elevation whose level is the sum of the levels of this
  /// and the other Elevation, discarding any height
  /// between levels.
  ///
  /// The result is capped at [Elevation.level5].
  ///
  /// See also:
  ///
  /// * [ElevationLevel.+]
  Elevation addLevel(Elevation other) {
    return Elevation.atLevel(level + other.level);
  }

  /// Returns a new Elevation whose height is the sum of this
  /// and the other Elevation's heights.
  Elevation addHeight(Elevation other) {
    return Elevation(height + other.height);
  }

  /// Returns a new Elevation whose level is the difference of the levels of
  /// this and the other Elevation, discarding any height
  /// between levels.
  ///
  /// The result has a floor of [Elevation.level0].
  ///
  /// See also:
  ///
  /// * [ElevationLevel.-]
  Elevation subtractLevel(Elevation other) {
    return Elevation.atLevel(level - other.level);
  }

  /// Returns a new Elevation whose height is the difference of this
  /// and the other Elevation's heights.
  ///
  /// The result has a floor of [Elevation.level0].
  Elevation subtractHeight(Elevation other) {
    return Elevation(math.max(height - other.height, 0.0));
  }

  /// Return the surface color
  Color color(BuildContext context) {
    final colorScheme = Theme
        .of(context)
        .colorScheme;
    switch (level) {
      case ElevationLevel.level0:
        return colorScheme.surface;
      case ElevationLevel.level1:
        return colorScheme.surfaceContainerLowest;
      case ElevationLevel.level2:
        return colorScheme.surfaceContainerLow;
      case ElevationLevel.level3:
        return colorScheme.surfaceContainer;
      case ElevationLevel.level4:
        return colorScheme.surfaceContainerHigh;
      case ElevationLevel.level5:
        return colorScheme.surfaceContainerHighest;
    }
  }

  /// Compare the height of two Elevations.
  bool operator <(Elevation other) {
    return height < other.height;
  }

  /// Compare the height of two Elevations.
  bool operator >(Elevation other) {
    return height > other.height;
  }

  /// Compare the height of two Elevations.
  bool operator <=(Elevation other) {
    return height <= other.height;
  }

  /// Compare the height of two Elevations.
  bool operator >=(Elevation other) {
    return height >= other.height;
  }

  @override
  bool operator ==(Object other) {
    return other is Elevation && other.height == height;
  }

  @override
  int get hashCode => Object.hash(height, level);

  /// Linearly interpolate between two Elevations.
  ///
  /// This assumes null values to be [Elevation.level0].
  ///
  /// {@macro dart.ui.shadow.lerp}
  static Elevation lerp(Elevation? a, Elevation? b, double t) {
    if (a == b && a != null) {
      return a;
    }
    return Elevation(lerpDouble(a?.height, b?.height, t) ?? 0.0);
  }

  /// Linearly interpolate between two Elevations.
  ///
  /// This will return null if both a and b are null.
  /// Otherwise it will replace will values with defaultHeight,
  /// which has a default value of [Elevation.level0].
  ///
  /// {@macro dart.ui.shadow.lerp}
  static Elevation? lerpNullable(
    Elevation? a,
    Elevation? b,
    double t,
    {Elevation defaultHeight = Elevation.level0}
  ) {
    return a == null && b == null
        ? null
        : Elevation.lerp(
            a ?? defaultHeight,
            b ?? defaultHeight,
            t,
          );
  }

  @override
  String toString() {
    return 'Elevation(height: $height, level: ${level.name})';
  }
}

/// An interpolation between two elevations.
///
/// This class specializes the interpolation of [Tween<Color>] to use
/// [Elevation.lerp].
///
/// The values can be null, representing no transition.
///
/// See [Tween] for a discussion on how to use interpolation objects.
class ElevationTween extends Tween<Elevation?> {
  /// Creates an [ElevationTween] tween.
  ///
  /// The [begin] and [end] properties may be null if either value is
  /// null the non-null value is returned.
  ElevationTween({ super.begin, super.end });

  @override
  Elevation? lerp(double t) {
    return Elevation.lerp(begin, end, t);
  }
}
