import 'package:cloud_firestore/cloud_firestore.dart';

class CareerRoleModel {
  final String selectedRole;
  final DateTime lastUpdated;

  CareerRoleModel({
    required this.selectedRole,
    required this.lastUpdated,
  });

  factory CareerRoleModel.fromMap(Map<String, dynamic> map) {
    return CareerRoleModel(
      selectedRole: map['selectedRole'] ?? "",
      lastUpdated: map['lastUpdated'] is Timestamp
          ? (map['lastUpdated'] as Timestamp).toDate()
          : DateTime.tryParse(map['lastUpdated']?.toString() ?? "") ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'selectedRole': selectedRole,
      'lastUpdated': Timestamp.fromDate(lastUpdated),
    };
  }
}
