import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:reddit_clone/core/constants.dart';
import 'package:reddit_clone/core/firebase_constants.dart';
import 'package:reddit_clone/core/providers/firebase_providers.dart';
import 'package:reddit_clone/failure.dart';
import 'package:reddit_clone/models/user_model.dart';

import '../../../typedefs.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository(
      auth: ref.read(authProvider),
      firestore: ref.read(fireStoreProvider),
      googleSignIn: ref.read(googleSignInProvider),
    ));

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _fireStore;
  final GoogleSignIn _googleSignIn;

  AuthRepository({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
    required GoogleSignIn googleSignIn,
  })  : _fireStore = firestore,
        _firebaseAuth = auth,
        _googleSignIn = googleSignIn;

  CollectionReference get _users =>
      _fireStore.collection(FirebaseConstants.usersCollection);

  Stream<User?> get authStateChange => _firebaseAuth.authStateChanges();

  FutureEither<UserModel> signInWithGoogle(bool isFromLogin) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential;
      if (isFromLogin) {
        userCredential = await _firebaseAuth.signInWithCredential(credential);
      } else {
        userCredential =
            await _firebaseAuth.currentUser!.linkWithCredential(credential);
      }

      UserModel userModel;
      if (userCredential.additionalUserInfo!.isNewUser) {
        userModel = UserModel(
          name: userCredential.user!.displayName ?? '',
          profilePic: userCredential.user!.photoURL ?? Constants.avatarDefault,
          banner: Constants.bannerDefault,
          uid: userCredential.user!.uid,
          isAuthenticated: true,
          karma: 0,
          awards: [
            'til',
            'thankyou',
          ],
        );
        await _users.doc(userModel.uid).set(userModel.toMap());
      } else {
        userModel = await getUsersData(userCredential.user!.uid).first;
      }
      return right(userModel);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  FutureEither<UserModel> signInGuest() async {
    try {
      var userCredential = await _firebaseAuth.signInAnonymously();
      UserModel userModel;

      userModel = UserModel(
        name: 'Guest',
        profilePic: Constants.avatarDefault,
        banner: Constants.bannerDefault,
        uid: userCredential.user!.uid,
        isAuthenticated: false,
        karma: 0,
        awards: [],
      );
      await _users.doc(userModel.uid).set(userModel.toMap());

      return right(userModel);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  Stream<UserModel> getUsersData(String uid) {
    return _users.doc(uid).snapshots().map(
        (event) => UserModel.fromMap(event.data() as Map<String, dynamic>));
  }

  void logOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }
}
