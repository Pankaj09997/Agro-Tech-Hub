import 'package:agrotech_app/VideoCall/JoinWithCode.dart';
import 'package:agrotech_app/VideoCall/NewMeeting.dart';
import 'package:flutter/material.dart';

class Videohome extends StatelessWidget {
  const Videohome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Video Conference"),
        centerTitle: true,
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 40, 0, 0),
          child: ElevatedButton.icon(
            onPressed: () {
              // Get.to(NewMeeting());
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => NewMeeting()));
            },
            icon: Icon(Icons.add),
            label: Text("New Meeting"),
            style: ElevatedButton.styleFrom(
              fixedSize: Size(350, 30),
              primary: Colors.indigo,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
            ),
          ),
        ),
        Divider(
          thickness: 1,
          height: 40,
          indent: 40,
          endIndent: 20,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
          child: OutlinedButton.icon(
            onPressed: () {
              // Get.to(JoinWithCode());
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => JoinWithCode()));
            },
            icon: Icon(Icons.margin),
            label: Text("Join with a code"),
            style: OutlinedButton.styleFrom(
              primary: Colors.indigo,
              side: BorderSide(color: Colors.indigo),
              fixedSize: Size(350, 30),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25)),
            ),
          ),
        ),
        SizedBox(height: 150),
        Image.network(
            "https://user-images.githubusercontent.com/67534990/127524449-fa11a8eb-473a-4443-962a-07a3e41c71c0.png")
      ]),
    );
  }
}
