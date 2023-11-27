import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool rememberMe = false;
  bool isPasswordVisible = false;

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // Future<void> login() async {
  //   User user = User(
  //     username: usernameController.text,
  //     password: passwordController.text,
  //   );

  //   try {
  //     final result = await ServiceUser().login(user);

  //     if (result['success']) {
  //       final token = result['data']["loginResult"]["token"];
  //       // Provider.of<ProviderAuth>(context, listen: false).setToken(token);
  //       _showSuccessDialog();
  //     } else {
  //       _showErrorDialog(result['errorMessage']);
  //     }
  //   } catch (e) {
  //     _showErrorDialog(e.toString());
  //   }
  // }

  // void _showErrorDialog(String message) {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text('Error'),
  //       content: Text(message),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(context),
  //           child: const Text('OK'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // void _showSuccessDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (context) => AlertDialog(
  //       title: const Text('Success'),
  //       content: const Text('Login successful!'),
  //       actions: [
  //         TextButton(
  //           onPressed: () {
  //             Navigator.pop(context);
  //             Navigator.pushReplacementNamed(context, '/homePage');
  //           },
  //           child: const Text('OK'),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).colorScheme.primary,
              Color.fromARGB(255, 255, 255, 255),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildHeader(),
                _buildLoginContainer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 340,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Absensi \n APP',
            style: GoogleFonts.lato(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLoginContainer() {
    return Container(
      padding: EdgeInsets.all(20.0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(30.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildWelcomeText(),
          SizedBox.fromSize(size: Size(0, 20)),
          _buildUsernameField(),
          SizedBox(height: 20),
          _buildPasswordField(),
          SizedBox(height: 20),
          _buildRememberMe(),
          SizedBox(height: 20),
          _buildLoginButton(),
          SizedBox(height: 20),
          _buildSignUpLink(),
        ],
      ),
    );
  }

  Widget _buildWelcomeText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        SizedBox.fromSize(size: Size(0, 5)),
        Text(
          'Please login with your account',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildUsernameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Username',
          style: TextStyle(
            fontSize: 18,
            color: const Color.fromARGB(255, 71, 73, 77),
          ),
        ),
        TextField(
          controller: usernameController,
          decoration: InputDecoration(
            suffixIcon: Icon(Icons.check),
            suffixIconConstraints: BoxConstraints(
              maxHeight: 32,
              maxWidth: 32,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
          style: TextStyle(
            fontSize: 18,
            color: const Color.fromARGB(255, 71, 73, 77),
          ),
        ),
        TextField(
          controller: passwordController,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: isPasswordVisible
                  ? Icon(Icons.visibility)
                  : Icon(Icons.visibility_off),
              onPressed: () {
                setState(() {
                  isPasswordVisible = !isPasswordVisible;
                });
              },
            ),
            suffixIconConstraints: BoxConstraints(
              maxHeight: 32,
              maxWidth: 32,
            ),
          ),
          obscureText: !isPasswordVisible,
        ),
      ],
    );
  }

  Widget _buildRememberMe() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
              value: rememberMe,
              onChanged: (value) {
                setState(() {
                  rememberMe = value!;
                });
              },
            ),
            Text('Remember Me'),
          ],
        ),
        Spacer(),
        Text('Forget Password?'),
      ],
    );
  }

  Widget _buildLoginButton() {
    return Container(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        // onPressed: login,
        onPressed: () {
          // Navigator.pushReplacementNamed(context, '/homePage');
        },
        child: Text(
          'Login',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          primary: Theme.of(context).colorScheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Don't have an account?"),
        TextButton(
          onPressed: () {},
          child: Text('Sign Up'),
        ),
      ],
    );
  }
}
