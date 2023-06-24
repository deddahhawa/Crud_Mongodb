import 'package:flutter/material.dart';
import 'package:crud_mongodb/insert.dart';

import 'dbHelper/mongodb.dart'; // Import the InsertPage

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MongoDatabase.connect();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: InsertPage(),
      debugShowCheckedModeBanner: false
    );
  }
}