part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class UserPostData extends UserEvent {
  final UserModel user;
  const UserPostData(this.user);

  @override
  List<Object> get props => [user];
}

class UserPostOrder extends UserEvent {
  final OrderModel order;
  const UserPostOrder(this.order);

  @override
  List<Object> get props => [order];
}

class UserCheckPendingOrder extends UserEvent {
  final String uid;
  const UserCheckPendingOrder(this.uid);

  @override
  List<Object> get props => [uid];
}

class UserScanBarcode extends UserEvent {}
