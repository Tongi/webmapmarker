import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webmapmarker/map.dart';
//import 'package:webmapmarker/CheckMarkers.dart';
import 'package:webmapmarker/notifier/GetLocationProvider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GetLocationProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CustomMaps.gg',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MapScreen(),
    );
  }
}
