import 'package:flutter/material.dart';
import '../../../services/weather_service.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({Key? key}) : super(key: key);

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final WeatherService _weatherService = WeatherService();

  String city = "Loading...";
  String weather = "Loading...";
  String temperature = "--";
  String backgroundImage = 'assets/images/night_background.jpeg';

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  Future<void> _loadWeather() async {
    try {
      final weatherData = await _weatherService.fetchWeather("Lebanon");

      final currentConditions = weatherData['currentConditions'];
      final weatherDescription = currentConditions['conditions'];
      final currentTemp = currentConditions['temp'];
      final icon = currentConditions['icon'];

      setState(() {
        city = weatherData['resolvedAddress']; // "Lebanon"
        weather = weatherDescription;
        temperature = "${currentTemp}°C";

        // Update background image based on weather condition
        if (weatherDescription.toLowerCase().contains("clear")) {
          backgroundImage = 'assets/images/day_background.jpeg';
        } else if (weatherDescription.toLowerCase().contains("cloud")) {
          backgroundImage = 'assets/images/clouds.png';
        } else if (weatherDescription.toLowerCase().contains("rain")) {
          backgroundImage = 'assets/images/rain.png';
        } else if (weatherDescription.toLowerCase().contains("snow")) {
          backgroundImage = 'assets/images/snow.png';
        } else {
          backgroundImage = 'assets/images/night_background.jpeg';
        }
      });
    } catch (e) {
      setState(() {
        city = "Error";
        weather = "Could not fetch weather";
        temperature = "--";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Dynamic Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(backgroundImage),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Overlay Content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Location and Weather Status
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Text(
                        weather,
                        style: const TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        city,
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                // Temperature Display
                Column(
                  children: [
                    const SizedBox(height: 30),
                    Text(
                      temperature,
                      style: const TextStyle(
                        fontSize: 100,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                // Weather Details for the Week (Placeholder)
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Column(
                    children: [
                      const Text(
                        "Weather Details",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      WeatherDayTile(
                        day: "Monday",
                        temperature: "32°C",
                        status: "Sunny",
                        iconPath: "assets/images/sun.png",
                      ),
                      WeatherDayTile(
                        day: "Tuesday",
                        temperature: "33°C",
                        status: "Partly Cloudy",
                        iconPath: "assets/images/partly_cloudy_icon.jpeg",
                      ),
                      WeatherDayTile(
                        day: "Wednesday",
                        temperature: "31°C",
                        status: "Rainy",
                        iconPath: "assets/images/rain.png",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WeatherDayTile extends StatelessWidget {
  final String day;
  final String temperature;
  final String status;
  final String iconPath;

  const WeatherDayTile({
    Key? key,
    required this.day,
    required this.temperature,
    required this.status,
    required this.iconPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            day,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
          ),
          Row(
            children: [
              Image.asset(
                iconPath,
                width: 25,
                height: 25,
              ),
              const SizedBox(width: 10),
              Text(
                temperature,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              ),
              const SizedBox(width: 10),
              Text(
                status,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
