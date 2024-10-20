import '../services/firestore_helper.dart';
import '../models/improvement_item.dart';

class ImprovementController {
  final FirestoreHelper _firestoreHelper = FirestoreHelper();

  Future<List<ImprovementItem>> fetchImprovementItems() async {
    return await _firestoreHelper.getImprovementItems();
  }

  Future<void> addOrUpdateImprovementItem(ImprovementItem item) async {
    if (item.id == null) {
      await _firestoreHelper.insertImprovementItem(item);
    } else {
      await _firestoreHelper.updateImprovementItem(item);
    }
  }

  Future<void> deleteImprovementItem(String id) async {
    await _firestoreHelper.deleteImprovementItem(id);
  }

  Future<void> addMood(
      String improvementItemId, String date, String mood) async {
    await _firestoreHelper.addMood(improvementItemId, date, mood);
  }
}
