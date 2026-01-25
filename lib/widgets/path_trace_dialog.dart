import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../connector/meshcore_connector.dart';
import '../connector/meshcore_protocol.dart';
import '../models/contact.dart';
import '../widgets/snr_indicator.dart';
import '../l10n/l10n.dart';
class PathTraceDialog extends StatefulWidget {

  const PathTraceDialog({
    super.key,
    required this.title,
    required this.path,
  });

  final String title;
  final Uint8List path;

  @override
  State<PathTraceDialog> createState() => _PathTraceDialogState();
}

class _PathTraceDialogState extends State<PathTraceDialog> {
  StreamSubscription<Uint8List>? _frameSubscription;
  Timer? _timeoutTimer;

  bool _isLoading = false;
  bool _failed2Loaded = false;
  bool _hasData = false;
  Uint8List _pathData = Uint8List(0);
  Uint8List _snrData = Uint8List(0) ;
  Map<int, Contact> _pathContacts = {};

  @override
  void initState() {
    super.initState();
    _setupFrameListener();
    _doPathTrace();
  }

  @override
  void dispose() {
    _frameSubscription?.cancel();
    _timeoutTimer?.cancel();
    super.dispose();
  }

  Future<void> _doPathTrace() async {
    if(mounted) { 
      setState(() {
        _isLoading = true;
        _failed2Loaded = false;
      });
    }
    
    final connector = Provider.of<MeshCoreConnector>(context, listen: false);
    final frame = buildTraceReq(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      0, //flags
      0, //auth
      payload: widget.path,
    );
    connector.sendFrame(frame);
  }

  void _setupFrameListener() {
    final connector = Provider.of<MeshCoreConnector>(context, listen: false);
    Uint8List tagData = Uint8List(4);
    // Listen for incoming text messages from the repeater
    _frameSubscription = connector.receivedFrames.listen((frame) {
      if (frame.isEmpty) return;
      final frameBuffer = BufferReader(frame);
      final code = frameBuffer.readUInt8();

      if (code == respCodeSent) {
        frameBuffer.skipBytes(1); //reserved
        tagData = frameBuffer.readBytes(4);
        final timeoutSeconds = frameBuffer.readUInt32LE();

        // Start timeout timer for trace response
        _timeoutTimer?.cancel();
        _timeoutTimer = Timer(Duration(milliseconds: timeoutSeconds), () {
          if (!mounted) return;
          setState(() {
            _isLoading = false;
            _failed2Loaded = true;
          });
        });
      }

      // Check if it's a binary response
      if (code == pushCodeTraceData && listEquals(frame.sublist(4, 8), tagData)) {
        _timeoutTimer?.cancel();
        if (!mounted) return;
        frameBuffer.skipBytes(3); //reserved + path length + flag
        if(listEquals(frameBuffer.readBytes(4), tagData)){
          _handleTraceResponse(frame);
        }
      }
    });
  }

  Future<void> _handleTraceResponse(Uint8List frame)async {
    final connector = Provider.of<MeshCoreConnector>(context, listen: false);

    final buffer = BufferReader(frame);
    buffer.skipBytes(2); // Skip push code and reserved byte
    int pathLength = buffer.readUInt8();
    buffer.skipBytes(5); // Skip Flag byte and tag data
    buffer.skipBytes(4); // Skip auth code
    Uint8List pathData = buffer.readBytes(pathLength);
    Uint8List snrData = buffer.readRemainingBytes();

    Map<int, Contact> pathContacts = {};

    connector.contacts.where((c) => c.type != advTypeChat).forEach((
      repeater,
    ) {
      for (var neighbourData in pathData) {
        if (listEquals(
          repeater.publicKey.sublist(0, 1),
          Uint8List.fromList([neighbourData]),
        )) {
          pathContacts[neighbourData] = repeater;
        }
      }
    });

    setState(() {
      _isLoading = false;
      _hasData = true;
      _pathData = pathData;
      _snrData = snrData;
      _pathContacts = pathContacts;
    });
  }

  String formatDirectionText(int index) {
    if (index == 0 || index == _snrData.length - 1) {
      if (index == 0) {
        return context.l10n.pathTrace_you;
      } else {
        return _pathContacts[_pathData[_pathData.length - 1]]?.name ?? "0x${_pathData[_pathData.length - 1].toRadixString(16).toUpperCase()}";
      }
    } else {
      return _pathContacts[_pathData[index-1]]?.name ?? "0x${_pathData[index-1].toRadixString(16).toUpperCase()}";
    }
  }
  String formatDirectionSubText(int index) {
    if (index == 0 || index == _snrData.length - 1) {
      if (index == 0) {
        return _pathContacts[_pathData[0]]?.name ?? "0x${_pathData[0].toRadixString(16).toUpperCase()}";
      } else {
        return context.l10n.pathTrace_you;
      }
    } else {
      return _pathContacts[_pathData[index]]?.name ?? "0x${_pathData[index].toRadixString(16).toUpperCase()}";
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return AlertDialog(
      title: Column( children: [
          FittedBox(fit: BoxFit.scaleDown, child: Text(widget.title, style: const TextStyle(fontSize: 24))),
          if(_failed2Loaded)
            Text(l10n.pathTrace_failed, style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.error),),
        ],
      ),
      content: SafeArea(
        child: RefreshIndicator(
          onRefresh: _doPathTrace,
          child: !_hasData
                ? Center(
                    child: Text(l10n.pathTrace_notAvailable),
                  )
                : ListView.builder(
                    itemCount: _snrData.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          ListTile(
                            leading: index >= _snrData.length / 2 ? Icon(Icons.call_received) : Icon(Icons.call_made),
                            title: Text(
                              formatDirectionText(index), style: const TextStyle(fontSize: 14),
                            ),
                            subtitle: Text(
                              formatDirectionSubText(index),
                              style: const TextStyle(fontSize: 14),
                            ),
                            trailing: SNRIcon(snr: _snrData[index].toSigned(8) / 4.0),
                            onTap: () {
                              // Handle item tap
                            },
                          ),
                          if (index < _snrData.length - 1) const Divider(height: 0.0),
                        ],
                      );
                    },
                  ),
        ),
      ),
      actions: [
         IconButton(
          icon: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.refresh),
          onPressed: _isLoading ? null : _doPathTrace,
          tooltip: l10n.pathTrace_refreshTooltip,
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.common_close),
        ),
      ],
    );
  }
}
