import 'package:flutter/material.dart';
import '../services/mock_data.dart';
import '../theme/app_theme.dart';
import 'deposit_withdraw_screen.dart';
import 'transfer_screen.dart';

class MoveMoneyScreen extends StatefulWidget {
  const MoveMoneyScreen({super.key});

  @override
  State<MoveMoneyScreen> createState() => _MoveMoneyScreenState();
}

class _MoveMoneyScreenState extends State<MoveMoneyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Move Money')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _MoveOption(
            icon: Icons.add_circle_outline,
            color: AppColors.success,
            title: 'Deposit',
            subtitle: 'Add money to your account',
            onTap: () async {
              await Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const DepositWithdrawScreen()));
              setState(() {});
            },
          ),
          const SizedBox(height: 14),
          _MoveOption(
            icon: Icons.remove_circle_outline,
            color: AppColors.danger,
            title: 'Withdraw',
            subtitle: 'Take money out of your account',
            onTap: () async {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const DepositWithdrawScreen(startWithWithdraw: true)));
              setState(() {});
            },
          ),
          const SizedBox(height: 14),
          _MoveOption(
            icon: Icons.send_outlined,
            color: AppColors.primary,
            title: 'Transfer',
            subtitle: 'Send money to another account',
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => TransferScreen(
                    fromAccountNumber: MockBank.instance.accountNumber,
                  ),
                ),
              );
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}

class _MoveOption extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MoveOption({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: color.withValues(alpha: 0.1),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16)),
                    const SizedBox(height: 2),
                    Text(subtitle,
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}