import 'package:flutter/material.dart';
import 'package:absensi/Models/ModelEmployee.dart';
import 'package:absensi/Services/ServicesEmployee.dart';

class ProviderEmployee extends ChangeNotifier {
  final ServicesEmployee _employeeService = ServicesEmployee();
  List<Employee> _listEmployee = [];
  List<Employee> get listEmployee => _listEmployee;

  Future<void> addEmployee(Employee employee) async {
    await _employeeService.addEmployee(employee);
    await getEmployee();
  }

  Future<void> getEmployee() async {
    try {
      _listEmployee = await _employeeService.getEmployee();
      print("++++++++++++++++++++++++++++++++++++++");
      print(listEmployee);
      print(_listEmployee);
      notifyListeners();
    } catch (e) {
      print(e.toString());
    }
  }
}
