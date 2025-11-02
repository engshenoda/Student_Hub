import 'package:cloud_firestore/cloud_firestore.dart';

class CareerIndustry {
  final List<String> selectedOptions;
  final DateTime lastUpdated;

  CareerIndustry({
    required this.selectedOptions,
    required this.lastUpdated,
  });


  factory CareerIndustry.fromFirestore(Map<String, dynamic> data) {
    return CareerIndustry(
      selectedOptions: List<String>.from(data['selectedOptions'] ?? []),
      lastUpdated: (data['lastUpdated'] is Timestamp)
          ? (data['lastUpdated'] as Timestamp).toDate()
          : DateTime.tryParse(data['lastUpdated']?.toString() ?? '') ??
              DateTime.now(),
    );
  }


  Map<String, dynamic> toFirestore() {
    return {
      'selectedOptions': selectedOptions,
      'lastUpdated': Timestamp.fromDate(lastUpdated),
    };
  }


  factory CareerIndustry.fromMap(Map<String, dynamic> map) {
    return CareerIndustry(
      selectedOptions: List<String>.from(map['selectedOptions'] ?? []),
      lastUpdated: DateTime.tryParse(map['lastUpdated']?.toString() ?? '') ??
          DateTime.now(),
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'selectedOptions': selectedOptions,
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }


  CareerIndustry copyWith({
    List<String>? selectedOptions,
    DateTime? lastUpdated,
  }) {
    return CareerIndustry(
      selectedOptions: selectedOptions ?? this.selectedOptions,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
