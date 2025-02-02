class Weather {
  final String locationName;
  final String country;
  final double temperatureC;
  final String conditionText;
  final String conditionIcon;
  final double windSpeedKph;
  final int humidity;
  final double feelsLikeC;
  final String airQualityIndex;

  Weather({
    required this.locationName,
    required this.country,
    required this.temperatureC,
    required this.conditionText,
    required this.conditionIcon,
    required this.windSpeedKph,
    required this.humidity,
    required this.feelsLikeC,
    required this.airQualityIndex,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      locationName: json['location']['name'],
      country: json['location']['country'],
      temperatureC: json['current']['temp_c'],
      conditionText: json['current']['condition']['text'],
      conditionIcon: json['current']['condition']['icon'],
      windSpeedKph: json['current']['wind_kph'],
      humidity: json['current']['humidity'],
      feelsLikeC: json['current']['feelslike_c'],
      airQualityIndex: json['current']['air_quality']['us-epa-index'].toString(),
    );
  }
}
