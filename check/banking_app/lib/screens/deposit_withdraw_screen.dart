import 'package:flutter/material.dart';
import '../services/mock_data.dart';
import '../theme/app_theme.dart';

enum _Mode { deposit, withdraw }

/// A single screen for both Deposit and Withdraw, switched with a toggle.
/// Pass an initial mode so callers (Dashboard, Move Money) can open it
/// straight into the one they tapped.
class DepositWithdrawScreen extends StatefulWidget {
  final bool startWithWithdraw;

  const DepositWithdrawScreen({super.key, this.startWithWithdraw = false});

  @override
  State<DepositWithdrawScreen> createState() => _DepositWithdrawScreenState();
}

class _DepositWithdrawScreenState extends State<DepositWithdrawScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();

  late _Mode _mode;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _mode = widget.startWithWithdraw ? _Mode.withdraw : _Mode.deposit;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  bool get _isDeposit => _mode == _Mode.deposit;
  Color get _modeColor => _isDeposit ? AppColors.success : AppColors.danger;

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    try {
      final amount = double.parse(_amountController.text);
      if (_isDeposit) {
        await MockBank.instance.deposit(amount, _noteController.text);
      } else {
        await MockBank.instance.withdraw(amount, _noteController.text);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_isDeposit ? 'Deposit successful!' : 'Withdrawal successful!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString().replaceAll('Exception: ', ''))),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final balance = MockBank.instance.balance;

    return Scaffold(
      appBar: AppBar(title: const Text('Deposit / Withdraw')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Toggle between Deposit and Withdraw
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _ModeButton(
                        label: 'Deposit',
                        selected: _isDeposit,
                        color: AppColors.success,
                        onTap: () => setState(() => _mode = _Mode.deposit),
                      ),
                    ),
                    Expanded(
                      child: _ModeButton(
                        label: 'Withdraw',
                        selected: !_isDeposit,
                        color: AppColors.danger,
                        onTap: () => setState(() => _mode = _Mode.withdraw),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: _modeColor.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(
                      _isDeposit ? Icons.add_circle : Icons.remove_circle,
                      color: _modeColor,
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        _isDeposit
                            ? 'Add money to your account'
                            : 'Available balance: \$${balance.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(labelText: 'Amount', prefixText: '\$ '),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter an amount';
                  final parsed = double.tryParse(value);
                  if (parsed == null || parsed <= 0) return 'Enter a valid amount';
                  if (!_isDeposit && parsed > balance) return 'Amount exceeds your balance';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(labelText: 'Note (optional)'),
              ),
              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: _isLoading ? null : _handleSubmit,
                style: ElevatedButton.styleFrom(backgroundColor: _modeColor),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : Text(_isDeposit ? 'Deposit' : 'Withdraw'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModeButton extends StatelessWidget {
  final String label;
  final bool selected;
  final Color color;
  final VoidCallback onTap;

  const _ModeButton({
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : AppColors.textMuted,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}