import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();

    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              final user = await authService.signInWithGoogle();
              if (user != null) {
                Navigator.pushReplacementNamed(context, '/home');
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Falha no login. Tente novamente.'),
                  ),
                );
              }
            } catch (error) {
              // Exibir mensagem de erro adequada
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Erro: $error'),
                ),
              );
            }
          },
          child: const Text('Login com Google'),
        ),
      ),
    );
  }
}
