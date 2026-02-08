import 'package:flutter/foundation.dart';
import 'package:gpx/gpx.dart';
import 'package:meshcore_open/connector/meshcore_connector.dart';
import 'package:meshcore_open/connector/meshcore_protocol.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:share_plus/share_plus.dart';

class ContactExport {
  final String name;
  final double lat;
  final double lon;
  final String desc;
  final double? ele;

  ContactExport({
    required this.name,
    required this.lat,
    required this.lon,
    required this.desc,
    this.ele,
  });
}

const int gpxExportFailed = -1;
const int gpxExportSuccess = 1;
const int gpxExportNoContacts = 2;
const int gpxExportCancelled = 3;
const int gpxExportNotAvailable = 4;

class GpxExport {
  final MeshCoreConnector _connector;
  final List<ContactExport> _contacts = [];

  GpxExport(this._connector);

  void _addContact(
    String name,
    double lat,
    double lon,
    String desc, [
    double? ele,
  ]) {
    _contacts.add(
      ContactExport(
        name: name.trim(),
        lat: lat,
        lon: lon,
        desc: desc.trim(),
        ele: ele,
      ),
    );
  }

  void addRepeaters() {
    final contacts = _connector.contacts;
    final repeaters = contacts
        .where((c) => c.type == advTypeRepeater || c.type == advTypeRoom)
        .toList();
    for (var repeater in repeaters) {
      if (repeater.latitude == null || repeater.longitude == null) {
        continue;
      }
      _addContact(
        repeater.name,
        repeater.latitude ?? 0.0,
        repeater.longitude ?? 0.0,
        "Type: ${repeater.typeLabel}\nPublic Key: ${repeater.publicKeyHex}",
      );
    }
  }

  void addContacts() {
    final contacts = _connector.contacts;
    final repeaters = contacts.where((c) => c.type == advTypeChat).toList();
    for (var repeater in repeaters) {
      if (repeater.latitude == null || repeater.longitude == null) {
        continue;
      }
      _addContact(
        repeater.name,
        repeater.latitude ?? 0.0,
        repeater.longitude ?? 0.0,
        "Type: ${repeater.typeLabel}\nPublic Key: ${repeater.publicKeyHex}",
      );
    }
  }

  void addAll() {
    final contacts = _connector.contacts;
    for (var repeater in contacts.toList()) {
      if (repeater.latitude == null || repeater.longitude == null) {
        continue;
      }
      _addContact(
        repeater.name,
        repeater.latitude ?? 0.0,
        repeater.longitude ?? 0.0,
        "Type: ${repeater.typeLabel}\nPublic Key: ${repeater.publicKeyHex}",
      );
    }
  }

  Future<int> exportGPX(
    String name,
    String description,
    String filename,
    String shareText,
    String subject,
  ) async {
    if (_contacts.isEmpty) {
      debugPrint("No repeaters to export – nothing to share.");
      return gpxExportNoContacts;
    }

    try {
      // 1. Build GPX content (your existing logic – unchanged here)
      final gpx = Gpx()
        ..version = '1.1'
        ..creator = 'meshcore-open exporter'
        ..metadata = Metadata(
          name: name,
          desc: description,
          time: DateTime.now().toUtc(),
        );

      gpx.wpts = _contacts
          .map(
            (c) => Wpt(
              lat: c.lat,
              lon: c.lon,
              ele: c.ele,
              name: c.name,
              desc: c.desc,
            ),
          )
          .toList();

      final xml = GpxWriter().asString(gpx, pretty: true);

      // 2. Save to file
      final dir = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now()
          .toUtc()
          .toIso8601String()
          .replaceAll(':', '-')
          .replaceAll('.', '-')
          .split('T')
          .join('_');

      // ignore: unnecessary_string_escapes
      final path = '${dir.path}/$filename$timestamp.gpx';

      final file = File(path);
      await file.writeAsString(xml);

      // 3. Modern share call (2025+ style)
      final result = await SharePlus.instance.share(
        ShareParams(
          text: shareText,
          subject: subject,
          files: [XFile(path)],
          // Optional: sharePositionOrigin: ... (if you want iPad popover positioning)
        ),
      );

      // 4. Handle result
      switch (result.status) {
        case ShareResultStatus.success:
          debugPrint('Share successful – user completed the action.');
          return gpxExportSuccess;
        case ShareResultStatus.dismissed:
          debugPrint('Share sheet was dismissed / cancelled by user.');
          return gpxExportCancelled;
        case ShareResultStatus.unavailable:
          debugPrint('Sharing is not available on this platform / context.');
          return gpxExportNotAvailable;
      }

      // Optional cleanup (uncomment if you don't want to keep the file)
      // await file.delete();
    } catch (e, stack) {
      debugPrint('Export or share failed: $e\n$stack');
      // → here you could show a SnackBar / AlertDialog in real UI code
    }
    return gpxExportFailed;
  }
}
