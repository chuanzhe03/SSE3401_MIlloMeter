class AverageThreshold{
  final String factory;
  final String averageSteamPressure;
  final String averageSteamFlow;
  final String averageWaterLevel;
  final String averagePowerFrequency;

  AverageThreshold({
    required this.factory,
    required this.averageSteamPressure,
    required this.averageSteamFlow,
    required this.averageWaterLevel,
    required this.averagePowerFrequency
  });

  factory AverageThreshold.fromJson(Map<String, dynamic> json) {
    return AverageThreshold(
      factory: json['factory'],
      averageSteamPressure: json['averageSteamPressure'],
      averageSteamFlow: json['averageSteamFlow'],
      averageWaterLevel: json['averageWaterLevel'],
      averagePowerFrequency: json['averagePowerFrequency'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'factory': factory,
      'averageSteamPressure': averageSteamPressure,
      'averageSteamFlow': averageSteamFlow,
      'averageWaterLevel': averageWaterLevel,
      'averagePowerFrequency': averagePowerFrequency,
    };
  }
}