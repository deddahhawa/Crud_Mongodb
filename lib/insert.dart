import 'package:flutter/material.dart';
import 'package:crud_mongodb/dbHelper/mongodb.dart';
import 'package:bson/bson.dart';
import 'display.dart';

class InsertPage extends StatefulWidget {
  @override
  _InsertPageState createState() => _InsertPageState();
}

class _InsertPageState extends State<InsertPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crud_Mongodb'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _phoneNumberController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    insertEmployee();
                  },
                  icon: Icon(Icons.add),
                  label: Text('Insert'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green, // Set the button color
                    onPrimary: Colors.white, // Set the text color
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DisplayPage()),
                    );
                  },
                  icon: Icon(Icons.list),
                  label: Text('View Employees'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void insertEmployee() async {
    String name = _nameController.text;
    String phoneNumber = _phoneNumberController.text;
    String address = _addressController.text;

    if (name.isNotEmpty && phoneNumber.isNotEmpty && address.isNotEmpty) {
      var employee = {
        '_id': ObjectId().toHexString(), // Convert ObjectId to String
        'name': name,
        'phone_number': phoneNumber,
        'address': address,
      };

      await MongoDatabase.userCollection.insert(employee);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Employee inserted successfully!'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );

      _nameController.clear();
      _phoneNumberController.clear();
      _addressController.clear();
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please fill in all the fields.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crud_Mongodb',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: InsertPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
