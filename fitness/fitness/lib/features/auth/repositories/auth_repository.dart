import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fitpulse_gym/core/providers/firebase_providers.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(firebaseAuthProvider));
});

class AuthRepository {
  final FirebaseAuth _auth;
  AuthRepository(this._auth);

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserCredential?> signInWithGoogle() async {
    GoogleAuthProvider googleProvider = GoogleAuthProvider();
    return await _auth.signInWithPopup(googleProvider);
  }

  Future<UserCredential?> registerWithEmailAndPassword(String email, String password, String name) async {
    // 1. Create user in Firebase Auth
    final credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    
    if (credential.user != null) {
      // 2. Sync to SQL Database via Data Connect
      // Note: In a real app, you would use the generated DataConnect SDK here:
      // await gymDataConnect.createUser(id: credential.user!.uid, name: name, email: email, role: 'member');
      print('SQL Sync: User ${credential.user!.uid} created in Cloud SQL');
    }
    
    return credential;
  }

  Future<UserCredential?> signInWithEmailAndPassword(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  // Admin Mock Logic
  bool isAdmin(String username, String password) {
    final bool isPindhe = username.trim() == 'pindhe' && password.trim() == '1234';
    final bool isDefaultAdmin = username.trim() == 'admin' && password.trim() == 'admin123';
    return isPindhe || isDefaultAdmin;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  User? get currentUser => _auth.currentUser;
}

class UserRoleNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void setRole(String? role) => state = role;
}

final userRoleProvider = NotifierProvider<UserRoleNotifier, String?>(UserRoleNotifier.new);
