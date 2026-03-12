// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:flutter/foundation.dart';

class WalletAddresses {
  final String bip44;
  final String bip49;
  final String bip84;
  final String bip86;

  WalletAddresses({
    required this.bip44,
    required this.bip49,
    required this.bip84,
    required this.bip86,
  });

  Map<String, dynamic> toMap() {
    return {'bip44': bip44, 'bip49': bip49, 'bip84': bip84, 'bip86': bip86};
  }

  factory WalletAddresses.fromMap(Map<String, dynamic> map) {
    return WalletAddresses(
      bip44: map['bip44'] as String,
      bip49: map['bip49'] as String,
      bip84: map['bip84'] as String,
      bip86: map['bip86'] as String,
    );
  }

  @override
  String toString() {
    return 'WalletAddresses(bip44: $bip44, bip49: $bip49, bip84: $bip84, bip86: $bip86)';
  }
}

class WalletBalances {
  final String bip44;
  final String bip49;
  final String bip84;
  final String bip86;

  WalletBalances({
    required this.bip44,
    required this.bip49,
    required this.bip84,
    required this.bip86,
  });

  Map<String, dynamic> toMap() {
    return {'bip44': bip44, 'bip49': bip49, 'bip84': bip84, 'bip86': bip86};
  }

  factory WalletBalances.fromMap(Map<String, dynamic> map) {
    return WalletBalances(
      bip44: map['bip44'] as String,
      bip49: map['bip49'] as String,
      bip84: map['bip84'] as String,
      bip86: map['bip86'] as String,
    );
  }

  @override
  String toString() {
    return 'WalletBalances(bip44: $bip44, bip49: $bip49, bip84: $bip84, bip86: $bip86)';
  }
}

class Usersdatamodels {
  final String mnemonic;
  final String walletName;
  final String Id;
  final String total_balance;
  final WalletAddresses addresses;
  final WalletBalances balances;
  final List<Map<String, dynamic>> all_transactions;

  Usersdatamodels({
    required this.mnemonic,
    required this.walletName,
    required this.Id,
    required this.total_balance,
    required this.addresses,
    required this.balances,
    required this.all_transactions,
  });

  Usersdatamodels copyWith({
    String? mnemonic,
    String? id,
    String? walletName,
    String? total_balance,
    WalletAddresses? addresses,
    WalletBalances? balances,
    List<Map<String, dynamic>>? all_transactions,
  }) {
    return Usersdatamodels(
      mnemonic: mnemonic ?? this.mnemonic,
      walletName: walletName?? this.walletName,
      Id: id ?? this.Id,
      total_balance: total_balance ?? this.total_balance,
      addresses: addresses ?? this.addresses,
      balances: balances ?? this.balances,
      all_transactions: all_transactions ?? this.all_transactions,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'mnemonic': mnemonic,
      'walletName':walletName,
      'total_balance': total_balance,
      'addresses': addresses.toMap(),
      'balances': balances.toMap(),
      'all_transactions': all_transactions,
    };
  }

  factory Usersdatamodels.fromMap(Map<String, dynamic> map) {
    return Usersdatamodels(
      walletName: map['walletName']as String,
      mnemonic: map['mnemonic'] as String,
      Id: map['id'] as String,
      total_balance: map['total_balance'] as String,
      addresses: WalletAddresses.fromMap(
        map['addresses'] as Map<String, dynamic>,
      ),
      balances: WalletBalances.fromMap(map['balances'] as Map<String, dynamic>),
      all_transactions: List<Map<String, dynamic>>.from(
        (map['all_transactions'] as List).map(
          (e) => Map<String, dynamic>.from(e),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory Usersdatamodels.fromJson(String source) =>
      Usersdatamodels.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Usersdatamodels(mnemonic: $mnemonic, total_balance: $total_balance, addresses: $addresses, balances: $balances, all_transactions: $all_transactions) id:$Id walletName:$walletName';
  }

  @override
  bool operator ==(covariant Usersdatamodels other) {
    if (identical(this, other)) return true;

    return other.mnemonic == mnemonic &&
        other.total_balance == total_balance &&
        other.addresses.bip44 == addresses.bip44 &&
        other.addresses.bip49 == addresses.bip49 &&
        other.addresses.bip84 == addresses.bip84 &&
        other.addresses.bip86 == addresses.bip86 &&
        other.balances.bip44 == balances.bip44 &&
        other.balances.bip49 == balances.bip49 &&
        other.balances.bip84 == balances.bip84 &&
        other.balances.bip86 == balances.bip86 &&
        listEquals(other.all_transactions, all_transactions);
  }

  @override
  int get hashCode {
    return mnemonic.hashCode ^
        total_balance.hashCode ^
        addresses.bip44.hashCode ^
        addresses.bip49.hashCode ^
        addresses.bip84.hashCode ^
        addresses.bip86.hashCode ^
        balances.bip44.hashCode ^
        balances.bip49.hashCode ^
        balances.bip84.hashCode ^
        balances.bip86.hashCode ^
        all_transactions.hashCode;
  }
}
