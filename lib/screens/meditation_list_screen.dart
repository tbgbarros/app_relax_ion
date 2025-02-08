import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//'/meditations': (context) => const MeditationListScreen(),
class MeditationListScreen extends StatelessWidget {
  const MeditationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meditations'),
      ),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text('Meditation $index'),
            onTap: () {
              // Navigate to meditation details screen
            },
          );
        },
      ),
    );
  }
}

class MeditationHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Histórico de Meditações')),
      body: FutureBuilder(
        future: getMeditationData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar meditações'));
          } else {
            final meditations = snapshot.data as List<Map<String, dynamic>>;
            return ListView.builder(
              itemCount: meditations.length,
              itemBuilder: (context, index) {
                final meditation = meditations[index];
                return ListTile(
                  title: Text('Data: ${meditation['date']}'),
                  subtitle: Text('Duração: ${meditation['duration']} minutos'),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> getMeditationData() async {
    User? user = FirebaseAuth.instance.currentUser;
    List<Map<String, dynamic>> meditations = [];

    if (user != null) {
      String uid = user.uid;

      // Recuperar as meditações do Firestore
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('meditations')
          .get();

      // Converter os documentos para uma lista de mapas
      for (var doc in querySnapshot.docs) {
        meditations.add(doc.data() as Map<String, dynamic>);
      }
    }

    return meditations;
  }
}
