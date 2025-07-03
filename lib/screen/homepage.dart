// import 'package:agrotech_app/Weather/WeatherModel.dart';
// import 'package:agrotech_app/Weather/WeatherScreen.dart';
// import 'package:agrotech_app/Weather/WeatherServices.dart';
// import 'package:agrotech_app/bots/chatpage.dart';
// import 'package:agrotech_app/colors/Colors.dart';
// import 'package:agrotech_app/screen/Expense/Expenses.dart';
// import 'package:agrotech_app/screen/flchart.dart';
// import 'package:agrotech_app/screen/settings.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:agrotech_app/Service%20Item/serviceitem.dart';
// import 'package:agrotech_app/api.dart';
// import 'package:agrotech_app/cubit/theme_cubit.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get_connect/http/src/utils/utils.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({Key? key}) : super(key: key);

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   late String greetings = '';
//   final ApiService _apiService = ApiService();
//   late Future<Map<String, dynamic>> namegetter;
//   late WeatherData weatherInfo;
//   bool isLoading = false;
//   final String apiKey = '85aa402dbc629b9d67c79f523c54e2e2';

//   Future<void> myWeather() async {
//     setState(() {
//       isLoading = false;
//     });

//     try {
//       Position position = await WeatherServices(apiKey).getCurrentPosition();
//       WeatherServices(apiKey)
//           .fetchWeather(position.latitude, position.longitude)
//           .then((value) {
//         setState(() {
//           weatherInfo = value!;
//           isLoading = true;
//         });
//       });
//     } catch (e) {
//       print(e.toString());
//     }
//   }

//   Future<Map<String, dynamic>> fetchname() async {
//     try {
//       final response = await _apiService.profilePage();
//       return response;
//     } catch (e) {
//       throw Exception("Unable to get name");
//     }
//   }

//   final List<ServiceItem> services = [
//     ServiceItem(
//       name: "Network",
//       imageAddress: "assets/network.svg",
//       routeAddress: '/network',
//     ),
//     ServiceItem(
//       name: "Market Place",
//       imageAddress: "assets/market.svg",
//       routeAddress: '/citizenshipverify',
//     ),
//         ServiceItem(
//       name: " Video",
//       imageAddress: "assets/video.svg",
//       routeAddress: '/video',
//     ),

//   ];

//   @override
//   void initState() {
//     super.initState();
//     final currentTime = DateTime.now();
//     namegetter = fetchname();
//     final currentHour = currentTime.hour;

//     if (currentHour < 12) {
//       greetings = 'Good Morning !';
//     } else if (currentHour < 17) {
//       greetings = 'Good Afternoon !';
//     } else {
//       greetings = 'Good Evening !';
//     }
//     weatherInfo = WeatherData(
//       name: '',
//       temperature: Temperature(current: 0.0),
//       humidity: 0,
//       wind: Wind(speed: 0.0),
//       maxTemperature: 0,
//       minTemperature: 0,
//       pressure: 0,
//       seaLevel: 0,
//       weather: [],
//     );
//     myWeather();
//   }

//   // Data for the radar chart
//   List<RadarEntry> _generateRadarEntries() {
//     return [
//       RadarEntry(value: 4),
//       RadarEntry(value: 2),
//       RadarEntry(value: 3),
//       RadarEntry(value: 5),
//       RadarEntry(value: 4),
//     ];
//   }

//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     final width = MediaQuery.of(context).size.width;
//     final isDarkMode = Theme.of(context).brightness == Brightness.dark;

//     return Scaffold(
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: Colors.black,
//         child: CircleAvatar(
//           backgroundImage: AssetImage("assets/bots.jpg"),
//         ),
//         onPressed: () {
//           Navigator.push(
//               context, MaterialPageRoute(builder: (_) => BotChat()));
//         },
//       ),
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: colorsPallete.appBarColor,
//         elevation: 1,
//         actions: [
//           IconButton(
//             onPressed: () {
//               context.read<ThemeCubit>().toggleTheme();
//             },
//             icon: Icon(Icons.brightness_6),
//             iconSize: 30,
//           ),
//           SizedBox(width: 10),
//           IconButton(
//             onPressed: () {
//               Navigator.push(
//                   context, MaterialPageRoute(builder: (_) => Settings()));
//             },
//             icon: Icon(Icons.settings),
//             iconSize: 30,
//           ),
//         ],
//       ),
//       body: FutureBuilder<Map<String, dynamic>>(
//         future: namegetter,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data == null) {
//             return Center(child: Text('No profile data available'));
//           } else {
//             final profileData = snapshot.data!;
//             final name = profileData['name'];

//             return CustomScrollView(
//               slivers: [
//                 SliverList(
//                   delegate: SliverChildListDelegate(
//                     [
//                       Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Container(
//                           alignment: Alignment.centerLeft,
//                           child: Text(
//                             "Welcome, $name",
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .headline5
//                                 ?.copyWith(fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Container(
//                           alignment: Alignment.centerLeft,
//                           child: Text(
//                             "$greetings",
//                             style: Theme.of(context)
//                                 .textTheme
//                                 .headline5
//                                 ?.copyWith(fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Container(
//                           padding: const EdgeInsets.all(8.0), // Added padding
//                           decoration: BoxDecoration(
//                             gradient: LinearGradient(
//                                                           colors: isDarkMode
//                                 ? [Colors.black54, Colors.black87]
//                                 : [Colors.blueAccent, Colors.lightBlueAccent],
//                             begin: Alignment.topLeft,
//                             end: Alignment.bottomRight,
//                               ),
//                          // Container background color
//                             borderRadius:
//                                 BorderRadius.circular(12), // Rounded corners
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 children: [
//                                   GestureDetector(
//                                     onTap: () {
//                                       Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                               builder: (_) => WeatherHome()));
//                                     },
//                                     child: Image.asset(
//                                       "assets/cloudy.png",
//                                       height: height * 0.2,
//                                       width: width * 0.3,
//                                     ),
//                                   ),
//                                   SizedBox(width: 16),
//                                   Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       Text(
//                                         weatherInfo.name,
//                                         style: TextStyle(
//                                           color: isDarkMode
//                                               ? Colors.white
//                                               : Colors.white,
//                                           fontSize: 24,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                       Text(
//                                         "${weatherInfo.temperature.current.toStringAsFixed(2)}°C",
//                                         style: TextStyle(
//                                           color: isDarkMode
//                                               ? Colors.white
//                                               : Colors.white,
//                                           fontSize: 20,
//                                           fontWeight: FontWeight.bold,
//                                         ),
//                                       ),
//                                       if (weatherInfo.weather.isNotEmpty)
//                                         Text(
//                                           weatherInfo.weather[0].main,
//                                           style: TextStyle(
//                                             color: isDarkMode
//                                                 ? Colors.white
//                                                 : Colors.white,
//                                             fontSize: 16,
//                                           ),
//                                         ),
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 10,),
//                       // Radar chart inside this container
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text("Expense Tracker:",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: GestureDetector(
//                           onTap: () {
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (_) => ExpensesPage()));
//                           },
//                           child: Container(
//                             height: height * 0.4,
//                             width: width * 0.3,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(10),
//                               color: Colors.black

//                             ),
//                             child: AnimatedChartsPage(),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 SliverGrid(
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     childAspectRatio: 5 / 6,
//                   ),
//                   delegate: SliverChildBuilderDelegate(
//                     (context, index) {
//                       return Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Container(
//                           decoration: BoxDecoration(
//                             border: Border.all(
//                                 color: Theme.of(context).dividerColor),
//                             borderRadius: BorderRadius.circular(16),
//                             color: Theme.of(context).cardColor,
//                           ),
//                           child: InkWell(
//                             onTap: () {
//                               Navigator.pushNamed(
//                                   context, services[index].routeAddress);
//                             },
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 AspectRatio(
//                                   aspectRatio: 1.1,
//                                   child: SvgPicture.asset(
//                                     services[index].imageAddress,

//                                     height: 5,
//                                     width: 5,
//                                   ),
//                                 ),
//                                 SizedBox(height: 10),
//                                 Text(
//                                   services[index].name,
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .bodyText1
//                                       ?.copyWith(fontWeight: FontWeight.bold),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                     childCount: services.length,
//                   ),
//                 ),
//               ],
//             );
//           }
//         },
//       ),
//     );
//   }
// }
// import 'package:agrotech_app/Weather/WeatherModel.dart';
import 'dart:async';

import 'package:agrotech_app/NotificationService/NotificationService.dart';
import 'package:agrotech_app/Weather/WeatherModel.dart';
import 'package:agrotech_app/Weather/WeatherScreen.dart';
import 'package:agrotech_app/Weather/WeatherServices.dart';
import 'package:agrotech_app/bots/chatpage.dart';
import 'package:agrotech_app/colors/Colors.dart';
import 'package:agrotech_app/screen/Expense/Expenses.dart';
import 'package:agrotech_app/screen/flchart.dart';
import 'package:agrotech_app/screen/settings.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:agrotech_app/Service%20Item/serviceitem.dart';
import 'package:agrotech_app/api.dart';
import 'package:agrotech_app/cubit/theme_cubit.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
   Timer? _timer;

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
      imageAddress: "assets/network.svg",
      routeAddress: '/network',
    ),
    ServiceItem(
      name: "Market Place",
      imageAddress: "assets/market.svg",
      routeAddress: '/citizenshipverify',
    ),
    ServiceItem(
      name: "Video Conference",
      imageAddress: "assets/video.svg",
      routeAddress: '/video',
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Set the initial notification
    NotificationService.showInstantNotification(
        "Weather Alert!", "Today is mostly sunny with a few clouds in the afternoon. Enjoy the beautiful weather and happy farming!");

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

    // Timer setup to trigger notification every 2 minutes
    _timer = Timer.periodic(Duration(minutes: 2), (timer) {
      NotificationService.showInstantNotification(
          "Weather Alert!", "Sunny And Partly Cloudy in Afternoon");
    });
  }
  @override
  void dispose() {
    
    super.dispose();
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green[800],
        child: CircleAvatar(
          backgroundImage: AssetImage("assets/bots.jpg"),
        ),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => BotChat()));
        },
      ),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.green[800],
        elevation: 1,
        title: Text(
          "AgroTech",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.read<ThemeCubit>().toggleTheme();
            },
            icon: Icon(Icons.brightness_6),
            iconSize: 30,
            color: Colors.white,
          ),
          SizedBox(width: 10),
          IconButton(
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => Settings()));
            },
            icon: Icon(Icons.settings),
            iconSize: 30,
            color: Colors.white,
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
                            "Welcome, ",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[900],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "$greetings",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[800],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: isDarkMode
                                  ? [Colors.green[900]!, Colors.green[800]!]
                                  : [Colors.green[200]!, Colors.green[100]!],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 6,
                                offset: Offset(2, 2),
                              ),
                            ],
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
                                              : Colors.green[900],
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "${weatherInfo.temperature.current.toStringAsFixed(2)}°C",
                                        style: TextStyle(
                                          color: isDarkMode
                                              ? Colors.white
                                              : Colors.green[900],
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
                                                : Colors.green[900],
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
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "Expense Tracker:",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[900],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
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
                              borderRadius: BorderRadius.circular(16),
                              color: isDarkMode
                                  ? Colors.green[900]
                                  : Colors.green[100],
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 6,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                            child: AnimatedChartsPage(),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "Services",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[900],
                          ),
                        ),
                      ),
                      ...services.map((service) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 16),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, service.routeAddress);
                            },
                            child: Container(
                              height: 200,
                              decoration: BoxDecoration(
                                color: isDarkMode
                                    ? Colors.green[900]
                                    : Colors.green[100],
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 6,
                                    offset: Offset(2, 2),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      service.imageAddress,
                                      height: 150,
                                      width: 150,
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      service.name,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: isDarkMode
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 22,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ],
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
