// import 'package:cloud_firestore/cloud_firestore.dart';

// class CareerjobTitleModel {
//   final String selectedjobTitle;
//   final DateTime lastUpdated;

//   CareerjobTitleModel({
//     required this.selectedjobTitle,
//     required this.lastUpdated,
//   });

//   factory CareerjobTitleModel.fromMap(Map<String, dynamic> map) {
//     return CareerjobTitleModel(
//       selectedjobTitle: map['selectedjobTitle'] ?? "",
//       lastUpdated: map['lastUpdated'] is Timestamp
//           ? (map['lastUpdated'] as Timestamp).toDate()
//           : DateTime.tryParse(map['lastUpdated']?.toString() ?? "") ?? DateTime.now(),
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'selectedjobTitle': selectedjobTitle,
//       'lastUpdated': Timestamp.fromDate(lastUpdated),
//     };
//   }
// }
