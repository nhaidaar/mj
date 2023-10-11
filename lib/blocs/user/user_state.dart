part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}

class UserLoading extends UserState {}

class UserRegisterSuccess extends UserState {}

class UserRegisterFailed extends UserState {
  final String e;
  const UserRegisterFailed(this.e);

  @override
  List<Object> get props => [e];
}

class UserMakeOrderSuccess extends UserState {}

class UserMakeOrderFailed extends UserState {
  final String e;
  const UserMakeOrderFailed(this.e);

  @override
  List<Object> get props => [e];
}

class UserPendingOrder extends UserState {
  final OrderModel order;
  const UserPendingOrder(this.order);

  @override
  List<Object> get props => [order];
}

class NoPendingOrder extends UserState {}

class UserCheckPendingOrderFailed extends UserState {
  final String e;
  const UserCheckPendingOrderFailed(this.e);

  @override
  List<Object> get props => [e];
}
