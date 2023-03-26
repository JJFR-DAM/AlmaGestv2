import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:almagestv2/services/services.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userService = Provider.of<UserService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        leading: IconButton(
          icon: const Icon(Icons.login_outlined),
          onPressed: () {
            userService.logout();
            Navigator.pushReplacementNamed(context, 'login');
          },
        ),
      ),
    );
  }
}
