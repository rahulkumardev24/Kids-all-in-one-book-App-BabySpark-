import 'package:babyspark/model/book_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseBookService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Stream books for real-time updates
  Stream<List<BookModel>> getBookData(String collection) {
    return _firestore
        .collection(collection)
        .orderBy('title', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => BookModel.fromJson(doc.data()))
          .toList();
    });
  }
}
