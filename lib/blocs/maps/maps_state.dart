part of 'maps_bloc.dart';

abstract class MapsState extends Equatable {
  const MapsState();

  @override
  List<Object> get props => [];
}

class MapsInitial extends MapsState {}

class MapsLoading extends MapsState {}

class MapsLoaded extends MapsState {
  final Position position;
  const MapsLoaded(this.position);

  @override
  List<Object> get props => [position];
}

class MapsError extends MapsState {
  final String e;
  const MapsError(this.e);

  @override
  List<Object> get props => [e];
}
