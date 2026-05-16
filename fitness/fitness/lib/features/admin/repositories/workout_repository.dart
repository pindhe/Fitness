import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/workout.dart';

final workoutRepositoryProvider = Provider((ref) => WorkoutRepository());

final workoutsStreamProvider = StreamProvider<List<Workout>>((ref) {
  return ref.watch(workoutRepositoryProvider).getWorkouts();
});

class WorkoutRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Workout>> getWorkouts() {
    return _firestore
        .collection('workouts')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Workout.fromMap(doc.data(), doc.id)).toList());
  }

  Future<void> addWorkout(Workout workout) async {
    await _firestore.collection('workouts').add(workout.toMap());
  }

  Future<void> updateWorkout(Workout workout) async {
    await _firestore.collection('workouts').doc(workout.id).update(workout.toMap());
  }

  Future<void> deleteWorkout(String id) async {
    await _firestore.collection('workouts').doc(id).delete();
  }
}
