import 'package:flutter/material.dart';
import 'package:crud_mongodb/dbHelper/mongodb.dart';
import 'package:bson/bson.dart';
import 'package:mongo_dart/mongo_dart.dart' show where;


class UpdatePage extends StatefulWidget {
  final String employeeId;

  const UpdatePage({required this.employeeId});

  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchEmployeeDetails();
  }

  void fetchEmployeeDetails() async {
    Map<String, dynamic>? employee = await MongoDatabase.userCollection.findOne(where.eq('_id', widget.employeeId));
    if (employee != null) {
      setState(() {
        _nameController.text = employee['name'];
        _phoneNumberController.text = employee['phone_number'];
        _addressController.text = employee['address'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Employee'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _phoneNumberController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(labelText: 'Address'),
            ),
            SizedBox(height: 16.0),
            ElevatedButton.icon(
              onPressed: () {
                updateEmployee();
              },
              icon: Icon(Icons.update), // Set the icon
              label: Text('Update'),
              style: ElevatedButton.styleFrom(
                primary: Colors.green, // Set the button color
                onPrimary: Colors.white, // Set the text color
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updateEmployee() async {
    String name = _nameController.text;
    String phoneNumber = _phoneNumberController.text;
    String address = _addressController.text;

    if (name.isNotEmpty && phoneNumber.isNotEmpty && address.isNotEmpty) {
      var updatedEmployee = {
        'name': name,
        'phone_number': phoneNumber,
        'address': address,
      };

      await MongoDatabase.userCollection.update(where.eq('_id', widget.employeeId), updatedEmployee);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Employee updated successfully!'),
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
