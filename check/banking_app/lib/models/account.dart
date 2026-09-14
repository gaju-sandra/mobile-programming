class Account {
  final int id;
  final String accountNumber;
  final String accountHolder;
  final double balance;
  final String accountType;

  Account({
    required this.id,
    required this.accountNumber,
    required this.accountHolder,
    required this.balance,
    required this.accountType,
  });

  // NOTE: verify these field names against your real /api/accounts response
  // in Postman, and adjust the keys below to match exactly.
  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id']?.toString() ?? '') ?? 0,
      accountNumber: json['accountNumber']?.toString() ?? '',
      accountHolder: json['accountHolder']?.toString() ?? '',
      balance: (json['balance'] as num?)?.toDouble() ?? 0.0,
      accountType: json['accountType']?.toString() ?? '',
    );
  }
}