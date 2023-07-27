import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:string_validator/string_validator.dart';

import '/controller/player_controller.dart';
import '/data/player_info.dart';
import '/utils/consts.dart';

class WebWidget extends StatefulWidget {
  final String _link;
  final PlayerController _controller;
  const WebWidget(this._link, this._controller, {super.key});

  @override
  State<WebWidget> createState() => _WebWidgetState(_link, _controller);
}

class _WebWidgetState extends State<WebWidget> {
  final String _link;
  final PlayerController _controller;
  List<String>? _keys;
  late PlayerInfo _info;

  late ConnectivityResult _connectivityResult;
  var _isShowDialog = false;

  double _progress = 0;
  late InAppWebViewController _inAppWebViewController;

  _WebWidgetState(this._link, this._controller) {
    _keys = _controller.getKeys();
    _info = _controller.getInfo();
    _setUpView();
  }

  @override
  void initState() {
    super.initState();

    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      print("CONNECTIVITY: $result");
      setState(() {
        if (result == ConnectivityResult.none) {
          _isShowDialog = true;
        } else {
          _isShowDialog = false;
        }
      });
    });
  }

  void _setUpView() {
    if (_info.isAnalysis) {
      _info.counter--;

      if (_info.counter == 0) {
        _info.isAnalysis = false;
      }

      _controller.saveInfo(_info);
    }
  }

  void _check(String url, String pageDomain) {
    _keys?.forEach((key) {
      if (url.contains(key)) {
        _controller.saveLink("https://$pageDomain");
        _info.isAnalysis = false;
        _controller.saveInfo(_info);
        return;
      }
    });
  }

  bool _isValidUrl(String? urlString) {
    try {
      return isURL(urlString);
    } on Exception {
      return false;
    }
  }

  String substringAfter(String input, String delimiter) {
    final delimiterIndex = input.indexOf(delimiter);
    if (delimiterIndex == -1) {
      return '';
    }
    return input.substring(delimiterIndex + delimiter.length);
  }

  String substringBefore(String input, String delimiter) {
    final delimiterIndex = input.indexOf(delimiter);
    if (delimiterIndex == -1) {
      return input;
    }
    return input.substring(0, delimiterIndex);
  }

  void _launchURL(BuildContext context, String url) async {
    try {
      await launch(
        url,
        customTabsOption: CustomTabsOption(
          toolbarColor: Theme.of(context).primaryColor,
          enableDefaultShare: true,
          enableUrlBarHiding: true,
          showPageTitle: false,
        ),
        safariVCOption: SafariViewControllerOption(
          preferredBarTintColor: Theme.of(context).primaryColor,
          preferredControlTintColor: Colors.white,
          barCollapsingEnabled: true,
          entersReaderIfAvailable: false,
          dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        ),
      );
    } catch (e) {
      // An exception is thrown if browser app is not installed on Android device.
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (await _inAppWebViewController.canGoBack()) {
          _inAppWebViewController.goBack();
          return false;
        }
        return true;
      },
      child: SafeArea(
        child: _isShowDialog == false
            ? Scaffold(
                body: Stack(children: [
                  _progress < 1
                      ? LinearProgressIndicator(
                          value: _progress,
                        )
                      : const SizedBox(),
                  InAppWebView(
                    onProgressChanged: (controller, progress) {
                      setState(() {
                        _progress = progress / 100;
                      });
                    },
                    shouldOverrideUrlLoading:
                        (controller, navigationAction) async {
                      if (_isValidUrl(_link)) {
                        if (!_info.isAnalysis) {
                          var ourDomain = _controller.getLink() ?? "";
                          var startOurDomain = substringAfter(ourDomain, '//');
                          var endOurDomain =
                              substringBefore(startOurDomain, '/');
                          print("END OUR DOMAIN: $endOurDomain");

                          var pageDomain =
                              navigationAction.request.url.toString();
                          var startPageDomain =
                              substringAfter(pageDomain, '//');
                          var endPageDomain =
                              substringBefore(startPageDomain, '/');
                          print("END PAGE DOMAIN: $endPageDomain");

                          if (endOurDomain != endPageDomain) {
                            _launchURL(context,
                                navigationAction.request.url.toString());
                            return NavigationActionPolicy.ALLOW;
                          }
                        }

                        return NavigationActionPolicy.CANCEL;
                      } else {
                        try {

                          // TODO WTF?
                          
                          // await Consts.GO_APP
                          //     .invokeMethod('goApp', {'LINK': _link});
                        } catch (e) {
                          debugPrint(e.toString());
                        }

                        return NavigationActionPolicy.ALLOW;
                      }
                    },
                    onWebViewCreated: (controller) =>
                        _inAppWebViewController = controller,
                    onLoadStop: (controller, url) {
                      if (_info.isAnalysis) {
                        async() {
                          var pageDomain = url.toString();
                          var startPageDomain =
                              substringAfter(pageDomain, 'https://');
                          var endPageDomain =
                              substringBefore(startPageDomain, '/');
                          print("onLoadStop: $endPageDomain");
                          if (_info.counter > 0) {
                            _check(pageDomain, endPageDomain);
                          }
                        }
                      }
                    },
                    onLoadError: (controller, url, statusCode, description) {
                      setState(() {
                        _isShowDialog = true;
                      });
                    },
                    androidOnPermissionRequest:
                        (controller, origin, resources) async {
                      return PermissionRequestResponse(
                          resources: resources,
                          action: PermissionRequestResponseAction.GRANT);
                    },
                    initialOptions: InAppWebViewGroupOptions(
                      android: AndroidInAppWebViewOptions(
                        mixedContentMode:
                            AndroidMixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
                      ),
                      crossPlatform: InAppWebViewOptions(
                        javaScriptEnabled: true,
                        cacheEnabled: true,
                      ),
                    ),
                    initialUrlRequest: URLRequest(url: Uri.parse(_link)),
                  )
                ]),
              )
            : const Scaffold(
                backgroundColor: Color.fromARGB(103, 197, 194, 194),
                body: AlertDialog(
                  actions: [],
                  title: Text("Connection Error"),
                  content: Text("Check your internet connection"),
                  icon: Icon(
                    Icons.error,
                    color: Colors.red,
                  ),
                ),
              ),
      ),
    );
  }
}
