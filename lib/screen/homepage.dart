import 'package:agrotech_app/Weather/WeatherModel.dart';
import 'package:agrotech_app/Weather/WeatherScreen.dart';
import 'package:agrotech_app/Weather/WeatherServices.dart';
import 'package:agrotech_app/bots/chatpage.dart';
import 'package:agrotech_app/colors/Colors.dart';
import 'package:agrotech_app/screen/Expense/Expenses.dart';
import 'package:agrotech_app/screen/flchart.dart';
import 'package:agrotech_app/screen/messenger/messenging.dart';
import 'package:agrotech_app/screen/settings.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:agrotech_app/Service%20Item/serviceitem.dart';
import 'package:agrotech_app/api.dart';
import 'package:agrotech_app/cubit/theme_cubit.dart';
import 'package:geolocator/geolocator.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String greetings = '';
  final ApiService _apiService = ApiService();
  late Future<Map<String, dynamic>> namegetter;
  late WeatherData weatherInfo;
  bool isLoading = false;
  final String apiKey = '85aa402dbc629b9d67c79f523c54e2e2';

  Future<void> myWeather() async {
    setState(() {
      isLoading = false;
    });

    try {
      Position position = await WeatherServices(apiKey).getCurrentPosition();
      WeatherServices(apiKey)
          .fetchWeather(position.latitude, position.longitude)
          .then((value) {
        setState(() {
          weatherInfo = value!;
          isLoading = true;
        });
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<Map<String, dynamic>> fetchname() async {
    try {
      final response = await _apiService.profilePage();
      return response;
    } catch (e) {
      throw Exception("Unable to get name");
    }
  }

  final List<ServiceItem> services = [
    ServiceItem(
      name: "Network",
      imageAddress: "assets/network.jpg",
      routeAddress: '/network',
    ),
    ServiceItem(
      name: "Market Place",
      imageAddress: "assets/marketplace.jpg",
      routeAddress: '/citizenshipverify',
    ),

  ];

  @override
  void initState() {
    super.initState();
    final currentTime = DateTime.now();
    namegetter = fetchname();
    final currentHour = currentTime.hour;

    if (currentHour < 12) {
      greetings = 'Good Morning !';
    } else if (currentHour < 17) {
      greetings = 'Good Afternoon !';
    } else {
      greetings = 'Good Evening !';
    }
    weatherInfo = WeatherData(
      name: '',
      temperature: Temperature(current: 0.0),
      humidity: 0,
      wind: Wind(speed: 0.0),
      maxTemperature: 0,
      minTemperature: 0,
      pressure: 0,
      seaLevel: 0,
      weather: [],
    );
    myWeather();
  }

  // Data for the radar chart
  List<RadarEntry> _generateRadarEntries() {
    return [
      RadarEntry(value: 4),
      RadarEntry(value: 2),
      RadarEntry(value: 3),
      RadarEntry(value: 5),
      RadarEntry(value: 4),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: CircleAvatar(
          backgroundImage: AssetImage("assets/bots.jpg"),
        ),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => BotChat()));
        },
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: colorsPallete.appBarColor,
        elevation: 1,
        actions: [
          IconButton(
            onPressed: () {
              context.read<ThemeCubit>().toggleTheme();
            },
            icon: Icon(Icons.brightness_6),
            iconSize: 30,
          ),
          SizedBox(width: 10),
          IconButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => Settings()));
            },
            icon: Icon(Icons.settings),
            iconSize: 30,
          ),
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: namegetter,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No profile data available'));
          } else {
            final profileData = snapshot.data!;
            final name = profileData['name'];

            return CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Welcome, $name",
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "$greetings",
                            style: Theme.of(context)
                                .textTheme
                                .headline5
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: const EdgeInsets.all(8.0), // Added padding
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? Colors.black
                                : Colors.black, // Container background color
                            borderRadius:
                                BorderRadius.circular(12), // Rounded corners
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) => WeatherHome()));
                                    },
                                    child: Image.asset(
                                      "assets/cloudy.png",
                                      height: height * 0.2,
                                      width: width * 0.3,
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        weatherInfo.name,
                                        style: TextStyle(
                                          color: isDarkMode
                                              ? Colors.white
                                              : Colors.white,
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "${weatherInfo.temperature.current.toStringAsFixed(2)}°C",
                                        style: TextStyle(
                                          color: isDarkMode
                                              ? Colors.white
                                              : Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      if (weatherInfo.weather.isNotEmpty)
                                        Text(
                                          weatherInfo.weather[0].main,
                                          style: TextStyle(
                                            color: isDarkMode
                                                ? Colors.white
                                                : Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Radar chart inside this container
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => ExpensesPage()));
                          },
                          child: Container(
                            height: height * 0.4,
                            width: width * 0.3,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: isDarkMode ? Colors.black : Colors.black,
                            ),
                            child: AnimatedChartsPage(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 5 / 6,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Theme.of(context).dividerColor),
                            borderRadius: BorderRadius.circular(16),
                            color: Theme.of(context).cardColor,
                          ),
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, services[index].routeAddress);
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                AspectRatio(
                                  aspectRatio: 1.1,
                                  child: Image.asset(
                                    services[index].imageAddress,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  services[index].name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: services.length,
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
