import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> saveMeditationData(DateTime date, int duration) async {
  User? user = FirebaseAuth.instance.currentUser;

  if (user != null) {
    String uid = user.uid;

    // Referência ao documento do usuário na coleção "users"
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    // Salvar a meditação na subcoleção "meditations"
    await users
        .doc(uid)
        .collection('meditations')
        .add({
          'date': date,
          'duration': duration,
        })
        .then((value) => print("Meditation data saved"))
        .catchError((error) => print("Failed to save meditation: $error"));
  }
}
