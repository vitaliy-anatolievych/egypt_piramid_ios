import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/pages/load_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
 
  runApp(
    const MaterialApp(
      home: LoadPage(),
    ),
  );
}
