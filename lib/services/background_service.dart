import 'dart:isolate';
import 'dart:io';

import 'package:flutter_foreground_task/flutter_foreground_task.dart';

class BackgroundService {
  bool _initialized = false;

  Future<void> initialize() async {
    if (!Platform.isAndroid || _initialized) return;
    FlutterForegroundTask.init(
      androidNotificationOptions: AndroidNotificationOptions(
        channelId: 'meshcore_background',
        channelName: 'MeshCore Background',
        channelDescription: 'Keeps MeshCore running in the background.',
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
        iconData: const NotificationIconData(
          resType: ResourceType.mipmap,
          resPrefix: ResourcePrefix.ic,
          name: 'launcher',
        ),
      ),
      iosNotificationOptions: const IOSNotificationOptions(
        showNotification: false,
        playSound: false,
      ),
      foregroundTaskOptions: const ForegroundTaskOptions(
        interval: 5000,
        autoRunOnBoot: false,
        allowWifiLock: false,
      ),
    );
    _initialized = true;
  }

  Future<void> start() async {
    if (!Platform.isAndroid) return;
    if (!_initialized) {
      await initialize();
    }
    final running = await FlutterForegroundTask.isRunningService;
    if (running) return;
    await FlutterForegroundTask.startService(
      notificationTitle: 'MeshCore running',
      notificationText: 'Keeping BLE connected',
      callback: startCallback,
    );
  }

  Future<void> stop() async {
    if (!Platform.isAndroid) return;
    final running = await FlutterForegroundTask.isRunningService;
    if (!running) return;
    await FlutterForegroundTask.stopService();
  }
}

@pragma('vm:entry-point')
void startCallback() {
  FlutterForegroundTask.setTaskHandler(_MeshCoreTaskHandler());
}

class _MeshCoreTaskHandler extends TaskHandler {
  @override
  void onStart(DateTime timestamp, SendPort? sendPort) {}

  @override
  void onRepeatEvent(DateTime timestamp, SendPort? sendPort) {}

  @override
  void onDestroy(DateTime timestamp, SendPort? sendPort) {}

  @override
  void onNotificationButtonPressed(String id) {}

  @override
  void onNotificationPressed() {
    FlutterForegroundTask.launchApp('/');
  }
}
