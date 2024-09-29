import 'package:chat_app04/services/auth_sevierse.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controller/auth_controller.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(AuthController());
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: controller.txtEmail,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          TextField(
            controller: controller.txtPassword,
            decoration: const InputDecoration(labelText: 'Password'),
          ),
          const SizedBox(
            height: 20,
          ),
          TextButton(
              onPressed: () {
                Get.toNamed('/signup');
              },
              child: const Text("don't have  account ? Sign up")),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
              onPressed: () async {
                await AuthService.authService.signInWithEmailAndPassword(
                    controller.txtEmail.text, controller.txtPassword.text);

                User? user = AuthService.authService.getCurrentUser();
                if (user != null) {
                  Get.offAndToNamed('/home');
                } else {
                  Get.snackbar(
                      'Sign in failed ', 'email  or password maybe wrong !  ');
                }
              },
              child: const Text('Sign in'))
        ],
      ),
    );
  }
}
