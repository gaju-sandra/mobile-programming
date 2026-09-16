import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../services/mock_data.dart';
import '../theme/app_theme.dart';
import 'deposit_withdraw_screen.dart';
import 'transfer_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _bank = MockBank.instance;

  Future<void> _refresh() async {
    setState(() {}); // MockBank already holds the latest state in memory
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Welcome back,',
                          style: Theme.of(context).textTheme.bodySmall),
                      Text(_bank.accountHolder,
                          style: Theme.of(context).textTheme.titleLarge),
                    ],
                  ),
                  const CircleAvatar(
                    radius: 22,
                    backgroundColor: AppColors.primary,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Gradient balance card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _bank.accountType,
                          style: const TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                        const Icon(Icons.account_balance_wallet_outlined,
                            color: Colors.white70),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '\$${_bank.balance.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '•••• •••• •••• ${_bank.accountNumber.substring(_bank.accountNumber.length - 4)}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              Text('Quick actions', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _QuickAction(
                    icon: Icons.add_circle_outline,
                    label: 'Deposit',
                    color: AppColors.success,
                    onTap: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const DepositWithdrawScreen()));
                      setState(() {});
                    },
                  ),
                  _QuickAction(
                    icon: Icons.remove_circle_outline,
                    label: 'Withdraw',
                    color: AppColors.danger,
                    onTap: () async {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) =>
                                  const DepositWithdrawScreen(startWithWithdraw: true)));
                      setState(() {});
                    },
                  ),
                  _QuickAction(
                    icon: Icons.send_outlined,
                    label: 'Transfer',
                    color: AppColors.primary,
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              TransferScreen(fromAccountNumber: _bank.accountNumber),
                        ),
                      );
                      setState(() {});
                    },
                  ),
                ],
              ),
              const SizedBox(height: 28),

              Text('Recent activity', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              ..._bank.transactions.take(3).map((tx) {
                final isCredit = tx.type == TransactionType.credit;
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
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
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 100,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 13)),
          ],
        ),
      ),
    );
  }
}