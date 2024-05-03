import 'package:flutter/material.dart';
import 'package:suja/constant/utilities/customwidgets/custom_textform_field.dart';
import 'package:suja/features/presentation_layer/api_services/emp_details.dart';

import '../../api_services/login_di.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> LogininFormKey = GlobalKey<FormState>();
  final LoginApiService loginScreen = LoginApiService();
  final FocusNode firstTextFieldFocus = FocusNode();
  final FocusNode secondTextFieldFocus = FocusNode();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isObscureText = true;
  bool isButttonVisible = true;
  bool isLoading = false;

  EmpDetailsApiService empDetailsservice = EmpDetailsApiService();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // Function to refresh the page after successful login
  void refreshPage() {
    setState(() {
      isLoading = false;
      isButttonVisible = true;
      // empDetailsservice.getEmpDetails(context: context);
    });
  }

  void logInUser() async {
    setState(() {
      isLoading = true;
      isButttonVisible = false;
    });

    try {
      await loginScreen.login(
        context: context,
        loginId: emailController.text,
        password: passwordController.text,
      );
    } catch (error) {
      print('Error: $error'); // Print the error for debugging purposes
      setState(() {
        isLoading = false;
        isButttonVisible = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: LogininFormKey,
      child: Padding(
        padding: const EdgeInsets.only(top: 78, left: 25, right: 25),
        child: Column(
          children: [
            CustomTextFormfield(
              controller: emailController,
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(secondTextFieldFocus);
              },
              validation: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter EmployeId';
                }
                if (value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                  return 'Email/Phone cannot contain special symbols';
                }
                if (value.contains(' ')) {
                  return 'Email/Phone cannot contain spaces';
                }
                return null;
              },
              hintText: "Enter Employee Id",
              focusNode: firstTextFieldFocus,
            ),
            const SizedBox(height: 30),
            CustomTextFormfield(
              controller: passwordController,
              hintText: "Password",
              focusNode: secondTextFieldFocus,
              onFieldSubmitted: (value) {
                if (LogininFormKey.currentState?.validate() == true) {
                  logInUser();
                }
              },
              validation: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter password';
                }
                return null;
              },
              isObscureText: isObscureText,
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    isObscureText = !isObscureText;
                  });
                },
                child: Icon(
                  isObscureText
                      ? Icons.visibility_off_outlined
                      : Icons.visibility_outlined, // Toggle the visibility icon
                  color: const Color(0xFF25476A),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    if (LogininFormKey.currentState?.validate() == true) {
                      setState(() {
                        isButttonVisible = false;
                        isLoading = true;
                      });
                      logInUser();
                    }
                  },
                  child: Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: const Color(0xFF25476A),
                        borderRadius: BorderRadiusDirectional.circular(5)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (isButttonVisible)
                          const Text(
                            'Sign In',
                            style: TextStyle(color: Colors.white),
                          ),
                        if (isLoading)
                          const CircularProgressIndicator(
                            color: Colors.white,
                          )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
