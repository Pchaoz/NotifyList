import 'package:flutter/material.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inbox')),
      body: const Center(child: Text('Bandeja de entrada — Sprint 2')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO Sprint 2: abrir sheet de crear tarea
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
