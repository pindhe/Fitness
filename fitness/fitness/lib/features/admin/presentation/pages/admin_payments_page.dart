import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:fitpulse_gym/shared/widgets/sidebar.dart';
import 'package:fitpulse_gym/shared/widgets/admin_footer.dart';
import 'package:fitpulse_gym/features/admin/domain/models/payment.dart';
import 'package:fitpulse_gym/features/admin/repositories/payment_repository.dart';

class AdminPaymentsPage extends ConsumerWidget {
  const AdminPaymentsPage({super.key});

  void _showInvoiceDetails(BuildContext context, Payment payment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0B0F14),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
      builder: (context) => Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: const Color(0xFF1E2630),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('TRANSACTION LEDGER', style: TextStyle(color: Color(0xFF00FF88), fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 2)),
                IconButton(icon: const Icon(LucideIcons.x, color: Colors.white38), onPressed: () => Navigator.pop(context)),
              ],
            ),
            const SizedBox(height: 32),
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: const Color(0xFF00FF88).withOpacity(0.1), shape: BoxShape.circle),
                    child: const Icon(LucideIcons.checkCircle2, color: Color(0xFF00FF88), size: 48),
                  ),
                  const SizedBox(height: 16),
                  Text('\$${payment.amount.toStringAsFixed(2)}', style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
                  const Text('Payment Successful', style: TextStyle(color: Color(0xFF00FF88), fontSize: 14)),
                ],
              ),
            ),
            const SizedBox(height: 40),
            _buildDetailField('Invoice Serial', payment.invoiceId, LucideIcons.fileText),
            _buildDetailField('Member Identity', payment.memberName, LucideIcons.user),
            _buildDetailField('Subscription Node', payment.plan, LucideIcons.award),
            _buildDetailField('Gateway Protocol', payment.method, LucideIcons.creditCard),
            _buildDetailField('Timestamp', payment.date.toString().substring(0, 16), LucideIcons.clock),
            const SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: BorderSide(color: Colors.white.withOpacity(0.1)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    icon: const Icon(LucideIcons.download, size: 18, color: Colors.white70),
                    label: const Text('PDF RECEIPT', style: TextStyle(color: Colors.white70)),
                    onPressed: () => _simulateDownload(context, payment.invoiceId),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    icon: const Icon(LucideIcons.share2, size: 18),
                    label: const Text('SHARE LEDGER'),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailField(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        children: [
          Icon(icon, color: Colors.white24, size: 20),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.white38, fontSize: 11)),
              Text(value, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  void _simulateDownload(BuildContext context, String invoiceId) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(LucideIcons.downloadCloud, color: Colors.white, size: 18),
            const SizedBox(width: 12),
            Text('Generating $invoiceId.pdf ...'),
          ],
        ),
        backgroundColor: const Color(0xFF00FF88),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final paymentsAsync = ref.watch(paymentsStreamProvider);

    return Scaffold(
      drawer: const FitPulseSidebar(),
      backgroundColor: const Color(0xFF0B0F14),
      bottomNavigationBar: const FitPulseAdminFooter(currentRoute: '/admin/payments'),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0F14).withOpacity(0.95),
        elevation: 0,
        title: const Text('Revenue & Payments', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(LucideIcons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(LucideIcons.plusCircle, color: Color(0xFF00FF88)),
            onPressed: () async {
              final repo = ref.read(paymentRepositoryProvider);
              final invoice = await repo.generateInvoiceId();
              await repo.addPayment(Payment(
                id: '',
                invoiceId: invoice,
                memberName: 'Demo Member',
                memberId: 'MEM-001',
                amount: 59.99,
                status: 'Paid',
                method: 'Zaad',
                date: DateTime.now(),
                plan: 'Pro Plan',
              ));
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRevenueOverview(),
            const SizedBox(height: 32),
            _buildPaymentMethods(),
            const SizedBox(height: 32),
            paymentsAsync.when(
              data: (payments) => _buildTransactionHistory(context, payments),
              loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF00FF88))),
              error: (e, _) => Center(child: Text('Ledger Error: $e', style: const TextStyle(color: Colors.redAccent))),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueOverview() {
    return Row(
      children: [
        Expanded(child: _buildRevenueCard('Monthly Revenue', '\$48,290.00', '+15.2%', const Color(0xFF00FF88))),
        const SizedBox(width: 16),
        Expanded(child: _buildRevenueCard('Pending Payments', '\$2,450.00', '12 Active', Colors.orangeAccent)),
        const SizedBox(width: 16),
        Expanded(child: _buildRevenueCard('Total Subscriptions', '842', '+48 new', const Color(0xFF3B82F6))),
      ],
    ).animate().fadeIn().slideY(begin: 0.1);
  }

  Widget _buildRevenueCard(String title, String value, String subtitle, Color color) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1)),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(subtitle, style: const TextStyle(color: Colors.white38, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildPaymentMethods() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Payment Methods', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildMethodChip('Zaad', const Color(0xFF00FF88)),
              const SizedBox(width: 12),
              _buildMethodChip('Edahab', Colors.orangeAccent),
              const SizedBox(width: 12),
              _buildMethodChip('Sahal', const Color(0xFF3B82F6)),
              const SizedBox(width: 12),
              _buildMethodChip('Credit Card', Colors.purpleAccent),
              const SizedBox(width: 12),
              _buildMethodChip('Cash', Colors.white38),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMethodChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(label, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildTransactionHistory(BuildContext context, List<Payment> payments) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Recent Transactions', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            TextButton(onPressed: () {}, child: const Text('Export CSV', style: TextStyle(color: Color(0xFF3B82F6)))),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: payments.isEmpty 
            ? const Padding(
                padding: EdgeInsets.all(40.0),
                child: Center(child: Text('No transactions recorded', style: TextStyle(color: Colors.white24))),
              )
            : Column(
                children: payments.map((p) => _buildTransactionRow(context, p)).toList(),
              ),
        ),
      ],
    ).animate().fadeIn(delay: 300.ms);
  }

  Widget _buildTransactionRow(BuildContext context, Payment payment) {
    final statusColor = payment.status == 'Paid' ? const Color(0xFF00FF88) : Colors.orangeAccent;
    return InkWell(
      onTap: () => _showInvoiceDetails(context, payment),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(flex: 2, child: Text(payment.invoiceId, style: const TextStyle(color: Color(0xFF00FF88), fontWeight: FontWeight.bold, fontSize: 12))),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(payment.memberName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  Text(payment.plan, style: const TextStyle(color: Colors.white38, fontSize: 11)),
                ],
              ),
            ),
            Expanded(flex: 2, child: Text('\$${payment.amount}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                child: Text(payment.status, style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
              ),
            ),
            IconButton(
              icon: const Icon(LucideIcons.fileText, color: Colors.white38, size: 16),
              onPressed: () => _showInvoiceDetails(context, payment),
            ),
          ],
        ),
      ),
    );
  }
}

