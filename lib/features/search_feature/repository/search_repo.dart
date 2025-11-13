import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:linkedin/features/search_feature/model/search_model.dart';

class SearchRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Stream<List<UserModel>> streamPeople(String query) {
    return _firestore
        .collection('users')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThan: '${query}z')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => UserModel.fromMap(doc.data(), id: doc.id))
            .toList());
  }

  
  Stream<List<PostModel>> streamPosts(String query) {
    return _firestore
        .collection('posts')
        .where('title', isGreaterThanOrEqualTo: query)
        .where('title', isLessThan: '${query}z')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => PostModel.fromMap(doc.data(), id: doc.id))
            .toList());
  }

  
  Stream<List<JobModel>> streamJobs(String query) {
    return _firestore
        .collection('jobs')
        .where('title', isGreaterThanOrEqualTo: query)
        .where('title', isLessThan: '${query}z')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => JobModel.fromMap(doc.data(), id: doc.id))
            .toList());
  }

}

