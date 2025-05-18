import 'package:campph/themes/app_colors.dart';
import 'package:campph/themes/app_text_styles.dart';
import 'package:campph/widgets/navigation_widget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  String? _errorMessage;
  double fieldWidth = 0;

  @override
  Widget build(BuildContext context) {
    fieldWidth = MediaQuery.of(context).size.width * 0.7;

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
                  child: RichText(
                    text: TextSpan(
                      text: 'Create your account',
                      style: TextStyle(
                        color: AppColors.black,
                        letterSpacing: -0.2,
                        fontWeight: FontWeight.w700,
                        fontSize: AppTextStyles.header1.fontSize,
                      ),
                    ),
                  ),
                ),

                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red),
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
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
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
                    obscureText: _obscurePassword,
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
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
                      labelStyle: TextStyle(
                        color: AppColors.gray,
                        fontSize: AppTextStyles.body1.fontSize,
                      ),
                      suffixIcon: IconButton(
                        onPressed:
                            () => setState(
                              () => _obscurePassword = !_obscurePassword,
                            ),
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30),

                SizedBox(
                  width: fieldWidth,
                  child: TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Confirm your password.';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match.';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.white2,
                      border: const OutlineInputBorder(),
                      labelText: 'Confirm Password',
                      floatingLabelBehavior: FloatingLabelBehavior.auto,
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
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.darkGreen,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _signUp,
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: AppTextStyles.header3.fontSize,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const NavigationWidget()),
        );
      } on FirebaseAuthException catch (e) {
        setState(() => _errorMessage = e.message);
      } catch (e) {
        setState(() => _errorMessage = 'An unknown error occurred.');
      }
    }
  }
}
