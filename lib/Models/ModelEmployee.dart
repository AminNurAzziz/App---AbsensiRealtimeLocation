class Employee {
  final String? id;
  final String? name;
  final String? email;
  final String? password;
  final String? role;
  final String? pw;

  Employee({
    this.id,
    this.name,
    this.email,
    this.password,
    this.role,
    this.pw,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['_id'],
      name: json['nama'],
      email: json['email'],
      role: json['role'],
      pw: json['pw'],
    );
  }
}
