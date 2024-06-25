import 'package:agrotech_app/colors/Colors.dart';
import 'package:flutter/material.dart';

class NetworkPage extends StatefulWidget {
  const NetworkPage({super.key});

  @override
  State<NetworkPage> createState() => _NetworkPageState();
}

class _NetworkPageState extends State<NetworkPage> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return PopScope(
onPopInvoked: (didPop) {
          Navigator.pushReplacementNamed(context, '/home');
        
},
      child: Scaffold(
        appBar: AppBar(
          title: Text("Networking"),
          iconTheme: IconThemeData(),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
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
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  height: height * 0.18,  // Set your desired height
                  width: width * 1,    // Set your desired width
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.black),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: "What's on your mind...?",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                        SizedBox(height: height*0.01,),
                        Divider(),
                        SizedBox(height: height*0.01,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ActionButton(
                              icon: Icons.file_present,
                              color: Colors.black,
                              label: "File",
                              onTap: () {
                               
                              },
                            ),
                            ActionButton(
                              icon: Icons.photo,
                              color: Colors.black,
                              label: "Photos",
                              onTap: () {
                                
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: height*0.02,
                ),
                              Container(
                  height: height * 0.5,  // Set your desired height
                  width: width * 1,    // Set your desired width
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.black),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                      Image.network("https://static-00.iconduck.com/assets.00/person-icon-486x512-eeiy7owm.png",fit: BoxFit.fill,height: height*0.4,),
                        Divider(),
                        SizedBox(height: height*0.01,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ActionButton(
                              icon: Icons.thumb_up,
                              color: Colors.black,
                              label: "Like",
                              onTap: () {
                               
                              },
                            ),
                            ActionButton(
                              icon: Icons.comment,
                              color: Colors.black,
                              label: "Comment",
                              onTap: () {
                                
                              },
                            ),
                                                      ActionButton(
                              icon: Icons.share,
                              color: Colors.black,
                              label: "Share",
                              onTap: () {
                                
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: height*0.02,
                ),
                              Container(
                  height: height * 0.5,  // Set your desired height
                  width: width * 1,    // Set your desired width
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.black),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                      Image.network("https://static-00.iconduck.com/assets.00/person-icon-486x512-eeiy7owm.png",fit: BoxFit.fill,height: height*0.4,),
                        Divider(),
                        SizedBox(height: height*0.01,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ActionButton(
                              icon: Icons.thumb_up,
                              color: Colors.black,
                              label: "Like",
                              onTap: () {
                               
                              },
                            ),
                            ActionButton(
                              icon: Icons.comment,
                              color: Colors.black,
                              label: "Comment",
                              onTap: () {
                                
                              },
                            ),
                                                      ActionButton(
                              icon: Icons.share,
                              color: Colors.black,
                              label: "Share",
                              onTap: () {
                                
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;

  const ActionButton({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
          ),
          SizedBox(width: 5),
          Text(label),
        ],
      ),
    );
  }
}
