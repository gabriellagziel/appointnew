import 'package:flutter/material.dart';

class PersonalHomeScreen extends StatelessWidget {
  const PersonalHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Personal Home')),
      body: const Center(child: Text('Home')),
    );
  }
}
