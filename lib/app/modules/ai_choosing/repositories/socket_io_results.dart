import 'package:fvf_flutter/app/data/config/logger.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

/// Socket.IO Results Repository
class SocketIoResultsRepo {
  /// Singleton
  factory SocketIoResultsRepo() => _instance;

  SocketIoResultsRepo._internal();

  static final SocketIoResultsRepo _instance = SocketIoResultsRepo._internal();

  late IO.Socket _socket;

  /// Initialize and connect to the Socket.IO server
  void initSocket({required String url}) {
    try {
      logI('🔌 Initializing Results socket connection to $url');

      _socket = IO.io(
        url,
        IO.OptionBuilder()
            .setTransports(<String>['websocket'])
            .enableReconnection()
            .setReconnectionAttempts(1000)
            .setReconnectionDelay(1000)
            .setReconnectionDelayMax(2000)
            .enableAutoConnect()
            .build(),
      );

      _socket
        ..connect()
        ..onConnect(
          (_) => logI('✅ Results socket connected: $url'),
        )
        ..onConnectError(
          (err) => logWTF('❌ Results socket connect error: $err'),
        )
        ..onError(
          (err) => logWTF('🔥 Results socket general error: $err'),
        )
        ..onDisconnect(
          (reason) => logWTF('❌ Results socket disconnected: $reason'),
        );
    } on Exception catch (e, st) {
      logWTF('💥 Error initializing Results socket: $e\n$st');
    }
  }

  /// Listen function (subscribe to "roundProcess")
  void listenForRoundProcess(void Function(dynamic data) onData) {
    logI('👂 Subscribing to [roundProcess] event');
    _socket.on('roundProcess', (dynamic data) {
      logI('📥 Received [roundProcess]: $data');
      onData(data);
    });
  }

  /// Dispose resources
  void dispose() {
    logI('🛑 Disposing Results socket + clearing listeners');
    _socket
      ..off('roundProcess')
      ..dispose();
  }
}
