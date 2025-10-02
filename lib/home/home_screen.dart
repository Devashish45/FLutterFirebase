import 'package:flutter/material.dart';
import 'package:flutterfirebase/Auth/AuthRepository.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Expanded(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                AuthRepo.logoutApp(context);
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
