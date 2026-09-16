import '../models/transaction.dart';

/// Temporary in-memory data source used while the UI is being built.
/// Swap the methods here for real ApiService calls once you reconnect
/// the backend — the screens won't need to change.
class MockBank {
  MockBank._internal();
  static final MockBank instance = MockBank._internal();

  String accountHolder = 'Sandra Gaju';
  String accountNumber = '1234567890';
  String accountType = 'Savings';
  double balance = 2450.75;

  final List<Transaction> _transactions = [
    Transaction(
      id: '1',
      title: 'Grocery Store',
      amount: 45.20,
      type: TransactionType.debit,
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Transaction(
      id: '2',
      title: 'Salary Deposit',
      amount: 2200.00,
      type: TransactionType.credit,
      date: DateTime.now().subtract(const Duration(days: 3)),
    ),
    Transaction(
      id: '3',
      title: 'Transfer to Jane',
      amount: 150.00,
      type: TransactionType.debit,
      date: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  List<Transaction> get transactions =>
      List.unmodifiable(_transactions.reversed);

  /// Called right after a successful registration. Replaces the sample
  /// demo data with a fresh account under the name the person typed.
  void resetForNewUser(String fullName) {
    accountHolder = fullName;
    accountNumber = _generateAccountNumber();
    accountType = 'Savings';
    balance = 0.0;
    _transactions.clear();
  }

  /// Called right after a (mock) login, so signing back in doesn't
  /// silently reuse whatever the last registered/demo user left behind.
  void loginAs(String fullName) {
    accountHolder = fullName;
  }

  String _generateAccountNumber() {
    final now = DateTime.now().millisecondsSinceEpoch.toString();
    return now.substring(now.length - 10);
  }

  Future<void> deposit(double amount, String note) async {
    await Future.delayed(const Duration(milliseconds: 800));
    balance += amount;
    _transactions.add(Transaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: note.isEmpty ? 'Deposit' : note,
      amount: amount,
      type: TransactionType.credit,
      date: DateTime.now(),
    ));
  }

  Future<void> withdraw(double amount, String note) async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (amount > balance) {
      throw Exception('Insufficient balance');
    }
    balance -= amount;
    _transactions.add(Transaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: note.isEmpty ? 'Withdrawal' : note,
      amount: amount,
      type: TransactionType.debit,
      date: DateTime.now(),
    ));
  }

  Future<void> transfer(String toAccount, double amount, String note) async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (amount > balance) {
      throw Exception('Insufficient balance');
    }
    balance -= amount;
    _transactions.add(Transaction(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: note.isEmpty ? 'Transfer to $toAccount' : note,
      amount: amount,
      type: TransactionType.debit,
      date: DateTime.now(),
    ));
  }
}