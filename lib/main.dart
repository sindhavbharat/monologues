import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monologues/app_utils.dart';
import 'package:monologues/screens/chat.dart';
import 'package:monologues/screens/home.dart';
import 'package:monologues/screens/splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences preferences = await SharedPreferences.getInstance();

  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) {
    runApp(MaterialApp(
      title: 'Monologues App',
      // initialRoute: '/splash',
      routes: {
        '/spash': (context) => Splash(),
        '/home': (context) => Home(),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: preferences.getBool(AppUtils.kPrefIsStartChat)==null?Splash():Chat(kName: preferences.getString(AppUtils.kPrefUserName),kImage:preferences.getString(AppUtils.kPrefUserImage),),
    )
    );
  }
  );
}


