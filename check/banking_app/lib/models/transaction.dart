enum TransactionType { credit, debit }

class Transaction {
  final String id;
  final String title;
  final double amount;
  final TransactionType type;
  final DateTime date;

  Transaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.type,
    required this.date,
  });

  // NOTE: verify these field names against your real
  // /api/transactions/history/{accountId} response in Postman.
  factory Transaction.fromJson(Map<String, dynamic> json) {
    final rawType = json['type']?.toString().toUpperCase() ?? '';

    return Transaction(
      id: json['id']?.toString() ?? '',
      title: json['description']?.toString() ?? json['title']?.toString() ?? 'Transaction',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      // DEPOSIT counts as money coming in (credit); WITHDRAW/TRANSFER as going out (debit).
      // Adjust this if your backend distinguishes incoming vs outgoing transfers differently.
      type: rawType == 'DEPOSIT' ? TransactionType.credit : TransactionType.debit,
      date: json['date'] != null
          ? DateTime.tryParse(json['date'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}