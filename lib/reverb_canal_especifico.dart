import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'reverb_service.dart';

class ReverbScreen extends StatefulWidget {
  @override
  _ReverbScreenState createState() => _ReverbScreenState();
}

class _ReverbScreenState extends State<ReverbScreen> {
  late ReverbService _reverbService;
  final TextEditingController _controller = TextEditingController();
  List<String> _messages = [];
  bool _isConnected = false;

  @override
  void initState() {
    super.initState();
    _reverbService = ReverbService('wss://echo.websocket.org/canal');  // URL del servidor de WebSocket y canal específico

    _reverbService.events.listen((event) {
      setState(() {
        _messages.add('Received: $event');
        _isConnected = true;
      });
    }, onError: (error) {
      print('Error: $error');
      setState(() {
        _messages.add('Error: $error');
        _isConnected = false;
      });
    });
  }

  @override
  void dispose() {
    _reverbService.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      final message = _controller.text;
      _reverbService.sendMessage(message);
      setState(() {
        _messages.add('Sent: $message');
      });
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reverb Events - Canal específico'),
      ),
      body: Column(
        children: [
          Expanded(
            child: RepaintBoundary(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_messages[index]),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(labelText: 'Send a message'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void main() => runApp(MaterialApp(
  home: ReverbScreen(),
));
