// import 'dart:io';
// import 'package:bloc/bloc.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:linkedin/features/questions/Model/Docs_model.dart';
// import 'package:meta/meta.dart';
// import 'package:path/path.dart' as path;

// part 'docs_state.dart';

// class DocsCubit extends Cubit<DocsState> {
//   DocsCubit() : super(DocsInitial());

//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseStorage _storage = FirebaseStorage.instance;

//   Future<void> loadDocs(String userId, {String? filetype}) async {
//     emit(DocsLoading());
//     try {
//       Query query = _firestore
//           .collection('users')
//           .doc(userId)
//           .collection('documents');

//       if (filetype != null && filetype.isNotEmpty) {
//         query = query.where('filetype', isEqualTo: filetype);
//       }

//       final snapshot = await query.get();

//       final docs = snapshot.docs
//           .map((e) => DocsModel.fromMap(e.data() as Map<String, dynamic>))
//           .toList();

//       if (docs.isEmpty) {
//         emit(DocsEmpty());
//       } else {
//         emit(DocsLoaded(docs));
//       }
//     } catch (e) {
//       emit(DocsError('Failed to load documents: $e'));
//     }
//   }

//   Future<void> uploadFile(String userId, File file) async {
//     emit(DocsUploading());
//     try {
//       final fileName = path.basename(file.path);
//       final fileExtension = path.extension(file.path).replaceAll('.', '');
//       final fileSize = await file.length();
//       final storageRef = _storage.ref().child('users/$userId/documents/$fileName');

//       final uploadTask = await storageRef.putFile(file);
//       final downloadUrl = await uploadTask.ref.getDownloadURL();

//       final doc = DocsModel(
//         filename: fileName,
//         fileurl: downloadUrl,
//         filetype: fileExtension,
//         filesize: fileSize,
//         uploadDate: DateTime.now(),
//       );

//       await _firestore
//           .collection('users')
//           .doc(userId)
//           .collection('documents')
//           .add(doc.toMap());

//       emit(DocsUploaded(doc));
//     } catch (e) {
//       emit(DocsError('Upload failed: $e'));
//     }
//   }

//   Future<void> deleteDoc(String userId, DocsModel doc) async {
//     emit(DocsLoading());
//     try {
//       final snapshot = await _firestore
//           .collection('users')
//           .doc(userId)
//           .collection('documents')
//           .where('fileurl', isEqualTo: doc.fileurl)
//           .get();

//       for (final d in snapshot.docs) {
//         await d.reference.delete();
//       }

//       await _storage.refFromURL(doc.fileurl).delete();

//       emit(DocsDeleted(doc.filename));
//     } catch (e) {
//       emit(DocsError('Delete failed: $e'));
//     }
//   }
// }
