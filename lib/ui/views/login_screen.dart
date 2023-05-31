import 'package:flutter/material.dart';
import 'package:task/domain/firebase/auth_methods.dart';
import 'package:task/ui/responsive/mobile_screen_layout.dart';
import 'package:task/ui/responsive/responsive_layout_screen.dart';
import 'package:task/ui/responsive/web_screen_layout.dart';
import 'package:task/ui/views/signup_screen.dart';
import 'package:task/ui/widgets/text_field_input.dart';
import 'package:task/utils/colors.dart';
import 'package:task/utils/global_variables.dart';
import 'package:task/utils/utils.dart';

/// Created by Patrice Mulindi email(mulindipatrice00@gmail.com) on 31.11.2023.
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  @override
  void dispose() {
    //dispose all the controllers
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().signInWithEmailPassword(
        emailAddress: _emailController.text,
        password: _passwordController.text);

    if (res == 'Successful authentication.') {
      setState(() {
        _isLoading = true;
      });
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const ResponsiveWidget(
              webScreenLayout: WebScreenLayout(),
              mobileScreenLayout: MobileScreenLayout())));
    } else {
      setState(() {
        _isLoading = true;
      });
      // ignore: use_build_context_synchronously
      showSnackBar(res, context);
    }
  }

  void navigateToSignup() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const SignupScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: MediaQuery.of(context).size.width > webScreenSize
              ? EdgeInsets.symmetric(
                  horizontal: (MediaQuery.of(context).size.width / 3))
              : const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 64),
              //TextField for email
              TextFieldInput(
                hintText: "Enter your email",
                textInputType: TextInputType.emailAddress,
                textEditingController: _emailController,
              ),
              //Textfield for password
              const SizedBox(height: 24),
              TextFieldInput(
                hintText: "Enter your password",
                textInputType: TextInputType.text,
                textEditingController: _passwordController,
              ),
              const SizedBox(height: 64),
              //button login
              InkWell(
                onTap: loginUser,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    color: blueColor,
                  ),
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(color: primaryColor),
                        )
                      : const Text("Log in"),
                ),
              ),
              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text("Don't have an account?"),
                  ),
                  GestureDetector(
                    onTap: navigateToSignup,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        " Register.",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
