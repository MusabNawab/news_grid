import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:news_grid/core/logic/connectivity_cubit/connectivity_cubit.dart';
import 'package:news_grid/core/domain/network_info.dart';

class ConnectivityNetworkInfo implements NetworkInfo {
  final ConnectivityCubit connectivityCubit;

  ConnectivityNetworkInfo(this.connectivityCubit);

  @override
  Future<bool> get isConnected async {
    final bool connected = connectivityCubit.state == InternetStatus.connected;
    return connected;
  }
}
