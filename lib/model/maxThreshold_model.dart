class MaxThreshold{
  final String factory;
  final String maxSteamPressure;
  final String maxSteamFlow;
  final String maxWaterLevel;
  final String maxPowerFrequency;

  MaxThreshold({
    required this.factory,
    required this.maxSteamPressure,
    required this.maxSteamFlow,
    required this.maxWaterLevel,
    required this.maxPowerFrequency
  });

  factory MaxThreshold.fromJson(Map<String, dynamic> json) {
    return MaxThreshold(
      factory: json['factory'],
      maxSteamPressure: json['maxSteamPressure'],
      maxSteamFlow: json['maxSteamFlow'],
      maxWaterLevel: json['maxWaterLevel'],
      maxPowerFrequency: json['maxPowerFrequency'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'factory': factory,
      'maxSteamPressure': maxSteamPressure,
      'maxSteamFlow': maxSteamFlow,
      'maxWaterLevel': maxWaterLevel,
      'maxPowerFrequency': maxPowerFrequency,
    };
  }
}