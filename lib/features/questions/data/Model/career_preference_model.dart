// import 'package:cloud_firestore/cloud_firestore.dart';

// class CareerPreference {
//   final String selectedOption;
//   final DateTime lastUpdated;

//   CareerPreference({
//     required this.selectedOption,
//     required this.lastUpdated,
//   });

//   factory CareerPreference.fromMap(Map map) {
//     return CareerPreference(
//       selectedOption: map['selectedOption'] ?? '',
//       lastUpdated: map['lastUpdated'] is Timestamp
//           ? (map['lastUpdated'] as Timestamp).toDate()
//           : DateTime.tryParse(map['lastUpdated']?.toString() ?? '') ?? DateTime.now(),
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'selectedOption': selectedOption,
//       'lastUpdated': Timestamp.fromDate(lastUpdated),
//     };
//   }

//   CareerPreference copyWith({
//     String? selectedOption,
//     DateTime? lastUpdated,
//   }) {
//     return CareerPreference(
//       selectedOption: selectedOption ?? this.selectedOption,
//       lastUpdated: lastUpdated ?? this.lastUpdated,
//     );
//   }
// }
