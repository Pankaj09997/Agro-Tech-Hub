import 'dart:convert';

import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class VideoCall extends StatefulWidget {
  String channelName = "test";

  VideoCall({required this.channelName});
  @override
  _VideoCallState createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall> {
  late final AgoraClient _client;
  bool _loading = true;
  String tempToken = "";

  @override
  void initState() {
    getToken();
    super.initState();
  }

  Future<void> getToken() async {
    String link =
        "https://d7dfbe05-e2f5-45e7-9fa1-4fdb7eeb6130-00-23g8f4rjywj4l.pike.replit.dev/access_token?channelName=test&uid=456&role=publisher&expireTime=1800";

    Response _response = await get(Uri.parse(link));
    Map data = jsonDecode(_response.body);
    setState(() {
      tempToken = data["token"];
    });
    _client = AgoraClient(
        agoraConnectionData: AgoraConnectionData(
          appId: "70fad335b0284a3f88dadd0421699dec",
          tempToken: "007eJxTYDjP4OF5S6WY8cf7ltVaDQuzj5eff2nlttSqU4IzLUmsz02BwdwgLTHF2Ng0ycDIwiTROM3CIiUxJcXAxMjQzNIyJTVZuf5lWkMgIwN//DxGRgYIBPFZGEpSi0sYGADpbx3p",
        
          channelName: widget.channelName,
        ),
        enabledPermission: [
          Permission.camera,
           Permission.microphone]);
    Future.delayed(Duration(seconds: 1)).then(
      (value) => setState(() => _loading = false),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _loading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Stack(
                children: [
                  AgoraVideoViewer(
                    client: _client,
                  ),
                  AgoraVideoButtons(client: _client)
                ],
              ),
      ),
    );
    
  }
}