import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/trainer.dart';

final trainerRepositoryProvider = Provider((ref) => TrainerRepository());

final trainersStreamProvider = StreamProvider<List<Trainer>>((ref) {
  return ref.watch(trainerRepositoryProvider).getTrainers();
});

class TrainerRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Trainer>> getTrainers() {
    return _firestore
        .collection('trainers')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Trainer.fromMap(doc.data(), doc.id)).toList());
  }

  Future<void> addTrainer(Trainer trainer) async {
    await _firestore.collection('trainers').add(trainer.toMap());
  }

  Future<void> updateTrainer(Trainer trainer) async {
    await _firestore.collection('trainers').doc(trainer.id).update(trainer.toMap());
  }

  Future<void> deleteTrainer(String id) async {
    await _firestore.collection('trainers').doc(id).delete();
  }
}
