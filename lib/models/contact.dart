import 'dart:typed_data';
import '../connector/meshcore_protocol.dart';

class Contact {
  final Uint8List publicKey;
  final String name;
  final int type;
  final int pathLength; // -1 = flood, 0+ = direct hops (from device)
  final Uint8List path; // Path bytes from device
  final int? pathOverride; // User's path override: -1 = force flood, null = auto
  final Uint8List? pathOverrideBytes; // User's path override bytes
  final double? latitude;
  final double? longitude;
  final DateTime lastSeen;
  final DateTime lastMessageAt;

  Contact({
    required this.publicKey,
    required this.name,
    required this.type,
    required this.pathLength,
    required this.path,
    this.pathOverride,
    this.pathOverrideBytes,
    this.latitude,
    this.longitude,
    required this.lastSeen,
    DateTime? lastMessageAt,
  }) : lastMessageAt = lastMessageAt ?? lastSeen;

  String get publicKeyHex => pubKeyToHex(publicKey);

  String get typeLabel {
    switch (type) {
      case advTypeChat:
        return 'Chat';
      case advTypeRepeater:
        return 'Repeater';
      case advTypeRoom:
        return 'Room';
      case advTypeSensor:
        return 'Sensor';
      default:
        return 'Unknown';
    }
  }

  String get pathLabel {
    if (pathLength < 0) return 'Flood';
    if (pathLength == 0) return 'Direct';
    return '$pathLength hops';
  }

  bool get hasLocation => latitude != null && longitude != null;

  Contact copyWith({
    Uint8List? publicKey,
    String? name,
    int? type,
    int? pathLength,
    Uint8List? path,
    int? pathOverride,
    Uint8List? pathOverrideBytes,
    bool clearPathOverride = false,
    double? latitude,
    double? longitude,
    DateTime? lastSeen,
    DateTime? lastMessageAt,
  }) {
    return Contact(
      publicKey: publicKey ?? this.publicKey,
      name: name ?? this.name,
      type: type ?? this.type,
      pathLength: pathLength ?? this.pathLength,
      path: path ?? this.path,
      pathOverride: clearPathOverride ? null : (pathOverride ?? this.pathOverride),
      pathOverrideBytes: clearPathOverride ? null : (pathOverrideBytes ?? this.pathOverrideBytes),
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      lastSeen: lastSeen ?? this.lastSeen,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
    );
  }

  String get pathIdList {
    if (path.isEmpty) return '';
    final parts = <String>[];
    final groupSize = pathHashSize;
    for (int i = 0; i < path.length; i += groupSize) {
      final end = (i + groupSize) <= path.length ? (i + groupSize) : path.length;
      final chunk = path.sublist(i, end);
      parts.add(
        chunk.map((b) => b.toRadixString(16).padLeft(2, '0').toUpperCase()).join(),
      );
    }
    return parts.join(',');
  }

  static Contact? fromFrame(Uint8List data) {
    if (data.length < contactFrameSize) return null;
    if (data[0] != respCodeContact) return null;

    final pubKey = Uint8List.fromList(
      data.sublist(contactPubKeyOffset, contactPubKeyOffset + pubKeySize),
    );
    final type = data[contactTypeOffset];
    final pathLen = data[contactPathLenOffset].toSigned(8);
    final safePathLen = pathLen > 0
        ? (pathLen > maxPathSize ? maxPathSize : pathLen)
        : 0;
    final pathBytes = safePathLen > 0
        ? Uint8List.fromList(
            data.sublist(contactPathOffset, contactPathOffset + safePathLen),
          )
        : Uint8List(0);
    final name = readCString(data, contactNameOffset, maxNameSize);
    final lastmod = readUint32LE(data, contactLastmodOffset);

    double? lat, lon;
    final latRaw = readInt32LE(data, contactLatOffset);
    final lonRaw = readInt32LE(data, contactLonOffset);
    if (latRaw != 0 || lonRaw != 0) {
      lat = latRaw / 1e6;
      lon = lonRaw / 1e6;
    }

    return Contact(
      publicKey: pubKey,
      name: name.isEmpty ? 'Unknown' : name,
      type: type,
      pathLength: pathLen,
      path: pathBytes,
      latitude: lat,
      longitude: lon,
      lastSeen: DateTime.fromMillisecondsSinceEpoch(lastmod * 1000),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is Contact && publicKeyHex == other.publicKeyHex;

  @override
  int get hashCode => publicKeyHex.hashCode;
}
