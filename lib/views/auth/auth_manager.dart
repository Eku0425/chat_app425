import 'package:chat_app04/views/second_page/sign_in.dart';
import 'package:flutter/material.dart';

import '../../services/auth_sevierse.dart';
import '../home/home_page.dart';

class AuthManager extends StatelessWidget {
  const AuthManager({super.key});

  @override
  Widget build(BuildContext context) {
    return (AuthService.authService.getCurrentUser() == null)
        ? const SignIn()
        : const HomePage();
  }
}
