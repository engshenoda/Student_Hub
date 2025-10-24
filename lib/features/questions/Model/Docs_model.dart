import 'package:cloud_firestore/cloud_firestore.dart';

class DocsModel {
  final String filename;
  final String fileurl;
  final String filetype;
  final int filesize;
  final DateTime uploadDate;

  DocsModel({
    required this.filename,
    required this.fileurl,
    required this.filetype,
    required this.filesize,
    required this.uploadDate,
  });

  
  factory DocsModel.fromMap(Map<String, dynamic> map) {
    return DocsModel(
      filename: map['filename'] ?? '',
      fileurl: map['fileurl'] ?? '',
      filetype: map['filetype'] ?? '',
      filesize: map['filesize'] ?? 0,
      uploadDate: map['uploadDate'] is Timestamp
          ? (map['uploadDate'] as Timestamp).toDate()
          : DateTime.tryParse(map['uploadDate']?.toString() ?? '') ??
              DateTime.now(),
    );
  }

 
  Map<String, dynamic> toMap() {
    return {
      'filename': filename,
      'fileurl': fileurl,
      'filetype': filetype,
      'filesize': filesize,
      'uploadDate': Timestamp.fromDate(uploadDate),
    };
  }


  DocsModel copyWith({
    String? filename,
    String? fileurl,
    String? filetype,
    int? filesize,
    DateTime? uploadDate,
  }) {
    return DocsModel(
      filename: filename ?? this.filename,
      fileurl: fileurl ?? this.fileurl,
      filetype: filetype ?? this.filetype,
      filesize: filesize ?? this.filesize,
      uploadDate: uploadDate ?? this.uploadDate,
    );
  }
}
