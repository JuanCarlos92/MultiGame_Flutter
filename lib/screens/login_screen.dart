import 'package:flutter/material.dart';
import 'package:flutter_game_app/services/backend/login_service.dart';
import 'register_screen.dart';
import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

// Estado del widget LoginScreen
class _LoginScreenState extends State<LoginScreen> {
  // Controladores para los campos del formulario
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Instancia del servicio de autenticación
  final _loginService = LoginService();

  // Variables de estado
  String? _error; // Almacena mensajes de error
  bool _isLoading = false; // Controla el estado de carga
  bool _obscurePassword = true; // Controla la visibilidad de la contraseña

  // Método de inicio de sesión
  void _login() async {
    // Quita el foco del teclado
    FocusScope.of(context).unfocus();

    // Validación de campos vacíos
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() => _error = 'Please fill in all fields');
      return;
    }

    // Actualiza el estado a cargando
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Intento de inicio de sesión con las credenciales proporcionadas
      final player = await _loginService.login(
        _emailController.text,
        _passwordController.text,
        context,
      );

      if (mounted) {
        // Navega a la pantalla principal si es exitoso
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => MainScreen(
              playerId: player.id,
              playerName: player.nombre,
            ),
          ),
        );
      }
    } catch (e) {
      // Manejo de errores durante el inicio de sesión
      setState(() => _error = e.toString());
    } finally {
      // Restablece el estado de carga
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // Método de limpieza
  @override
  void dispose() {
    // Libera los controladores de texto
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagen de fondo
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                      'https://i.ibb.co/NdgRqQCP/ffe426be7cb5ca65f84027dc234478aa.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Contenedor del formulario de inicio de sesión
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 50.0),
              child: Container(
                decoration: BoxDecoration(
                  // Color de fondo del formulario
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Ícono de la aplicación
                    Icon(
                      Icons.sports_esports,
                      size: 64,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(height: 8),

                    // Título de inicio de sesión
                    Text(
                      "Login",
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).primaryColor,
                                fontSize: 48,
                              ),
                    ),

                    const SizedBox(height: 24),

                    // Campo de correo electrónico
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email Address',
                        hintText: 'your.email@example.com',
                        prefixIcon: Icon(Icons.email,
                            color: Theme.of(context).iconTheme.color),
                        filled: true,
                        fillColor: Theme.of(context).canvasColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 14.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Campo de contraseña
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: '••••••••',
                        prefixIcon: Icon(Icons.lock,
                            color: Theme.of(context).iconTheme.color),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Theme.of(context)
                                .iconTheme
                                .color
                                // ignore: deprecated_member_use
                                ?.withOpacity(0.7),
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        filled: true,
                        fillColor: Theme.of(context).canvasColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 14.0,
                        ),
                      ),
                    ),

                    // Mensaje de error
                    const SizedBox(height: 16),
                    if (_error != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          // ignore: deprecated_member_use
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _error!,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Botón de inicio de sesión
                    ElevatedButton(
                      onPressed: _isLoading ? null : _login,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                        backgroundColor: const Color(0xFFF58D00),
                        foregroundColor: Colors.white,
                        disabledBackgroundColor:
                            // ignore: deprecated_member_use
                            const Color(0xFFF58D00).withOpacity(0.6),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                    const SizedBox(height: 10),

                    // Enlace para registrarse
                    TextButton(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => RegisterScreen()),
                      ),
                      child: Text(
                        'Don\'t have an account? Sign up',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
