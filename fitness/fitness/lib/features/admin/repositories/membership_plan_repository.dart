import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/membership_plan.dart';

final membershipPlanRepositoryProvider = Provider((ref) => MembershipPlanRepository());

final membershipPlansStreamProvider = StreamProvider<List<MembershipPlan>>((ref) {
  return ref.watch(membershipPlanRepositoryProvider).getPlans();
});

class MembershipPlanRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<MembershipPlan>> getPlans() {
    return _firestore
        .collection('membership_plans')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => MembershipPlan.fromMap(doc.data(), doc.id)).toList());
  }

  Future<void> addPlan(MembershipPlan plan) async {
    await _firestore.collection('membership_plans').add(plan.toMap());
  }

  Future<void> updatePlan(MembershipPlan plan) async {
    await _firestore.collection('membership_plans').doc(plan.id).update(plan.toMap());
  }

  Future<void> deletePlan(String id) async {
    await _firestore.collection('membership_plans').doc(id).delete();
  }
}
