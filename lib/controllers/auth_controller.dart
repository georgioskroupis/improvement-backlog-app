import '../services/auth_service.dart';
import '../models/user_model.dart';

class AuthController {
  final AuthService _authService = AuthService();

  Future<UserModel?> registerUser(
      String firstName, String lastName, String email, String password) async {
    return await _authService.registerUser(
        firstName, lastName, email, password);
  }

  Future<UserModel?> loginUser(String email, String password) async {
    return await _authService.loginUser(email, password);
  }

  Future<void> logoutUser() async {
    await _authService.logoutUser();
  }
}
