import 'package:mj/models/order_model.dart';

import '../models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/withdraw_model.dart';

class UserService {
  Future<void> addUserToFirestore(UserModel user) async {
    final CollectionReference userData =
        FirebaseFirestore.instance.collection('users');

    try {
      await userData.doc(user.uid).set(user.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addOrder(OrderModel order) async {
    final CollectionReference userOrders =
        FirebaseFirestore.instance.collection('orders');

    try {
      await userOrders.doc(order.orderId).set(order.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateOrderStatus(String orderId) async {
    try {
      CollectionReference ordersCollection =
          FirebaseFirestore.instance.collection('orders');

      QuerySnapshot querySnapshot =
          await ordersCollection.where('orderId', isEqualTo: orderId).get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentReference documentReference =
            ordersCollection.doc(querySnapshot.docs.first.id);
        await documentReference.update({'isFinished': true});
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUserContri(String uid, int poin, double minyak) async {
    try {
      final userRef = FirebaseFirestore.instance.collection('users').doc(uid);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot userSnapshot = await transaction.get(userRef);

        if (userSnapshot.exists) {
          num newTotalPoin = userSnapshot['totalPoin'] + poin;
          num newTotalMinyak = userSnapshot['totalMinyak'] + minyak;

          transaction.update(userRef, {
            'totalPoin': newTotalPoin,
            'totalMinyak': newTotalMinyak,
          });
        }
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<OrderModel?> checkPendingOrder(String uid) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('uid', isEqualTo: uid)
          .where('isFinished', isEqualTo: false)
          .limit(1) // Mengambil hanya satu dokumen pertama yang sesuai
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final orderData = querySnapshot.docs[0].data();
        return OrderModel.fromMap(orderData);
      } else {
        return null; // Tidak ada pesanan yang belum selesai ditemukan
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> requestWithdraw(WithdrawModel model) async {
    final CollectionReference withdraw =
        FirebaseFirestore.instance.collection('withdraws');

    try {
      await withdraw.doc(model.withdrawId).set(model.toMap());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUserBalance(String uid, int poin) async {
    try {
      final userRef = FirebaseFirestore.instance.collection('users').doc(uid);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot userSnapshot = await transaction.get(userRef);

        if (userSnapshot.exists) {
          num newTotalPoin = userSnapshot['totalPoin'] - poin;
          num newTotalPendapatan = userSnapshot['totalPendapatan'] + poin;

          transaction.update(userRef, {
            'totalPoin': newTotalPoin,
            'totalPendapatan': newTotalPendapatan,
          });
        }
      });
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateUserPicture(String uid, String link) async {
    try {
      final userRef = FirebaseFirestore.instance.collection('users').doc(uid);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot userSnapshot = await transaction.get(userRef);

        if (userSnapshot.exists) {
          transaction.update(userRef, {
            'profilePict': link,
          });
        }
      });
    } catch (e) {
      rethrow;
    }
  }
}
