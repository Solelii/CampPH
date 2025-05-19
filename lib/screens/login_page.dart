import 'package:campph/themes/app_colors.dart';
import 'package:campph/themes/app_text_styles.dart';
import 'package:campph/widgets/navigation_widget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  bool _obscureText = true;
  double fieldWidth = 0.0;
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _showLoginError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Login failed: $message"),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    fieldWidth = MediaQuery.of(context).size.width * .7;

    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  child: Text(
                    'Login to your account',
                    style: TextStyle(
                      color: AppColors.black,
                      letterSpacing: -0.2,
                      fontWeight: FontWeight.w700,
                      fontSize: AppTextStyles.header1.fontSize,
                    ),
                  ),
                ),
                SizedBox(
                  width: fieldWidth,
                  child: TextFormField(
                    controller: _emailController,
                    validator:
                        (value) =>
                            (value == null || value.isEmpty)
                                ? 'Email is required.'
                                : null,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.white2,
                      border: const OutlineInputBorder(),
                      labelText: 'Email',
                      labelStyle: TextStyle(
                        color: AppColors.gray,
                        fontSize: AppTextStyles.body1.fontSize,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  width: fieldWidth,
                  child: TextFormField(
                    controller: _passwordController,
                    obscureText: _obscureText,
                    validator:
                        (value) =>
                            (value == null || value.isEmpty)
                                ? 'Password is required.'
                                : null,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.white2,
                      border: const OutlineInputBorder(),
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        color: AppColors.gray,
                        fontSize: AppTextStyles.body1.fontSize,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 50,
                  margin: const EdgeInsets.only(top: 30),
                  width: fieldWidth,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.darkGreen,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          await _auth.signInWithEmailAndPassword(
                            email: _emailController.text.trim(),
                            password: _passwordController.text.trim(),
                          );
                          if (mounted) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const NavigationWidget(),
                              ),
                            );
                          }
                        } catch (e) {
                          _showLoginError(e.toString());
                        }
                      }
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: AppTextStyles.header3.fontSize,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: fieldWidth,
                  child: Row(
                    children: <Widget>[
                      const Expanded(child: Divider(thickness: 1)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "OR",
                          style: TextStyle(
                            color: AppColors.gray,
                            fontSize: AppTextStyles.body2.fontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Expanded(child: Divider(thickness: 1)),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 50,
                  width: fieldWidth,
                  child: SignInButton(
                    Buttons.Google,
                    onPressed: () {
                      // TODO: Add Google sign-in implementation
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
