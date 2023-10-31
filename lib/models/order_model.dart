import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:mj/models/kurir_model.dart';

class OrderModel {
  final DateTime? orderMade;
  final String? orderId;
  final String? uid;
  final bool? isFinished;
  final String? shortAddress;
  final String? fullAddress;
  final double? userLatitude;
  final double? userLongitude;
  final double? warehouseLatitude;
  final double? warehouseLongitude;
  final double? minyak;
  final int? poin;
  // final KurirModel? kurir;

  OrderModel({
    this.orderMade,
    this.orderId,
    this.uid,
    this.isFinished,
    this.shortAddress,
    this.fullAddress,
    this.userLatitude,
    this.userLongitude,
    this.warehouseLatitude,
    this.warehouseLongitude,
    this.minyak,
    this.poin,
    // this.kurir,
  });

  Map<String, dynamic> toMap() {
    return {
      'orderMade': orderMade,
      'orderId': orderId,
      'uid': uid,
      'isFinished': isFinished,
      'shortAddress': shortAddress,
      'fullAddress': fullAddress,
      'userLatitude': userLatitude,
      'userLongitude': userLongitude,
      'warehouseLatitude': warehouseLatitude,
      'warehouseLongitude': warehouseLongitude,
      'minyak': minyak,
      'poin': poin,
      // 'kurir': kurir,
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
      userLatitude: map['userLatitude'],
      userLongitude: map['userLongitude'],
      warehouseLatitude: map['warehouseLatitude'],
      warehouseLongitude: map['warehouseLongitude'],
      minyak: map['minyak'],
      poin: map['poin'],
      // kurir: map['kurir'] == null ? null : KurirModel.fromMap(map['kurir']),
    );
  }

  OrderModel copyWith({
    DateTime? orderMade,
    String? orderId,
    String? uid,
    bool? isFinished,
    String? shortAddress,
    String? fullAddress,
    double? userLatitude,
    double? userLongitude,
    double? warehouseLatitude,
    double? warehouseLongitude,
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
        userLatitude: userLatitude ?? this.userLatitude,
        userLongitude: userLongitude ?? this.userLongitude,
        warehouseLatitude: warehouseLatitude ?? this.warehouseLatitude,
        warehouseLongitude: warehouseLongitude ?? this.userLongitude,
        minyak: minyak ?? this.minyak,
        poin: poin ?? this.poin,
      );
}
