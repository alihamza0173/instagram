import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/resourses/auth_methods.dart';
import 'package:instagram/screens/signup_screen.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/widgets/text_input_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        width: double.infinity,
        child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              //svg image
              SvgPicture.asset(
                'assets/images/ic_instagram.svg',
                color: primaryColor,
                height: 64,
              ),
              const SizedBox(
                height: 64,
              ),
              //text field input for email
              TextInputField(
                textEditingController: _emailController,
                hintText: 'Enter Your Email',
                textInputType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 24,
              ),
              //text field input for password
              TextInputField(
                textEditingController: _passwordController,
                hintText: 'Enter Your Password',
                textInputType: TextInputType.visiblePassword,
                isSecure: true,
              ),
              const SizedBox(
                height: 24,
              ),
              //login button
              InkWell(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                      color: blueColor,
                      borderRadius: BorderRadius.all(Radius.circular(4))),
                  child: const Text('Login'),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              const Spacer(),
              //transitioning to sign up
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text.rich(
                  TextSpan(text: "Don't Have an Account? ", children: [
                    TextSpan(
                      text: 'SignUp',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          await AuthMethods.loginUser(
                                  email: _emailController.text,
                                  password: _passwordController.text)
                              .then((value) => Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: ((context) =>
                                          const SignupScreen()))));
                        },
                    )
                  ]),
                ),
              ),
            ]),
      )),
    );
  }
}
