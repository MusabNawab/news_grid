import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class ConnectivityCubit extends Cubit<InternetStatus?> {
  ConnectivityCubit() : super(null);

  StreamSubscription<InternetStatus>? connectionStream;

  Future<void> init() async {
    final connectionStatus = await InternetConnection().internetStatus;
    emit(connectionStatus);
  }

  void listen() {
    connectionStream = InternetConnection().onStatusChange.listen((
      InternetStatus status,
    ) {
      emit(status);
    });
  }

  @override
  Future<void> close() {
    connectionStream?.cancel();
    return super.close();
  }
}
