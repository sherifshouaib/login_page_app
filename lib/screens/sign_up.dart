import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:login_page/helper/show_snack_bar.dart';
import 'package:login_page/screens/welcome.screen.dart';
import 'package:login_page/widgets/custom_button.dart';
import 'package:login_page/widgets/custom_text_field.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});
  static String id = 'SignUp';

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool containsUpperCase = false;
  bool containsLowerCase = false;
  bool containsNumber = false;
  bool containsSpecialChar = false;
  bool contains8Length = false;

  bool? obscurePassword = true;
  bool isLoading = false;
  IconData? iconpassword = CupertinoIcons.eye_fill;
  String? email, password, Name;

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
                } else if (!RegExp(
                        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^]).{8,}$')
                    .hasMatch(data)) {
                  return 'Please enter a valid password';
                }
                return null;
              },
              onChanged: (data) {
                if (data!.contains(RegExp(r'[A-Z]'))) {
                  setState(() {
                    containsUpperCase = true;
                  });
                } else {
                  setState(() {
                    containsUpperCase = false;
                  });
                }
                if (data.contains(RegExp(r'[a-z]'))) {
                  setState(() {
                    containsLowerCase = true;
                  });
                } else {
                  setState(() {
                    containsLowerCase = false;
                  });
                }
                if (data.contains(RegExp(r'[0-9]'))) {
                  setState(() {
                    containsNumber = true;
                  });
                } else {
                  setState(() {
                    containsNumber = false;
                  });
                }
                if (data.contains(
                    RegExp(r'^(?=.*?[!@#$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^])'))) {
                  setState(() {
                    containsSpecialChar = true;
                  });
                } else {
                  setState(() {
                    containsSpecialChar = false;
                  });
                }
                if (data.length >= 8) {
                  setState(() {
                    contains8Length = true;
                  });
                } else {
                  setState(() {
                    contains8Length = false;
                  });
                }

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '⚈  1 uppercase',
                      style: TextStyle(
                          color:
                              containsUpperCase ? Colors.green : Colors.black),
                    ),
                    Text(
                      '⚈  1 lowercase',
                      style: TextStyle(
                          color:
                              containsLowerCase ? Colors.green : Colors.black),
                    ),
                    Text(
                      '⚈  1 number',
                      style: TextStyle(
                          color:
                              containsLowerCase ? Colors.green : Colors.black),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '⚈  1 special character',
                      style: TextStyle(
                          color:
                              containsLowerCase ? Colors.green : Colors.black),
                    ),
                    Text(
                      '⚈ 8 minimum character',
                      style: TextStyle(
                          color:
                              containsLowerCase ? Colors.green : Colors.black),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            CustomFormTextField(
              onChanged: (data) {
                Name = data;
              },
              hintText: 'Name',
              icon: const Icon(
                CupertinoIcons.person_fill,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            CustomButton(
              onTap: () async {
                if (formKey.currentState!.validate()) {
                  isLoading = true;
                  setState(() {});
                  try {
                    await registerUser();
                    showSnackBar(context, 'success');
                  } on FirebaseAuthException catch (ex) {
                    if (ex.code == 'weak-password') {
                      showSnackBar(context, 'weak password');
                    } else if (ex.code == 'email-already-in-use') {
                      showSnackBar(context, 'email already exists');
                    }
                  } catch (ex) {
                    showSnackBar(context, 'there was an error');
                  }
                  isLoading = false;
                  setState(() {});
                }
              },
              text: 'Sign Up',
            ),
          ],
        ),
      ),
    );
  }

  Future<void> registerUser() async {
    UserCredential user = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email!, password: password!);
  }
}
