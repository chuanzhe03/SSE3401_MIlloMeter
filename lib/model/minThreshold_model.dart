class MinThreshold {
  final String factory;
  final String minSteamPressure;
  final String minSteamFlow;
  final String minWaterLevel;
  final String minPowerFrequency;

  MinThreshold({
    required this.factory,
    required this.minSteamPressure,
    required this.minSteamFlow,
    required this.minWaterLevel,
    required this.minPowerFrequency,
  });

  factory MinThreshold.fromJson(Map<String, dynamic> json) {
    return MinThreshold(
      factory: json['factory'],
      minSteamPressure: json['minSteamPressure'],
      minSteamFlow: json['minSteamFlow'],
      minWaterLevel: json['minWaterLevel'],
      minPowerFrequency: json['minPowerFrequency'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'factory': factory,
      'minSteamPressure': minSteamPressure,
      'minSteamFlow': minSteamFlow,
      'minWaterLevel': minWaterLevel,
      'minPowerFrequency': minPowerFrequency,
    };
  }
}
