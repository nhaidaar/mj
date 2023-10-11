import 'package:cloud_firestore/cloud_firestore.dart';

class WithdrawModel {
  final DateTime? withdrawMade;
  final String? uid;
  final String? withdrawId;
  final String? ewallet;
  final int? nominal;
  final String? tujuan;
  final bool? isFinished;

  WithdrawModel({
    this.withdrawMade,
    this.uid,
    this.withdrawId,
    this.ewallet,
    this.nominal,
    this.tujuan,
    this.isFinished,
  });

  Map<String, dynamic> toMap() {
    return {
      'withdrawMade': withdrawMade,
      'uid': uid,
      'withdrawId': withdrawId,
      'ewallet': ewallet,
      'nominal': nominal,
      'tujuan': tujuan,
      'isFinished': isFinished,
    };
  }

  factory WithdrawModel.fromMap(Map<String, dynamic> map) {
    return WithdrawModel(
      withdrawMade: (map['withdrawMade'] as Timestamp).toDate(),
      uid: map['uid'],
      withdrawId: map['withdrawId'],
      ewallet: map['ewallet'],
      nominal: map['nominal'],
      tujuan: map['tujuan'],
      isFinished: map['isFinished'],
    );
  }

  WithdrawModel copyWith({
    DateTime? withdrawMade,
    String? uid,
    String? withdrawId,
    String? ewallet,
    int? nominal,
    String? tujuan,
    bool? isFinished,
  }) =>
      WithdrawModel(
        withdrawMade: withdrawMade ?? this.withdrawMade,
        uid: uid ?? this.uid,
        withdrawId: withdrawId ?? this.withdrawId,
        ewallet: ewallet ?? this.ewallet,
        nominal: nominal ?? this.nominal,
        tujuan: tujuan ?? this.tujuan,
        isFinished: isFinished ?? this.isFinished,
      );
}
