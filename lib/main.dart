import 'package:flutter/material.dart';

import 'package:my_crop/screens/parcel_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyCrop',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Colors.brown[600],
          cardColor: Colors.blue[200]
      ),
      home: ParcelList(),
    );
  }
}