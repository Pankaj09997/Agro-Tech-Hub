
import 'package:flutter/material.dart';


class VideoCall extends StatefulWidget {
  String channelName = "test";

  VideoCall({required this.channelName});
  
  @override
  _VideoCallState createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall> {
  bool _loading = true;
  String tempToken = "";

  @override
  void initState() {
    getToken();
    super.initState();
  }

  Future<void> getToken() async {
    // Remove this token fetching if not needed
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _loading
            ? Center(child: CircularProgressIndicator())
            : Stack(children: []),
      ),
    );
  }
}