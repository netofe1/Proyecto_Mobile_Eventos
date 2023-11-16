import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  String msgError = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Colors.yellow.shade700, Color(0xFF051E34)],
          ),
        ),
        child: Container(
          margin: EdgeInsets.only(top: 50),
          decoration: BoxDecoration(
            color: Color(0xAAFFFFFF),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Form(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 180, horizontal: 20),
              color: Colors.white,
              child: ListView(
                children: [
                  Icon(MdiIcons.firebase, color: Colors.yellow.shade800, size: 70),
                  //email
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 40, vertical: 0),
                    child: TextFormField(
                      controller: emailCtrl,
                      decoration: InputDecoration(labelText: 'Email'),
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  //password
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 40, vertical: 0),
                    child: TextFormField(
                      controller: passwordCtrl,
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                    ),
                  ),
                  //boton
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                    width: double.infinity,
                    child: FilledButton(
                      child: Text('Iniciar Sesión'),
                      onPressed: () async {
                        try {
                          await FirebaseAuth.instance.signInWithEmailAndPassword(
                            email: emailCtrl.text.trim(),
                            password: passwordCtrl.text.trim(),
                          );
                        } on FirebaseAuthException catch (ex) {
                          setState(() {
                            switch (ex.code) {
                              case 'channel-error':
                                msgError = 'Complete el formulario';
                                break;
                              case 'invalid-email':
                                msgError = 'Email no válido';
                                break;
                              case 'INVALID_LOGIN_CREDENTIALS':
                                msgError = 'Credenciales incorrectas';
                                break;
                              case 'user-disabled':
                                msgError = 'Cuenta desactivada';
                                break;
                              default:
                                msgError = 'Error en el sistema';
                            }
                          });
                        }
                      },
                    ),
                  ),
                  //errores
                  Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text(msgError, style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
