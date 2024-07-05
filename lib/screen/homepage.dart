import 'package:agrotech_app/Service%20Item/serviceitem.dart';
import 'package:flutter/material.dart';
import 'package:agrotech_app/api.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String greetings = '';
  final ApiService _apiService = ApiService();
  late Future<Map<String, dynamic>> namegetter;

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
      name: "Streaming Site",
      imageAddress: "assets/streamingsite.jpg",
      routeAddress: '/stream',
    ),
    ServiceItem(
      name: "Test",
      imageAddress: "assets/testing.jpg",
      routeAddress: '/test',
    ),
    ServiceItem(
      name: "Expert Advice",
      imageAddress: "assets/advice.jpg",
      routeAddress: '/advice',
    ),
  ];

  @override
  void initState() {
    super.initState();
    final currentTime = DateTime.now();
    namegetter = fetchname();
    final currentHour = currentTime.hour;

    if (currentHour < 12) {
      greetings = 'Good Morning';
    } else if (currentHour < 17) {
      greetings = 'Good Afternoon';
    } else {
      greetings = 'Good Evening';
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 1,
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.person, color: Colors.black),
            iconSize: 30,
          ),
          SizedBox(width: 10),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.settings, color: Colors.black),
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
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Welcome, $name",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
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
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(
                  height: height * 0.03,
                ),
                Expanded(
                  child: GridView.builder(
                    itemCount: services.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 5 / 6,
                    ),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(16),
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
                                  child: Image.asset(services[index].imageAddress,
                                      fit: BoxFit.cover),
                                ),
                                SizedBox(height: 10),
                                Text(services[index].name,
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black)),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
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
