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
        "https://agora-node-tokenserver-1.davidcaleb.repl.co/access_token?channelName=${widget.channelName}";

    Response _response = await get(Uri.parse(link));
    Map data = jsonDecode(_response.body);
    setState(() {
      tempToken = data["token"];
    });
    _client = AgoraClient(
        agoraConnectionData: AgoraConnectionData(
          appId: "e43d4dac290c4052b65a7a41678d596a",
          tempToken: "007eJxTYGCNvHvitEDNNFEROet9Zd7zNglvK1q5Qsfcxcc3ka+ft1aBIdXEOMUkJTHZyNIg2cTA1CjJzDTRPNHE0MzcIsXU0ixxwtyHaQ2BjAx+Oy4zMTJAIIjPwlCSWlzCwAAAbwIdHw==",
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