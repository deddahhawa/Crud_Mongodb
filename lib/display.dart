import 'package:flutter/material.dart';
import 'package:crud_mongodb/dbHelper/mongodb.dart';
import 'package:bson/bson.dart';
import 'delete.dart';
import 'update.dart';

class DisplayPage extends StatefulWidget {
  @override
  _DisplayPageState createState() => _DisplayPageState();
}

class _DisplayPageState extends State<DisplayPage> {
  List<Map<String, dynamic>> _employees = [];

  @override
  void initState() {
    super.initState();
    _fetchEmployees();
  }

  Future<void> _fetchEmployees() async {
    List<Map<String, dynamic>> employees = await MongoDatabase.userCollection.find().toList();
    setState(() {
      _employees = employees;
    });
  }

  Widget _buildEmployeeCard(Map<String, dynamic> employee) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListTile(
        leading: Icon(Icons.person), // Add the person icon
        title: Text(employee['name']),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Phone: ${employee['phone_number']}'),
            Text('Address: ${employee['address']}'),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Ink(
              decoration: ShapeDecoration(
                shape: CircleBorder(),
                color: Colors.red,
              ),
              child: IconButton(
                icon: Icon(Icons.delete),
                color: Colors.white,
                onPressed: () {
                  _showDeleteConfirmationDialog(employee['_id']);
                },
              ),
            ),
            SizedBox(width: 8.0),
            Ink(
              decoration: ShapeDecoration(
                shape: CircleBorder(),
                color: Colors.blue,
              ),
              child: IconButton(
                icon: Icon(Icons.edit),
                color: Colors.white,
                onPressed: () {
                  _navigateToUpdatePage(employee['_id']);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(String employeeId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Are you sure you want to delete this employee?'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
                _deleteEmployee(employeeId);
              },
              style: ElevatedButton.styleFrom(primary: Colors.red), // Set the button color
              child: Text(
                'Yes',
                style: TextStyle(color: Colors.white), // Set the text color
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }

  void _deleteEmployee(String employeeId) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DeletePage(employeeId: employeeId)),
    );

    // Refresh the employee list after deletion
    await _fetchEmployees();
  }

  void _navigateToUpdatePage(String employeeId) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UpdatePage(employeeId: employeeId)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee List'),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchEmployees,
        child: ListView.builder(
          itemCount: _employees.length,
          itemBuilder: (context, index) {
            return _buildEmployeeCard(_employees[index]);
          },
        ),
      ),
    );
  }
}
