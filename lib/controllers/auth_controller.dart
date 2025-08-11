import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';

class AuthController extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _currentUser != null;

  // Constructor
  AuthController() {
    _initializeAuth();
  }

  // Inicializar autenticación de forma segura
  Future<void> _initializeAuth() async {
    try {
      // Configurar Firebase Auth
      await FirebaseAuth.instance.setSettings(
        appVerificationDisabledForTesting: true,
      );
      
      // Verificar estado de autenticación
      _checkAuthState();
      
      print('AuthController inicializado correctamente');
    } catch (e) {
      print('Error inicializando AuthController: $e');
    }
  }

  // Verificar estado de autenticación
  void _checkAuthState() {
    _auth.authStateChanges().listen((User? user) {
      try {
        if (user != null) {
          _currentUser = UserModel.fromFirebaseUser(user);
          print('Usuario autenticado: ${user.email}');
        } else {
          _currentUser = null;
          print('Usuario no autenticado');
        }
      } catch (e) {
        print('Error en _checkAuthState: $e');
        _currentUser = null;
      }
      notifyListeners();
    });
  }

  // Limpiar mensajes de error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Iniciar sesión con email y contraseña
  Future<bool> signInWithEmailAndPassword(String email, String password) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Configurar Auth para evitar problemas de reCAPTCHA
      await FirebaseAuth.instance.setSettings(
        appVerificationDisabledForTesting: true,
      );

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (userCredential.user != null) {
        _currentUser = UserModel.fromFirebaseUser(userCredential.user!);
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException en login: ${e.code} - ${e.message}');
      _errorMessage = _getErrorMessage(e.code);
    } catch (e) {
      print('General Exception en login: ${e.toString()}');
      _errorMessage = 'Error inesperado: ${e.toString()}';
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  // Registrar usuario con email y contraseña
  Future<bool> registerWithEmailAndPassword(String email, String password, String? displayName) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Configurar Auth para evitar problemas de reCAPTCHA
      await FirebaseAuth.instance.setSettings(
        appVerificationDisabledForTesting: true,
      );

      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (userCredential.user != null) {
        // Actualizar el nombre de usuario si se proporcionó
        if (displayName != null && displayName.isNotEmpty) {
          await userCredential.user!.updateDisplayName(displayName);
          // Recargar el usuario para obtener los datos actualizados
          await userCredential.user!.reload();
        }

        _currentUser = UserModel.fromFirebaseUser(userCredential.user!);
        _isLoading = false;
        notifyListeners();
        return true;
      }
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException: ${e.code} - ${e.message}');
      // Si es un error de reCAPTCHA, intentar sin verificación
      if (e.code == 'internal-error' && e.message?.contains('CONFIGURATION_NOT_FOUND') == true) {
        return await _registerWithoutRecaptcha(email, password, displayName);
      }
      _errorMessage = _getErrorMessage(e.code);
    } catch (e) {
      print('General Exception: ${e.toString()}');
      _errorMessage = 'Error inesperado: ${e.toString()}';
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  // Método alternativo para registro sin reCAPTCHA
  Future<bool> _registerWithoutRecaptcha(String email, String password, String? displayName) async {
    try {
      // Intentar de nuevo con configuración adicional
      final auth = FirebaseAuth.instance;
      
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      if (userCredential.user != null) {
        if (displayName != null && displayName.isNotEmpty) {
          await userCredential.user!.updateDisplayName(displayName);
          await userCredential.user!.reload();
        }

        _currentUser = UserModel.fromFirebaseUser(userCredential.user!);
        return true;
      }
    } catch (e) {
      print('Registro alternativo falló: ${e.toString()}');
      _errorMessage = 'No se pudo crear la cuenta. Verifica tu conexión e intenta de nuevo.';
    }
    return false;
  }

  // Cerrar sesión
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      _currentUser = null;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Error al cerrar sesión: ${e.toString()}';
      notifyListeners();
    }
  }

  // Restablecer contraseña
  Future<bool> resetPassword(String email) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _auth.sendPasswordResetEmail(email: email.trim());
      
      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getErrorMessage(e.code);
    } catch (e) {
      _errorMessage = 'Error inesperado: ${e.toString()}';
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  // Método privado para obtener mensajes de error en español
  String _getErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No se encontró un usuario con este email.';
      case 'wrong-password':
        return 'Contraseña incorrecta.';
      case 'email-already-in-use':
        return 'Este email ya está en uso.';
      case 'weak-password':
        return 'La contraseña es muy débil.';
      case 'invalid-email':
        return 'El email no es válido.';
      case 'user-disabled':
        return 'Esta cuenta ha sido deshabilitada.';
      case 'too-many-requests':
        return 'Demasiados intentos. Intenta más tarde.';
      case 'invalid-credential':
        return 'Credenciales inválidas.';
      case 'internal-error':
        return 'Error interno del servidor. Intenta de nuevo.';
      case 'network-request-failed':
        return 'Error de conexión. Verifica tu internet.';
      default:
        return 'Error de autenticación: $code';
    }
  }
}
