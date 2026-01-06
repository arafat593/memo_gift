import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  var isLoading = false.obs;
  var user = Rxn<User>();

  @override
  void onInit() {
    super.onInit();
    // Auth state-কে অবজার্ভ করা হচ্ছে
    user.bindStream(_authService.user);
  }

  Future<void> login(String email, String password) async {
    final cleanedEmail = email.trim();
    final cleanedPassword = password.trim();

    if (cleanedEmail.isEmpty || cleanedPassword.isEmpty) {
      Get.snackbar('Error', 'Email and password are required');
      return;
    }

    try {
      isLoading.value = true;
      await _authService.signIn(cleanedEmail, cleanedPassword);
    } catch (e) {
      Get.snackbar('Login Failed', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signUp(String email, String password) async {
    final cleanedEmail = email.trim();
    final cleanedPassword = password.trim();

    if (cleanedEmail.isEmpty || cleanedPassword.isEmpty) {
      Get.snackbar('Error', 'Email and password are required');
      return;
    }

    try {
      isLoading.value = true;
      await _authService.signUp(cleanedEmail, cleanedPassword);
    } catch (e) {
      Get.snackbar('Registration Failed', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _authService.signOut();
    user.value = null; // Explicitly null for faster UI response
  }
}
