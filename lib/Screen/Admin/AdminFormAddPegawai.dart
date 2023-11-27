import 'package:flutter/material.dart';
import 'package:absensi/Models/ModelEmployee.dart';
import 'package:absensi/Widget/AdminWidget.dart';
import 'package:provider/provider.dart';
import 'package:absensi/State/ProviderEmployee.dart';

class AddPegawai extends StatefulWidget {
  @override
  _AddPegawaiState createState() => _AddPegawaiState();
}

class _AddPegawaiState extends State<AddPegawai> {
  List<Employee> employees = [];

  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    await Provider.of<ProviderEmployee>(context, listen: false).getEmployee();
  }

  @override
  Widget build(BuildContext context) {
    employees = Provider.of<ProviderEmployee>(context).listEmployee;
    print(employees);
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee List'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal, // Enable horizontal scrolling
        child: SingleChildScrollView(
          child: DataTable(
            columnSpacing: 28, // Adjust the spacing between columns
            columns: [
              DataColumn(label: Text('#')),
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Email')),
              DataColumn(label: Text('Password')),
            ],
            rows: employees.asMap().entries.map((entry) {
              int index = entry.key + 1;
              Employee employee = entry.value;
              return DataRow(cells: [
                DataCell(Text('$index')),
                DataCell(
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(employee.name!),
                  ),
                ),
                DataCell(
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(employee.email!),
                  ),
                ),
                DataCell(
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(employee.pw!),
                  ),
                ),
              ]);
            }).toList(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEmployeeDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddEmployeeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EmployeeDialog(
          title: 'Add Employee',
          onEmployeeAdded: (Employee newEmployee) async {
            // Add employee using ProviderEmployee service
            await Provider.of<ProviderEmployee>(context, listen: false)
                .addEmployee(newEmployee);

            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}
