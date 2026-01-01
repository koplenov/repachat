import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import '../models/contact.dart';
import '../services/storage_service.dart';
import '../services/repeater_command_service.dart';
import '../connector/meshcore_connector.dart';
import '../connector/meshcore_protocol.dart';

class RepeaterLoginDialog extends StatefulWidget {
  final Contact repeater;
  final Function(String password) onLogin;

  const RepeaterLoginDialog({
    super.key,
    required this.repeater,
    required this.onLogin,
  });

  @override
  State<RepeaterLoginDialog> createState() => _RepeaterLoginDialogState();
}

class _RepeaterLoginDialogState extends State<RepeaterLoginDialog> {
  final TextEditingController _passwordController = TextEditingController();
  final StorageService _storage = StorageService();
  bool _savePassword = false;
  bool _isLoading = true;
  bool _obscurePassword = true;
  late MeshCoreConnector _connector;
  int _currentAttempt = 0;
  final int _maxAttempts = RepeaterCommandService.maxRetries;
  static const int _loginTimeoutSeconds = 10;

  @override
  void initState() {
    super.initState();
    _connector = Provider.of<MeshCoreConnector>(context, listen: false);
    _loadSavedPassword();
  }

  Future<void> _loadSavedPassword() async {
    final savedPassword =
        await _storage.getRepeaterPassword(widget.repeater.publicKeyHex);
    if (savedPassword != null) {
      setState(() {
        _passwordController.text = savedPassword;
        _savePassword = true;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  bool _isLoggingIn = false;

  Future<void> _handleLogin() async {
    if (_isLoggingIn) return;

    setState(() {
      _isLoggingIn = true;
      _currentAttempt = 0;
    });

    try {
      final password = _passwordController.text;
      bool? loginResult;
      for (int attempt = 0; attempt < _maxAttempts; attempt++) {
        if (!mounted) return;
        setState(() {
          _currentAttempt = attempt + 1;
        });

        await _connector.sendFrame(
          buildSendLoginFrame(widget.repeater.publicKey, password),
        );

        loginResult = await _awaitLoginResponse();
        if (loginResult == true) {
          break;
        }
        if (loginResult == false) {
          throw Exception('Wrong password or node is unreachable');
        }
      }

      if (loginResult != true) {
        throw Exception('Wrong password or node is unreachable');
      }

      // If we got a response, login succeeded
      // Save password if requested
      if (_savePassword) {
        await _storage.saveRepeaterPassword(
            widget.repeater.publicKeyHex, password);
      } else {
        // Remove saved password if user unchecked the box
        await _storage.removeRepeaterPassword(widget.repeater.publicKeyHex);
      }

      if (mounted) {
        Navigator.pop(context, password);
        Future.microtask(() => widget.onLogin(password));
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoggingIn = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<bool?> _awaitLoginResponse() async {
    final completer = Completer<bool?>();
    Timer? timer;
    StreamSubscription<Uint8List>? subscription;
    final targetPrefix = widget.repeater.publicKey.sublist(0, 6);

    subscription = _connector.receivedFrames.listen((frame) {
      if (frame.isEmpty) return;
      final code = frame[0];
      if (code != pushCodeLoginSuccess && code != pushCodeLoginFail) return;
      if (frame.length < 8) return;
      final prefix = frame.sublist(2, 8);
      if (!listEquals(prefix, targetPrefix)) return;

      completer.complete(code == pushCodeLoginSuccess);
      subscription?.cancel();
      timer?.cancel();
    });

    timer = Timer(const Duration(seconds: _loginTimeoutSeconds), () {
      if (!completer.isCompleted) {
        completer.complete(null);
        subscription?.cancel();
      }
    });

    final result = await completer.future;
    timer.cancel();
    await subscription.cancel();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.cell_tower, color: Colors.orange),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Repeater Login'),
                Text(
                  widget.repeater.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      content: _isLoading
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(20.0),
                child: CircularProgressIndicator(),
              ),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Enter the repeater password to access settings and status.',
                  style: TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter password',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  onSubmitted: (_) => _handleLogin(),
                  autofocus: _passwordController.text.isEmpty,
                ),
                const SizedBox(height: 12),
                CheckboxListTile(
                  value: _savePassword,
                  onChanged: (value) {
                    setState(() {
                      _savePassword = value ?? false;
                    });
                  },
                  title: const Text(
                    'Save password',
                    style: TextStyle(fontSize: 14),
                  ),
                  subtitle: const Text(
                    'Password will be stored securely on this device',
                    style: TextStyle(fontSize: 12),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                ),
              ],
            ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        if (_isLoggingIn)
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: null,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text('Retries $_currentAttempt/$_maxAttempts'),
                ],
              ),
            ),
          )
        else
          FilledButton.icon(
            onPressed: _isLoading ? null : _handleLogin,
            icon: const Icon(Icons.login, size: 18),
            label: const Text('Login'),
          ),
      ],
    );
  }
}
