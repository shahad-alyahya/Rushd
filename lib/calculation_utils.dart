/// Utility methods for calculating crowd metrics and sensor data.
class CalculationUtils {
  // Calculates the net difference between gate entries and exits.
  static int calculateNetCount({
    required int entryCount,
    required int exitCount,
  }) {
    return entryCount - exitCount;
  }

  // Updates the total count, ensuring it never drops below zero.
  static int calculateCurrentCount({
    required int oldCount,
    required int netChange,
  }) {
    final result = oldCount + netChange;
    return result < 0 ? 0 : result;
  }

  // Uses the direct 'inside' sensor count if valid, otherwise calculates it.
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

  // Calculates density based on maximum capacity or total area size.
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

  static double roundTo2(double value) {
    return double.parse(value.toStringAsFixed(2));
  }

  // Determines the congestion level based on predefined density thresholds.
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

  static String calculateSeverity({
    required double density,
    required double highThreshold,
  }) {
    return density >= highThreshold ? 'high' : 'medium';
  }
}
