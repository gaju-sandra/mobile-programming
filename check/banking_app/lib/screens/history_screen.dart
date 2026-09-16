import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../services/mock_data.dart';
import '../theme/app_theme.dart';

/// Used as a bottom-nav tab (in HomeShell) — reads straight from MockBank,
/// no accountId needed since there's only one mock account.
class HistoryTabScreen extends StatefulWidget {
  const HistoryTabScreen({super.key});

  @override
  State<HistoryTabScreen> createState() => _HistoryTabScreenState();
}

class _HistoryTabScreenState extends State<HistoryTabScreen> {
  @override
  Widget build(BuildContext context) {
    final transactions = MockBank.instance.transactions;

    return Scaffold(
      appBar: AppBar(title: const Text('Activity')),
      body: RefreshIndicator(
        onRefresh: () async => setState(() {}),
        child: transactions.isEmpty
            ? ListView(
                children: const [
                  SizedBox(height: 100),
                  Center(child: Text('No transactions yet.')),
                ],
              )
            : ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final tx = transactions[index];
                  final isCredit = tx.type == TransactionType.credit;

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isCredit
                            ? AppColors.success.withValues(alpha: 0.1)
                            : AppColors.danger.withValues(alpha: 0.1),
                        child: Icon(
                          isCredit ? Icons.arrow_downward : Icons.arrow_upward,
                          color: isCredit ? AppColors.success : AppColors.danger,
                        ),
                      ),
                      title: Text(tx.title),
                      subtitle: Text('${tx.date.day}/${tx.date.month}/${tx.date.year}'),
                      trailing: Text(
                        '${isCredit ? '+' : '-'}\$${tx.amount.toStringAsFixed(2)}',
                        style: TextStyle(
                          color: isCredit ? AppColors.success : AppColors.danger,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}