
// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:flutter/foundation.dart';

class Usersdatamodels {
  final String mnemonic;
  final String bitcoin_address;
  final String bitcoin_externaldescriptor;
  final String bitcoin_internaldescriptor;
  final List<Map<String, dynamic>> bitcoin_transactions_history;
  final String bitcoin_bal;

  Usersdatamodels(
    this.mnemonic,
    this.bitcoin_address,
    this.bitcoin_externaldescriptor,
    this.bitcoin_internaldescriptor,
    this.bitcoin_transactions_history,
    this.bitcoin_bal,
  );

  Usersdatamodels copyWith({
    String? mnemonic,
    String? bitcoin_address,
    String? bitcoin_externaldescriptor,
    String? bitcoin_internaldescriptor,
    List<Map<String, dynamic>>? bitcoin_transactions_history,
    String? bitcoin_bal,
  }) {
    return Usersdatamodels(
      mnemonic ?? this.mnemonic,
      bitcoin_address ?? this.bitcoin_address,
      bitcoin_externaldescriptor ?? this.bitcoin_externaldescriptor,
      bitcoin_internaldescriptor ?? this.bitcoin_internaldescriptor,
      bitcoin_transactions_history ?? this.bitcoin_transactions_history,
      bitcoin_bal ?? this.bitcoin_bal,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'mnemonic': mnemonic,
      'bitcoin_address': bitcoin_address,
      'bitcoin_externaldescriptor': bitcoin_externaldescriptor,
      'bitcoin_internaldescriptor': bitcoin_internaldescriptor,
      'bitcoin_transactions_history': bitcoin_transactions_history,
      'bitcoin_bal': bitcoin_bal,
    };
  }

  factory Usersdatamodels.fromMap(Map<String, dynamic> map) {
    return Usersdatamodels(
      map['mnemonic'] as String,
      map['bitcoin_address'] as String,
      map['bitcoin_externaldescriptor'] as String,
      map['bitcoin_internaldescriptor'] as String,
      List<Map<String, dynamic>>.from(
        (map['bitcoin_transactions_history'] as List)
            .map((e) => Map<String, dynamic>.from(e)),
      ),
      map['bitcoin_bal'].toString(),
    );
  }

  String toJson() => json.encode(toMap());

  factory Usersdatamodels.fromJson(String source) =>
      Usersdatamodels.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Usersdatamodels(mnemonic: $mnemonic, bitcoin_address: $bitcoin_address, bitcoin_externaldescriptor: $bitcoin_externaldescriptor, bitcoin_internaldescriptor: $bitcoin_internaldescriptor, bitcoin_transactions_history: $bitcoin_transactions_history, bitcoin_bal: $bitcoin_bal)';
  }

  @override
  bool operator ==(covariant Usersdatamodels other) {
    if (identical(this, other)) return true;

    return other.mnemonic == mnemonic &&
        other.bitcoin_address == bitcoin_address &&
        other.bitcoin_externaldescriptor == bitcoin_externaldescriptor &&
        other.bitcoin_internaldescriptor == bitcoin_internaldescriptor &&
        listEquals(other.bitcoin_transactions_history, bitcoin_transactions_history) &&
        other.bitcoin_bal == bitcoin_bal;
  }

  @override
  int get hashCode {
    return mnemonic.hashCode ^
        bitcoin_address.hashCode ^
        bitcoin_externaldescriptor.hashCode ^
        bitcoin_internaldescriptor.hashCode ^
        bitcoin_transactions_history.hashCode ^
        bitcoin_bal.hashCode;
  }
}
