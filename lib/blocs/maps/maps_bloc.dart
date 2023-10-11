import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

import '../../services/maps_service.dart';

part 'maps_event.dart';
part 'maps_state.dart';

class MapsBloc extends Bloc<MapsEvent, MapsState> {
  MapsBloc() : super(MapsInitial()) {
    on<MapsEvent>((event, emit) async {
      if (event is GetCurrentLocation) {
        emit(MapsLoading());
        try {
          final data = await MapsService().getUserCurrentPosition();
          emit(MapsLoaded(data));
        } catch (e) {
          emit(MapsError(e.toString()));
        }
      }
    });
  }
}
