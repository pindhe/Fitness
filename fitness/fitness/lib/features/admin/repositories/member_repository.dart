import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitpulse_gym/core/providers/firebase_providers.dart';
import 'package:fitpulse_gym/features/admin/domain/models/member.dart';

final memberRepositoryProvider = Provider<MemberRepository>((ref) {
  return MemberRepository(ref.watch(firestoreProvider));
});

class MemberRepository {
  final FirebaseFirestore _firestore;
  MemberRepository(this._firestore);

  CollectionReference<Map<String, dynamic>> get _membersCollection =>
      _firestore.collection('members');

  Stream<List<Member>> getMembers() {
    return _membersCollection
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Member.fromMap(doc.id, doc.data()))
            .toList());
  }

  Future<String> generateMemberId() async {
    final snapshot = await _membersCollection.get();
    final count = snapshot.docs.length;
    final year = DateTime.now().year;
    final idNumber = count.toString().padLeft(3, '0');
    return 'Pin-$year-$idNumber';
  }

  Future<void> addMember(Member member) async {
    await _membersCollection.add(member.toMap());
  }

  Future<void> updateMember(Member member) async {
    await _membersCollection.doc(member.id).update(member.toMap());
  }

  Future<void> deleteMember(String id) async {
    await _membersCollection.doc(id).delete();
  }
}

final membersStreamProvider = StreamProvider<List<Member>>((ref) {
  return ref.watch(memberRepositoryProvider).getMembers();
});

final currentMemberProvider = FutureProvider<Member?>((ref) async {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return null;
  
  final repo = ref.watch(memberRepositoryProvider);
  final snapshot = await FirebaseFirestore.instance
      .collection('members')
      .where('email', isEqualTo: user.email)
      .limit(1)
      .get();
      
  if (snapshot.docs.isEmpty) return null;
  return Member.fromMap(snapshot.docs.first.id, snapshot.docs.first.data());
});
