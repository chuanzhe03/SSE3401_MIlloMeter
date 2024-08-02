class FactoryData {
  final String factory;
  final String total;
  final String steamPressure;
  final String steamFlow;
  final String waterLevel;
  final String powerFrequency;
  final String date;
  final String time;

  FactoryData({
    required this.factory,
    required this.total,
    required this.steamPressure,
    required this.steamFlow,
    required this.waterLevel,
    required this.powerFrequency,
    required this.date,
    required this.time
  });

  factory FactoryData.fromJson(Map<String, dynamic> json) {
    return FactoryData(
      factory: json['factory'],
      total: json['total'],
      steamPressure: json['steamPressure'],
      steamFlow: json['steamFlow'],
      waterLevel: json['waterLevel'],
      powerFrequency: json['powerFrequency'],
      date: json['date'],
      time: json['time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'factory': factory,
      'total': total,
      'steamPressure': steamPressure,
      'steamFlow': steamFlow,
      'waterLevel': waterLevel,
      'powerFrequency': powerFrequency,
      'date': date,
      'time': time
    };
  }
}
