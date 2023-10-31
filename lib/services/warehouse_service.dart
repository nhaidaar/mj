import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/warehouse_model.dart';

class WarehouseService {
  Stream<List<WarehouseModel>> getWarehouse() {
    return FirebaseFirestore.instance
        .collection('warehouses')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((document) {
        return WarehouseModel.fromMap(document.data());
      }).toList();
    });
  }

  Future<void> addWarehouse(WarehouseModel warehouse) async {
    final CollectionReference userOrders =
        FirebaseFirestore.instance.collection('warehouses');

    try {
      await userOrders.doc(warehouse.id).set(warehouse.toMap());
    } catch (e) {
      rethrow;
    }
  }
}
