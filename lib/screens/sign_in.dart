import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:login_page/helper/show_snack_bar.dart';
import 'package:login_page/screens/sign_in.dart';
import 'package:login_page/widgets/custom_button.dart';
import 'package:login_page/widgets/custom_text_field.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool? obscurePassword = true;
  IconData? iconpassword = CupertinoIcons.eye_fill;
  String? email, password;
  bool isLoading = false;
  GlobalKey<FormState> formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Form(
        key: formKey,
        child: Column(
          children: [
            const SizedBox(
              height: 5,
            ),
            CustomFormTextField(
              onChanged: (data) {
                email = data;
              },
              hintText: 'Email',
              icon: const Icon(
                CupertinoIcons.mail_solid,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            TextFormField(
              obscureText: obscurePassword!,
              validator: (data) {
                if (data!.isEmpty) {
                  return 'field is required';
                }
                return null;
              },
              onChanged: (data) {
                password = data;
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: Color(0xffEBEBEBFF),
                hintText: 'Password',
                prefixIcon: const Icon(
                  CupertinoIcons.lock_fill,
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      obscurePassword = !obscurePassword!;
                      if (obscurePassword!) {
                        iconpassword = CupertinoIcons.eye_fill;
                      } else {
                        iconpassword = CupertinoIcons.eye_slash_fill;
                      }
                    });
                  },
                  icon: Icon(iconpassword),
                ),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                border: const OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            CustomButton(
                onTap: () async {
                  if (formKey.currentState!.validate()) {
                    isLoading = true;
                    setState(() {});
                    try {
                      await loginUser();
                      showSnackBar(context, 'success');
                    } on FirebaseAuthException catch (ex) {
                      if (ex.code == 'user-not-found') {
                        showSnackBar(context, 'user not found');
                      } else if (ex.code == 'wrong-password') {
                        showSnackBar(context, 'wrong password');
                      }
                    } catch (ex) {
                      showSnackBar(context, 'there was an error');
                    }
                    isLoading = false;
                    setState(() {});
                  }
                },
                text: 'Sign In'),
          ],
        ),
      ),
    );
  }

  Future<void> loginUser() async {
    UserCredential user = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email!, password: password!);
  }
}
