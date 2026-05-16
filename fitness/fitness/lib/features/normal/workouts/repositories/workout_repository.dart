import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitpulse_gym/core/providers/firebase_providers.dart';

final workoutRepositoryProvider = Provider<WorkoutRepository>((ref) {
  return WorkoutRepository(ref.watch(firestoreProvider));
});

class WorkoutRepository {
  final FirebaseFirestore _firestore;
  WorkoutRepository(this._firestore);

  Future<void> saveWorkoutSession(String userId, Map<String, dynamic> sessionData) async {
    await _firestore
        .collection('userWorkouts')
        .doc(userId)
        .collection('sessions')
        .add({
          ...sessionData,
          'createdAt': FieldValue.serverTimestamp(),
        });
  }

  Stream<List<Map<String, dynamic>>> getWorkoutHistory(String userId) {
    return _firestore
        .collection('userWorkouts')
        .doc(userId)
        .collection('sessions')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }
}
