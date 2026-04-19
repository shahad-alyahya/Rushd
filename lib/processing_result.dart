class ProcessingResult {

  final bool processed;

  final String zoneId;

  final String locationId;

  final String zoneName;

  final int currentCount;

  final double density;

  final String congestionLevel;

  final String severity;

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