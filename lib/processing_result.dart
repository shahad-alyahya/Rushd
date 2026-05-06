/// A data model representing the calculated crowd metrics for a specific zone.
class ProcessingResult {
  // Indicates if the sensor reading was successfully processed.
  final bool processed;

  // Unique identifier for the specific zone.
  final String zoneId;

  // Unique identifier for the parent location.
  final String locationId;

  // The display name of the zone.
  final String zoneName;

  // The current number of people currently inside the zone.
  final int currentCount;

  // The calculated crowd density.
  final double density;

  // The level of crowding (e.g., low, medium, high).
  final String congestionLevel;

  // The alert severity level for the zone.
  final String severity;

  // Constructor to initialize the processing result data.

  ProcessingResult({
    required this.processed,
    required this.zoneId,
    required this.locationId,
    required this.zoneName,
    required this.currentCount,
    required this.density,
    required this.congestionLevel,
    required this.severity,
  });
}
