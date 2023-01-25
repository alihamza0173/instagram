import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/resourses/auth_methods.dart';
import 'package:instagram/screens/login_screen.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/utils.dart';
import 'package:instagram/widgets/text_input_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  Uint8List? _image;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
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
              //circular image for input and show
              Stack(
                children: [
                  _image != null?
                  CircleAvatar(
                    radius: 64,
                    backgroundImage: MemoryImage(_image!),    
                  ) : const CircleAvatar(
                    radius: 64,
                    backgroundImage: NetworkImage('https://moorepediatricnc.com/wp-content/uploads/2022/08/default_avatar.jpg'),    
                  ),
                  Positioned(
                      right: 10,
                      bottom: -10,
                      child: IconButton(
                          icon: const Icon(Icons.add_a_photo),
                          onPressed: (() => selectImage()))),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              //text field input for username
              TextInputField(
                textEditingController: _usernameController,
                hintText: 'Enter Your Username',
                textInputType: TextInputType.text,
              ),
              const SizedBox(
                height: 24,
              ),
              //text field input for email
              TextInputField(
                textEditingController: _emailController,
                hintText: 'Enter Your Email Address',
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
              //text field input for bio
              TextInputField(
                textEditingController: _bioController,
                hintText: 'Enter Your Bio',
                textInputType: TextInputType.text,
              ),
              const SizedBox(
                height: 24,
              ),
              //Signup button
              InkWell(
                onTap: () async {
                  String res = await AuthMethods.signUpUser(
                    email: _emailController.text,
                    password: _passwordController.text,
                    username: _usernameController.text,
                    bio: _bioController.text,
                    file: _image!,
                  );
                  print(res);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  width: double.infinity,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                      color: blueColor,
                      borderRadius: BorderRadius.all(Radius.circular(4))),
                  child: const Text('Sign Up'),
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
                  TextSpan(text: "Alrady a member? ", children: [
                    TextSpan(
                      text: 'Login',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => const LoginScreen())));
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
