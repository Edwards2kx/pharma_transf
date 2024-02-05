import '../entities/user.dart';

abstract class UserRepository {
  Future<User?> getUserByGoogleAccount(String userEmail);

  Future<String?> userLoginWithProvider();
}