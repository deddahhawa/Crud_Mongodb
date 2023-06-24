import 'package:flutter/material.dart';
import 'package:crud_mongodb/dbHelper/mongodb.dart';
import 'package:bson/bson.dart';
import 'package:mongo_dart/mongo_dart.dart' show where;

class DeletePage extends StatefulWidget {
  final String employeeId;

  const DeletePage({required this.employeeId});

  @override
  _DeletePageState createState() => _DeletePageState();
}

class _DeletePageState extends State<DeletePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Delete Employee'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Are you sure you want to delete this employee?',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                deleteEmployee();
              },
              child: Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }

  void deleteEmployee() async {
    await MongoDatabase.userCollection.remove(where.eq('_id', widget.employeeId));
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Success'),
          content: Text('Employee deleted successfully!'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context); // Pop twice to go back to the DisplayPage
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
