import 'package:cloud_firestore/cloud_firestore.dart';

class Payment {
  final String id;
  final String invoiceId;
  final String memberName;
  final String memberId;
  final double amount;
  final String status; // 'Paid', 'Pending', 'Failed'
  final String method; // 'Credit Card', 'PayPal', 'Transfer'
  final DateTime date;
  final String plan;

  Payment({
    required this.id,
    required this.invoiceId,
    required this.memberName,
    required this.memberId,
    required this.amount,
    required this.status,
    required this.method,
    required this.date,
    required this.plan,
  });

  factory Payment.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Payment(
      id: doc.id,
      invoiceId: data['invoiceId'] ?? '',
      memberName: data['memberName'] ?? '',
      memberId: data['memberId'] ?? '',
      amount: (data['amount'] ?? 0).toDouble(),
      status: data['status'] ?? 'Pending',
      method: data['method'] ?? 'Unknown',
      date: (data['date'] as Timestamp).toDate(),
      plan: data['plan'] ?? 'Basic',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'invoiceId': invoiceId,
      'memberName': memberName,
      'memberId': memberId,
      'amount': amount,
      'status': status,
      'method': method,
      'date': Timestamp.fromDate(date),
      'plan': plan,
    };
  }
}
