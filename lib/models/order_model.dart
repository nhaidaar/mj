import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final DateTime? orderMade;
  final String? orderId;
  final String? uid;
  final bool? isFinished;
  final String? shortAddress;
  final String? fullAddress;
  final double? latitude;
  final double? longitude;
  final double? minyak;
  final int? poin;

  OrderModel({
    this.orderMade,
    this.orderId,
    this.uid,
    this.isFinished,
    this.shortAddress,
    this.fullAddress,
    this.latitude,
    this.longitude,
    this.minyak,
    this.poin,
  });

  Map<String, dynamic> toMap() {
    return {
      'orderMade': orderMade,
      'orderId': orderId,
      'uid': uid,
      'isFinished': isFinished,
      'shortAddress': shortAddress,
      'fullAddress': fullAddress,
      'latitude': latitude,
      'longitude': longitude,
      'minyak': minyak,
      'poin': poin,
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      orderMade: (map['orderMade'] as Timestamp).toDate(),
      orderId: map['orderId'],
      uid: map['uid'],
      isFinished: map['isFinished'],
      shortAddress: map['shortAddress'],
      fullAddress: map['fullAddress'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      minyak: map['minyak'],
      poin: map['poin'],
    );
  }

  OrderModel copyWith({
    DateTime? orderMade,
    String? orderId,
    String? uid,
    bool? isFinished,
    String? shortAddress,
    String? fullAddress,
    double? latitude,
    double? longitude,
    double? minyak,
    int? poin,
  }) =>
      OrderModel(
        orderMade: orderMade ?? this.orderMade,
        orderId: orderId ?? this.orderId,
        uid: uid ?? this.orderId,
        isFinished: isFinished ?? this.isFinished,
        shortAddress: shortAddress ?? this.shortAddress,
        fullAddress: fullAddress ?? this.fullAddress,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        minyak: minyak ?? this.minyak,
        poin: poin ?? this.poin,
      );
}
