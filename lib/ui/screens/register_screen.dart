import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tadbiroemas/logic/blocs/auth/auth_bloc.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmationController = TextEditingController();

  void submit() {
    if (formKey.currentState!.validate()) {
      // register
      context.read<AuthBloc>().add(
            RegisterEvent(
              email: emailController.text.trim(),
              password: passwordController.text.trim(),
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthenticatedAuthState) {
          Future.delayed(Duration.zero, () {
            Navigator.pop(context);
          });
        }
      },
      child: Scaffold(
        body: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (ctx, state) {
                    if (state is ErrorAuthState) {
                      return Column(
                        children: [
                          Text(state.message),
                          const SizedBox(height: 20),
                        ],
                      );
                    }

                    return const SizedBox();
                  },
                ),
                const Text("Ro'yxatdan O'tish"),
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
                const SizedBox(height: 10),
                TextFormField(
                  controller: passwordConfirmationController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Parol",
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Parolni tasdiqlang";
                    }

                    if (passwordController.text !=
                        passwordConfirmationController.text) {
                      return "Parollar mos kelmadi";
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 20),
                FilledButton(
                  onPressed: submit,
                  child: const Text("Ro'yxatdan O'tish"),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Tizimga Kirish"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
