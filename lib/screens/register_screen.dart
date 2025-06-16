import 'package:flutter/material.dart';
import 'package:flutter_game_app/screens/login_screen.dart';
import 'package:flutter_game_app/services/backend/register_service.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

// Estado del widget RegisterScreen
class _RegisterScreenState extends State<RegisterScreen> {
  // Controladores para los campos del formulario
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  // Instancia del servicio de autenticación
  final _registerService = RegisterService();
  // Variables de estado
  bool _isLoading = false; // Indica si hay una operación en proceso
  String? _error; // Almacena mensajes de error

  // Método para manejar el registro de usuario
  Future<void> _register() async {
    // Validación de campos vacíos
    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _nameController.text.isEmpty) {
      setState(() {
        _error = 'Por favor, complete todos los campos';
      });
      return;
    }

    // Actualiza el estado a cargando
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Intento de registro con los datos proporcionados
      await _registerService.register(
        _nameController.text,
        _emailController.text,
        _passwordController.text,
      );

      // Si el widget sigue montado, muestra mensaje de éxito y navega al login
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registro exitoso. Por favor inicie sesión.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LoginScreen()),
        );
      }
    } catch (e) {
      // Manejo de errores durante el registro
      setState(() {
        _error = e.toString();
      });
    } finally {
      // Restablece el estado de carga
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Limpieza de recursos al destruir el widget
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
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
          // Contenedor principal del formulario
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo o ícono de registro
                  Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade100,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Image.asset(
                      'assets/iconoregistro.png',
                      height: 90,
                    ),
                  ),
                  SizedBox(height: 10),
                  // Título de la pantalla
                  Text(
                    'REGISTER',
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      // ignore: deprecated_member_use
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  SizedBox(height: 20),
                  // Campo de nombre
                  SizedBox(
                    width: 250,
                    height: 50,
                    child: TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        prefixIcon:
                            Icon(Icons.person, size: 30, color: Colors.white),
                        hintText: 'Nombre',
                        hintStyle: TextStyle(fontSize: 20, color: Colors.white),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 255, 192, 99),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 15),

                  // Campo de correo electrónico
                  SizedBox(
                    width: 250,
                    height: 50,
                    child: TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        prefixIcon:
                            Icon(Icons.email, size: 30, color: Colors.white),
                        hintText: 'Correo electrónico',
                        hintStyle: TextStyle(fontSize: 20, color: Colors.white),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 255, 192, 99),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 15),

                  // Campo de contraseña
                  SizedBox(
                    width: 250,
                    height: 50,
                    child: TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        prefixIcon:
                            Icon(Icons.lock, size: 30, color: Colors.white),
                        hintText: 'Contraseña',
                        hintStyle: TextStyle(fontSize: 20, color: Colors.white),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 255, 192, 99),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 10),

                  // Mensaje de error (si existe)
                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                        _error!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  // Botón de registro
                  SizedBox(
                    width: 250,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _register,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 233, 140, 0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
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
                              'Registrarse',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(height: 10),

                  // Enlace para ir a inicio de sesión
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => LoginScreen()),
                    ),
                    child: Text(
                      'Already have an account? Sign in',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
