import 'package:campph/themes/app_colors.dart';
import 'package:campph/themes/app_text_styles.dart';
import 'package:campph/widgets/navigation_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';


class LoginPage extends StatefulWidget {

  const LoginPage({super.key});


  @override
  // ignore: library_private_types_in_public_api
  _LoginPage createState() => _LoginPage();
  
}

class _LoginPage extends State<LoginPage> {

  bool _obscureText = true;

  double fieldWidth = 0.0;
  double fieldHeight = 0.0;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    fieldWidth = MediaQuery.of(context).size.width * .7;
    
    fieldHeight = MediaQuery.of(context).size.height * .1;

    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: RichText(
                    text: TextSpan(
                      text: 'Login to your account',
                      style: TextStyle(
                        color: AppColors.black,
                        letterSpacing: -0.2,
                        fontWeight: FontWeight.w700,
                        fontSize: AppTextStyles.header1.fontSize
                      )
                    ),
                )
              ),
              SizedBox(
                width: fieldWidth,
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Username is required.';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.white2,
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    labelStyle: TextStyle(
                      color: AppColors.gray,
                      letterSpacing: -0.2,
                      fontSize: AppTextStyles.body1.fontSize
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              SizedBox(
                width: fieldWidth,
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required.';
                    }
                    return null;
                  },
                  cursorColor: AppColors.veryDarkGreen,
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.white2,
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    labelStyle: TextStyle(
                      color: AppColors.gray,
                      letterSpacing: -0.2,
                      fontSize: AppTextStyles.body1.fontSize
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState((){
                          _obscureText = !_obscureText;
                        });
                      }, 
                      icon: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off
                      )
                    )
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
                    foregroundColor: AppColors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()){
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const NavigationWidget()),
                      );
                    }
                  },
                  child: RichText(
                    text: TextSpan(
                      text: 'Login',
                      style: TextStyle(
                        color: AppColors.white,
                        letterSpacing: -0.2,
                        fontWeight: FontWeight.normal,
                        fontSize: AppTextStyles.header3.fontSize
                      )
                    ),
                  ),
                ),
              ),

              Container(
                width: fieldWidth,
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Divider(
                        color: AppColors.gray,
                        thickness: 1,
                      ),
                    ),
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
                    Expanded(
                      child: Divider(
                        color: AppColors.gray,
                        thickness: 1,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
                width: fieldWidth,
                child: SignInButton(
                  Buttons.Google,
                  onPressed: () {
                    //To do
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

}
/*

  import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:campph/navigation_widget.dart'; // Import your navigation widget

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  bool _obscureText = true;
  double fieldWidth = 0.0;
  double fieldHeight = 0.0;
  final _formKey = GlobalKey<FormState>();
  
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    fieldWidth = MediaQuery.of(context).size.width * .7;
    fieldHeight = MediaQuery.of(context).size.height * .1;

    return Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.symmetric(vertical: 30),
                child: RichText(
                    text: TextSpan(
                      text: 'Login to your account',
                      style: TextStyle(
                        color: Colors.black,
                        letterSpacing: -0.2,
                        fontWeight: FontWeight.w700,
                        fontSize: 24
                      )
                    ),
                )
              ),
              SizedBox(
                width: fieldWidth,
                child: TextFormField(
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Username is required.';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                  ),
                ),
              ),
              SizedBox(height: 30),
              SizedBox(
                width: fieldWidth,
                child: TextFormField(
                  controller: _passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required.';
                    }
                    return null;
                  },
                  obscureText: _obscureText,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      }, 
                      icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
                    )
                  ),
                ),
              ),
              Container(
                height: 50,
                margin: const EdgeInsets.only(top: 30),
                width: fieldWidth,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
                          email: _emailController.text,
                          password: _passwordController.text,
                        );

                        // Successfully logged in, navigate to the next page
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const NavigationWidget()),
                        );
                      } catch (e) {
                        // Handle errors
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Login failed: ${e.toString()}")),
                        );
                      }
                    }
                  },
                  child: Text('Login'),
                ),
              ),
              // Add the Google sign-in button or any other authentication methods
            ],
          ),
        ),
      ),
    );
  }
}

*/