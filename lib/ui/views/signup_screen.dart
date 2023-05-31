import 'package:flutter/material.dart';
import 'package:task/domain/firebase/auth_methods.dart';
import 'package:task/ui/responsive/mobile_screen_layout.dart';
import 'package:task/ui/responsive/responsive_layout_screen.dart';
import 'package:task/ui/responsive/web_screen_layout.dart';
import 'package:task/ui/views/login_screen.dart';
import 'package:task/ui/widgets/text_field_input.dart';
import 'package:task/utils/colors.dart';
import 'package:task/utils/global_variables.dart';
import 'package:task/utils/utils.dart';

/// Created by Patrice Mulindi email(mulindipatrice00@gmail.com) on 31.11.2023.

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();

  bool _isLoading = false;
  @override
  void dispose() {
    //dispose the controllers
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _genderController.dispose();
    _mobileController.dispose();
    _dobController.dispose();
  }

  void signUpUser() async {
    final AuthMethods authMethods = AuthMethods();
    setState(() {
      _isLoading = true;
    });
    String res = await authMethods.createAccount(
      emailAddress: _emailController.text,
      password: _passwordController.text,
    );
    if (res == 'Account created successfully') {
      res = await authMethods.saveUserInfo(
          email: _emailController.text,
          password: _passwordController.text,
          name: _nameController.text,
          gender: _genderController.text,
          dob: _dobController.text,
          mobile: _mobileController.text);
    }
    setState(() {
      _isLoading = false;
    });
    if (res != 'Account created successfully') {
      // ignore: use_build_context_synchronously
      showSnackBar(res, context);
    } else {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const ResponsiveWidget(
              webScreenLayout: WebScreenLayout(),
              mobileScreenLayout: MobileScreenLayout())));
    }
  }

  void navigateToLogin() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: MediaQuery.of(context).size.width > webScreenSize
              ? EdgeInsets.symmetric(
                  horizontal: (MediaQuery.of(context).size.width / 3))
              : const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 64),
              //TextField for  Name
              TextFieldInput(
                hintText: "Enter your name",
                textInputType: TextInputType.emailAddress,
                textEditingController: _nameController,
              ),
              const SizedBox(height: 24),
              //TextField for mobile number
              TextFieldInput(
                hintText: "Enter your mobile number",
                textInputType: TextInputType.phone,
                textEditingController: _mobileController,
              ),
              //TextField for email
              const SizedBox(height: 24),
              TextFieldInput(
                hintText: "Enter your email",
                textInputType: TextInputType.emailAddress,
                textEditingController: _emailController,
              ),
              //TextField for gender
              const SizedBox(height: 24),
              TextFieldInput(
                hintText: "Enter your gender",
                textInputType: TextInputType.text,
                textEditingController: _genderController,
              ),
              //TextField for dob
              const SizedBox(height: 24),
              TextFieldInput(
                hintText: "Enter your date of birth",
                textInputType: TextInputType.datetime,
                textEditingController: _dobController,
              ),
              //Textfield for password
              const SizedBox(height: 24),
              TextFieldInput(
                hintText: "Enter your password",
                textInputType: TextInputType.text,
                textEditingController: _passwordController,
              ),
              //TextField for bio
              const SizedBox(height: 64),
              //button login
              InkWell(
                onTap: signUpUser,
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
                      : const Text("Register"),
                ),
              ),
              const SizedBox(height: 12),

              //Transitionaing to signup
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text("Already have an account?"),
                  ),
                  GestureDetector(
                    onTap: navigateToLogin,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        " Log in.",
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
