import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/models/payment.dart';

final paymentRepositoryProvider = Provider((ref) => PaymentRepository());

final paymentsStreamProvider = StreamProvider<List<Payment>>((ref) {
  return ref.watch(paymentRepositoryProvider).getPayments();
});

class PaymentRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Payment>> getPayments() {
    return _firestore
        .collection('payments')
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Payment.fromFirestore(doc)).toList());
  }

  Future<void> addPayment(Payment payment) async {
    await _firestore.collection('payments').add(payment.toFirestore());
  }

  Future<String> generateInvoiceId() async {
    final now = DateTime.now();
    return 'INV-${now.year}${now.month}${now.day}-${now.microsecond.toString().substring(0, 3)}';
  }
}
