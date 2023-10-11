import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/order_model.dart';
import '../models/withdraw_model.dart';

class HistoryService {
  Stream<List<OrderModel>> streamPenyetoran(String uid) {
    return FirebaseFirestore.instance
        .collection('orders')
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map((QuerySnapshot querySnapshot) {
      return querySnapshot.docs.map((order) {
        return OrderModel.fromMap(order.data() as Map<String, dynamic>);
      }).toList();
    });
  }

  Stream<List<WithdrawModel>> streamPenarikan(String uid) {
    return FirebaseFirestore.instance
        .collection('withdraw')
        .where('uid', isEqualTo: uid)
        .snapshots()
        .map((QuerySnapshot querySnapshot) {
      return querySnapshot.docs.map((withdraw) {
        return WithdrawModel.fromMap(withdraw.data() as Map<String, dynamic>);
      }).toList();
    });
  }
}
