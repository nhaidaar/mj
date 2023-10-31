import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mj/models/order_model.dart';
import 'package:mj/services/user_service.dart';

import '../../models/user_model.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<UserEvent>((event, emit) async {
      if (event is UserPostData) {
        emit(UserLoading());
        try {
          await UserService().addUserToFirestore(event.user);
          emit(UserRegisterSuccess());
        } catch (e) {
          emit(UserRegisterFailed(e.toString()));
        }
      }
      if (event is UserPostOrder) {
        emit(UserLoading());
        try {
          await UserService().addOrder(event.order);
          emit(UserMakeOrderSuccess());
        } catch (e) {
          emit(UserMakeOrderFailed(e.toString()));
        }
      }
      if (event is UserCheckPendingOrder) {
        emit(UserLoading());
        try {
          final pendingOrder = await UserService().checkPendingOrder(event.uid);
          if (pendingOrder != null) {
            emit(UserPendingOrder(pendingOrder));
          } else {
            emit(NoPendingOrder());
          }
        } catch (e) {
          emit(UserCheckPendingOrderFailed(e.toString()));
        }
      }
      if (event is UserScanBarcode) {
        emit(UserLoading());
        await Future.delayed(const Duration(seconds: 3));
        emit(UserScanBarcodeSuccess());
      }
    });
  }
}
