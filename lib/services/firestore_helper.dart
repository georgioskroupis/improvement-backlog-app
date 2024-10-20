import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/improvement_item.dart';

class FirestoreHelper {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName = 'improvement_items';

  Future<List<ImprovementItem>> getImprovementItems() async {
    QuerySnapshot snapshot = await _firestore.collection(collectionName).get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id;
      return ImprovementItem.fromMap(data);
    }).toList();
  }

  Future<void> insertImprovementItem(ImprovementItem item) async {
    await _firestore.collection(collectionName).add(item.toMap());
  }

  Future<void> updateImprovementItem(ImprovementItem item) async {
    await _firestore
        .collection(collectionName)
        .doc(item.id)
        .update(item.toMap());
  }

  Future<void> deleteImprovementItem(String id) async {
    await _firestore.collection(collectionName).doc(id).delete();
  }

  Future<void> addMood(
      String improvementItemId, String date, String mood) async {
    DocumentReference docRef =
        _firestore.collection(collectionName).doc(improvementItemId);
    DocumentSnapshot snapshot = await docRef.get();

    if (snapshot.exists) {
      List<dynamic> feelings =
          (snapshot.data() as Map<String, dynamic>)['feelings'] ?? [];
      bool dateExists = false;

      for (var feeling in feelings) {
        if (feeling['date'] == date) {
          feeling['moods'].add(mood);
          dateExists = true;
          break;
        }
      }

      if (!dateExists) {
        feelings.add({
          'date': date,
          'moods': [mood]
        });
      }

      await docRef.update({'feelings': feelings});
    }
  }
}
