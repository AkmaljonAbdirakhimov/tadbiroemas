import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tadbiroemas/logic/blocs/auth/auth_bloc.dart';
import 'package:tadbiroemas/ui/screens/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void submit() {
    if (formKey.currentState!.validate()) {
      // login
      context.read<AuthBloc>().add(
            LoginEvent(
              email: emailController.text.trim(),
              password: passwordController.text.trim(),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Kirish"),
              const SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Email",
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Email kiriting";
                  }

                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Parol",
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Parol kiriting";
                  }

                  return null;
                },
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: submit,
                child: const Text("Kirish"),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return const RegisterScreen();
                    },
                  ));
                },
                child: const Text("Ro'yxatdan O'tish"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
