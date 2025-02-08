// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class AuthService {
//   final GoogleSignIn _googleSignIn = GoogleSignIn(
//     clientId: '389951702551-v2i2hrs9k9vk6ard7162mcsgvc20h2da.apps.googleusercontent.com',
//     scopes: ['email'],
//   );

//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   Future<User?> signInWithGoogle() async {
//     try {
//       // Iniciar o Google Sign-In
//       final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//       if (googleUser == null) {
//         return null; // O usuário cancelou o login
//       }
//       final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

//       // Criar uma credencial com o token do Google
//       final AuthCredential credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       // Fazer login no Firebase com a credencial do Google
//       final UserCredential userCredential = await _auth.signInWithCredential(credential);
//       final User? user = userCredential.user;

//       // Criar perfil no Firestore caso não exista
//       if (user != null) {
//         await _createUserProfile(user);
//       }

//       return user;
//     } catch (error) {
//       // Tratar erro de forma adequada
//       if (error is FirebaseAuthException) {
//         debugPrint("Erro de autenticação do Firebase: ${error.message}");
//       } else {
//         debugPrint("Erro ao fazer login com Google: $error");
//       }
//       return null;
//     }
//   }

//   Future<void> signOut() async {
//     await _googleSignIn.signOut();
//     await _auth.signOut();
//   }

//   // Função para criar perfil do usuário no Firestore
//   Future<void> _createUserProfile(User user) async {
//     final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

//     // Verificar se o usuário já tem um perfil no Firestore
//     final docSnapshot = await userRef.get();
//     if (!docSnapshot.exists) {
//       // Criar um novo perfil
//       await userRef.set({
//         'uid': user.uid,
//         'name': user.displayName ?? 'Anonymous',
//         'email': user.email ?? 'No email',
//         'photoUrl': user.photoURL ?? '',
//         'createdAt': FieldValue.serverTimestamp(),
//       });
//     }
//   }
// }

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
  );
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signInWithGoogle() async {
    try {
      // Iniciar o Google Sign-In
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null; // O usuário cancelou o login
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Criar uma credencial com o token do Google
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Fazer login no Firebase com a credencial do Google
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      // Criar perfil no Firestore caso não exista
      if (user != null) {
        await _createUserProfile(user);
      }

      return user;
    } catch (error) {
      debugPrint("Erro de autenticação do Firebase: $error");
      return null;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  // Função para criar perfil do usuário no Firestore
  Future<void> _createUserProfile(User user) async {
    final userRef =
        FirebaseFirestore.instance.collection('users').doc(user.uid);

    // Verificar se o usuário já tem um perfil no Firestore
    final docSnapshot = await userRef.get();
    if (!docSnapshot.exists) {
      // Criar um novo perfil
      await userRef.set({
        'uid': user.uid,
        'name': user.displayName ?? 'Anonymous',
        'email': user.email ?? 'No email',
        'photoUrl': user.photoURL ?? '',
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }
}
