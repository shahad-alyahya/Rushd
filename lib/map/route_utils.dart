/// Utility class for calculating congestion metrics, density, and crowd counts.
class CalculationUtils {
  /// Calculates the net difference between entry and exit counts.
  static int calculateNetCount({
    required int entryCount,
    required int exitCount,
  }) {
    return entryCount - exitCount;
  }

  /// Calculates the updated current count based on the previous count and net change.
  /// Ensures the resulting count does not drop below zero.
  static int calculateCurrentCount({
    required int oldCount,
    required int netChange,
  }) {
    final result = oldCount + netChange;
    return result < 0 ? 0 : result;
  }

  /// Determines the active count, prioritizing direct sensor 'inside' data if available.
  /// Falls back to calculation if sensor data is null or invalid.
  static int calculateCurrentCountFromInside({
    required int? inside,
    required int oldCount,
    required int netChange,
  }) {
    if (inside != null && inside >= 0) {
      return inside;
    }

    return calculateCurrentCount(oldCount: oldCount, netChange: netChange);
  }

  /// Calculates spatial density based on current count and either maximum capacity or physical area size.
  static double calculateDensity({
    required int currentCount,
    required int capacity,
    required double areaSize,
  }) {
    if (capacity > 0) {
      return currentCount / capacity;
    }

    if (areaSize > 0) {
      return currentCount / areaSize;
    }

    return 0.0;
  }

  /// Helper method to round a double value to two decimal places.
  static double roundTo2(double value) {
    return double.parse(value.toStringAsFixed(2));
  }

  /// Categorizes congestion level into 'low', 'medium', or 'high' based on predefined density thresholds.
  static String calculateCongestionLevel({
    required double density,
    required double lowThreshold,
    required double mediumThreshold,
  }) {
    if (density < lowThreshold) {
      return 'low';
    } else if (density < mediumThreshold) {
      return 'medium';
    } else {
      return 'high';
    }
  }

  /// Determines the severity level based on a critical high-density threshold.
  static String calculateSeverity({
    required double density,
    required double highThreshold,
  }) {
    return density >= highThreshold ? 'high' : 'medium';
  }
}

/// Utility class for estimating route durations and formatting travel distances.
class RouteUtils {
  /// Estimates the travel time based on the route points.
  /// Note: This logic can be adjusted based on the specific movement speed in your application.
  static String estimateTime(List<dynamic> points) {
    // Estimating 2 minutes per route point as a baseline
    int estimatedMinutes = points.length * 2;
    return "$estimatedMinutes mins";
  }

  /// Calculates and formats the total distance of the route.
  /// Note: Distance calculation logic can be fine-tuned using actual map coordinates.
  static String formatDistance(List<dynamic> points) {
    // Estimating 0.5 km per route point as a baseline
    double distance = points.length * 0.5;
    return "${CalculationUtils.roundTo2(distance)} km";
  }
}
