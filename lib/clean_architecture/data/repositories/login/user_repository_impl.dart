import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pharma_transfer/clean_architecture/domain/entities/user.dart';
import 'package:pharma_transfer/clean_architecture/domain/repositories/user_repository.dart';

class UserRepositoryImpl extends UserRepository {
  @override
  Future<User?> getUserByGoogleAccount(String userEmail) {
    // TODO: implement getUserByGoogleAccount
    throw UnimplementedError();
  }

  @override
  Future<String?> userLoginWithProvider() async {
    final googleUser = (await GoogleSignIn().signInSilently()) ??
        (await GoogleSignIn().signIn());
    debugPrint('$googleUser');
    return  googleUser?.email;
  }
}
