# MeshCore Open

Open-source Flutter client for MeshCore LoRa mesh networking devices.

## Overview

MeshCore Open is a cross-platform mobile application for communicating with MeshCore LoRa mesh network devices via Bluetooth Low Energy (BLE). The app enables long-range, off-grid communication through peer-to-peer messaging, public channels, and mesh networking capabilities.

<a href="http://apps.obtainium.imranr.dev/redirect.html?r=obtainium://add/https://github.com/zjs81/meshcore-open">
        <img src="assets/badges/badge_obtainium.png" height="80" align="center" alt="Get it on Obtainium"/>
</a>

## Screenshots

<table>
  <tr>
    <td><img src="docs/screenshots/contacts.jpg" width="200"/><br/><p align="center"><b>Contacts</b></p></td>
    <td><img src="docs/screenshots/chat1.jpg" width="200"/><br/><p align="center"><b>Chat</b></p></td>
    <td><img src="docs/screenshots/chat2.jpg" width="200"/><br/><p align="center"><b>Reactions</b></p></td>
    <td><img src="docs/screenshots/map.jpg" width="200"/><br/><p align="center"><b>Map</b></p></td>
    <td><img src="docs/screenshots/channels.jpg" width="200"/><br/><p align="center"><b>Channels</b></p></td>
  </tr>
</table>

## Features

### Core Functionality

- **Direct Messaging**: Private encrypted conversations with individual contacts
- **Public Channels**: Broadcast messages to channel subscribers on the mesh network
- **Contact Management**: Organize contacts, track last seen times, and manage conversation history
- **Contact Groups**: Create custom groups to organize your mesh network contacts
- **Message Reactions**: React to messages with emoji responses
- **Message Replies**: Thread conversations with inline reply functionality

### Mesh Network

- **Path Visualization**: View routing paths and signal quality for each contact
- **Route Management**: Manual path overriding and automatic route rotation
- **Signal Metrics**: Real-time SNR (Signal-to-Noise Ratio) tracking
- **Node Discovery**: Automatic detection of nearby mesh nodes
- **Repeater Support**: Connect to and manage repeater nodes for extended range

### Map & Location

- **Live Map View**: Real-time visualization of mesh network nodes on an interactive map
- **Node Filtering**: Filter by node type (chat, repeater, sensor) and time range
- **Location Sharing**: Share GPS coordinates and custom markers with contacts
- **Offline Maps**: Download map tiles for offline use in remote areas
- **MGRS Coordinates**: Support for Military Grid Reference System coordinate format

### Device Management

- **BLE Connection**: Scan and connect to MeshCore devices via Bluetooth
- **Device Settings**: Configure radio parameters, power settings, and network options
- **Battery Monitoring**: Real-time battery status with chemistry-specific voltage curves
- **Firmware Updates**: Over-the-air firmware updates via BLE (coming soon)

### Repeater Hub

- **CLI Access**: Full command-line interface to repeater nodes
- **Settings Management**: Configure repeater behavior, power limits, and network settings
- **Statistics Dashboard**: View repeater traffic, connected clients, and system health
- **Remote Management**: Administer repeaters from anywhere on the mesh network

## Technical Details

### Architecture

- **Framework**: Flutter 3.38.5 / Dart 3.10.4
- **State Management**: Provider pattern with ChangeNotifier
- **BLE Protocol**: Nordic UART Service (NUS) over Bluetooth Low Energy
- **Storage**: Local SQLite database for messages and contact data
- **Encryption**: End-to-end encryption for private messages using the MeshCore protocol

### Platform Support

- ✅ **Android**: Full support (API 21+)
- ✅ **iOS**: Full support (iOS 12+)
- 🚧 **Desktop**: Limited support (macOS/Linux/Windows)

### Dependencies

| Package | Purpose |
|---------|---------|
| flutter_blue_plus | Bluetooth Low Energy communication |
| provider | State management |
| sqflite | Local database storage |
| flutter_map | Interactive map display |
| latlong2 | Geographic coordinate handling |
| flutter_local_notifications | Background notification support |
| smaz | Message compression |
| pointycastle | Cryptographic operations |
| intl | Internationalization and date formatting |

## Getting Started

### Prerequisites

- Flutter SDK 3.38.5 or later
- Android Studio / Xcode (for mobile development)
- A MeshCore-compatible LoRa device

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/zjs81/meshcore-open.git
   cd meshcore-open
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Run the app**

   ```bash
   flutter run
   ```

### Building for Release

**Android APK:**

```bash
flutter build apk --release
```

**iOS:**

```bash
flutter build ios --release
```

## Project Structure

```
lib/
├── main.dart                    # App entry point
├── connector/
│   ├── meshcore_connector.dart  # BLE communication & state management
│   └── meshcore_protocol.dart   # Protocol definitions & frame parsing
├── screens/
│   ├── scanner_screen.dart      # Device scanning (home screen)
│   ├── contacts_screen.dart     # Contact list
│   ├── chat_screen.dart         # Direct messaging
│   ├── channels_screen.dart     # Public channels
│   ├── map_screen.dart          # Network visualization map
│   ├── settings_screen.dart     # Device settings
│   └── repeater_hub_screen.dart # Repeater management
├── models/
│   ├── contact.dart             # Contact data model
│   ├── message.dart             # Message data structure
│   └── channel.dart             # Channel definitions
├── services/
│   ├── notification_service.dart      # Push notifications
│   ├── message_retry_service.dart     # Automatic message retry
│   ├── background_service.dart        # Background BLE connection
│   └── map_tile_cache_service.dart    # Offline map storage
└── storage/
    ├── message_store.dart       # Message persistence
    ├── contact_store.dart       # Contact database
    └── unread_store.dart        # Unread message tracking
```

## BLE Protocol

### Nordic UART Service (NUS)

- **Service UUID**: `6e400001-b5a3-f393-e0a9-e50e24dcca9e`
- **RX Characteristic**: `6e400002-b5a3-f393-e0a9-e50e24dcca9e` (Write to device)
- **TX Characteristic**: `6e400003-b5a3-f393-e0a9-e50e24dcca9e` (Notify from device)

### Device Discovery

Devices are discovered by scanning for BLE advertisements with the name prefix `MeshCore-`

### Message Format

Messages are transmitted as binary frames using a custom protocol optimized for LoRa transmission. See `meshcore_protocol.dart` for frame structure definitions.

## Configuration

### App Settings

- **Theme**: System default, light, or dark mode
- **Notifications**: Configurable for messages, channels, and node advertisements
- **Battery Chemistry**: Support for NMC, LiFePO4, and LiPo battery types
- **Message Retry**: Automatic retry with configurable path clearing

### Device Settings

- **Radio Power**: Transmit power adjustment (10-30 dBm)
- **Frequency**: LoRa frequency configuration
- **Bandwidth**: Channel bandwidth selection
- **Spreading Factor**: Range vs. speed trade-off
- **Network ID**: Mesh network identifier

## Contributing

This is an open-source project. Contributions are welcome!

### Development Guidelines

- Follow the Flutter style guide
- Use Material 3 design components
- Write clear commit messages
- Test on both Android and iOS before submitting PRs

### Code Style

- Prefer `StatelessWidget` with `Consumer` for reactive UI
- Use `const` constructors where possible
- Keep functions small and focused
- Avoid premature abstractions

## Support

For issues, questions, or feature requests, please open an issue on GitHub:
<https://github.com/zjs81/meshcore-open/issues>

## Donate

If you find MeshCore Open useful and would like to support development, you can donate Solana or other Solana tokens:

**Solana Address:** `F15YanjZj96YTBtKJYgNa8RLQLCZkx5CEwogPWkqXeoQ`

Your support helps maintain and improve this open-source project!

## Acknowledgments

- Built with [Flutter](https://flutter.dev/)
- Map tiles from [OpenStreetMap](https://www.openstreetmap.org/)
