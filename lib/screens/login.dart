import 'package:flutter/material.dart';
import 'package:wh/screens/home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(),
              TextField(),
              TextField(),
              ElevatedButton(
                onPressed: () => {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return HomePage();
                  }))
                },
                child: Row(
                  children: const [
                    Text('Login'),
                    Icon(Icons.login),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
