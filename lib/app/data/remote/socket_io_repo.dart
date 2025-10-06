import 'dart:async';
import 'dart:developer';
import 'package:fvf_flutter/app/data/config/logger.dart';
import 'package:socket_io_client/socket_io_client.dart' as _io;

/// Socket.IO Repository
class SocketIoRepo {
  /// Singleton pattern
  factory SocketIoRepo() => _instance;

  SocketIoRepo._internal();

  static final SocketIoRepo _instance = SocketIoRepo._internal();

  _io.Socket? _socket;

  /// Timer for auto emit
  Timer? _emitTimer;

  /// Your updated data list
  final List<String> receivedData = <String>[];

  /// Initialize and connect to the Socket.IO server
  void initSocket({required String url}) {
    try {
      logI('🔌 Initializing socket connection to $url');

      _socket = _io.io(
        url,
        _io.OptionBuilder()
            .setTransports(<String>['websocket'])
            .enableReconnection()
            .setReconnectionAttempts(1000)
            .setReconnectionDelay(1000)
            .setReconnectionDelayMax(2000)
            .enableAutoConnect()
            .build(),
      );

      _socket
        ?..connect()
        ..onConnect((_) {
          logI('✅ Connected to socket server: $url');
        })
        ..onConnectError((dynamic err) {
          logWTF('❌ Socket connect error: $err');
        })
        ..onError((dynamic err) {
          logWTF('🔥 Socket general error: $err');
        })
        ..onDisconnect((dynamic reason) {
          logWTF('❌ Disconnected from socket: $reason');
        });
    } on Exception catch (e, st) {
      logWTF('💥 Error initializing socket: $e\n$st');
      _socket = null;
    }
  }

  /// Start auto-emitting every 5 seconds
  void startAutoEmit(Map<String, dynamic> payload) {
    stopAutoEmit();
    logI('⏱️ Starting auto emit every 5 seconds with payload: $payload');

    _emitTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      emitGetDate(payload);
    });
  }

  /// Stop auto-emitting
  void stopAutoEmit() {
    if (_emitTimer != null) {
      logI('🛑 Stopped auto emit');
      _emitTimer?.cancel();
      _emitTimer = null;
    }
  }

  /// Emit function (manual emit if needed)
  void emitGetDate(Map<String, dynamic> payload) {
    if (_socket?.connected ?? false) {
      if (_socket != null) {
        _socket?.emit('getRound', payload);
      }

      logI('📤 Emitted event [getRound] with payload: $payload');
    }
  }

  /// Listen function (subscribe to "roundUpdate")
  void listenForDateEvent(void Function(dynamic data) onData) {
    logI('👂 Subscribing to [roundUpdate] event');
    if (_socket != null) {
      _socket?.on(
        'roundUpdate',
        (dynamic data) {
          logI('📥 Received [roundUpdate]: $data');
          receivedData.add(data.toString());
          onData(data);
        },
      );
    }
  }

  /// Listen function (subscribe to "roundProcess")
  void listenForRoundProcess(void Function(dynamic data) onData) {
    logI('👂 Subscribing to [roundProcess] event');
    if (_socket != null) {
      _socket?.on(
        'roundProcess',
        (dynamic data) {
          log('📥 Received [roundProcess]: $data');
          onData(data);
        },
      );
    }
  }

  /// Disconnect socket safely
  void disconnect() {
    if (_socket != null) {
      if (_socket!.connected) {
        logI('🔌 Disconnecting from socket server...');
        _socket!.disconnect();
      }

      logI('🛑 Cleaning up socket + listeners');
      _socket
        ?..off('roundUpdate')
        ..off('roundProcess')
        ..dispose();

      _socket = null;
    } else {
      logI('⚠️ No active socket to disconnect');
    }
  }
}
