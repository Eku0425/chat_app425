import 'package:chat_app04/modal/cloud_modal.dart';
import 'package:chat_app04/services/auth_sevierse.dart';
import 'package:chat_app04/services/cloud_firestore_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/auth_controller.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(AuthController());
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign up'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: controller.txtName,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: controller.txtEmail,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: controller.txtPassword,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            TextField(
              controller: controller.txtConfirmpassword,
              decoration: const InputDecoration(labelText: 'Confirmpassword'),
            ),
            TextField(
              controller: controller.txtPhone,
              decoration: const InputDecoration(labelText: 'Phone'),
            ),
            const SizedBox(
              height: 20,
            ),
            TextButton(
                onPressed: () {
                  Get.toNamed('/');
                },
                child: Text("Alreday have  account ? Sign In")),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () async {
                  if (controller.txtPassword.text ==
                      controller.txtConfirmpassword.text) {
                    await AuthService.authService
                        .createAccountWithEmailAndPassword(
                            controller.txtEmail.text,
                            controller.txtPassword.text);

                    UserModal user = UserModal(
                        name: controller.txtName.text,
                        email: controller.txtEmail.text,
                        image:
                            "https://www.google.com/url?sa=i&url=https%3A%2F%2Funsplash.com%2Fs%2Fphotos%2Fprofile&psig=AOvVaw3ElO89JI1LshAdBahFURYE&ust=1728552572778000&source=images&cd=vfe&opi=89978449&ved=0CBEQjRxqFwoTCOib3qH-gIkDFQAAAAAdAAAAABAE",
                        phone: controller.txtPhone.text,
                        token: "--");

                    CloudFireStoreService.cloudFireStoreService
                        .insertUserIntoFireStore(user);
                    Get.back();
                    controller.txtName.clear();
                    controller.txtEmail.clear();
                    controller.txtPassword.clear();
                    controller.txtConfirmpassword.clear();
                    controller.txtPhone.clear();
                  }
                },
                child: const Text('Sign Up'))
          ],
        ),
      ),
    );
  }
} // name
//ph
//email
//password- confirm password
//image -default
