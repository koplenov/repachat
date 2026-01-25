import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:meshcore_open/widgets/snr_indicator.dart';

class PathTraceDialog extends StatefulWidget {

  const PathTraceDialog({
    super.key,
    required this.pathData,
    required this.snrData,
  });

  final Uint8List pathData;
  final Uint8List snrData;

  @override
  State<PathTraceDialog> createState() => _PathTraceDialogState();
}

class _PathTraceDialogState extends State<PathTraceDialog> {

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Path Trace'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          itemCount: widget.snrData.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: index >= widget.snrData.length / 2 ? Icon(Icons.arrow_circle_left) : Icon(Icons.arrow_circle_right),
              title: index == 0 || index == widget.snrData.length - 1 ? ( index == 0 ? Text('You to 0x${widget.pathData[0].toRadixString(16).toUpperCase()}') : Text('0x${widget.pathData[widget.pathData.length - 1].toRadixString(16).toUpperCase()} to You')) : Text('0x${widget.pathData[index-1].toRadixString(16).toUpperCase()} to 0x${widget.pathData[index].toRadixString(16).toUpperCase()}'),
              trailing: SNRIcon(snr: widget.snrData[index] / 4.0),
              onTap: () {
                // Handle item tap
              },

            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
