import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ejemplo_validar_form/services/firestore_service.dart';
import 'package:ejemplo_validar_form/widget/D_Eventos.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';



class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AssetImage fondo = AssetImage('assets/images/Fondo_Eventos2.png');

  final AssetImage fondo1 = AssetImage('assets/images/Fondo_Eventos.png');

  final formatoFecha = DateFormat('dd-MM-yyyy hh:mm');

  var respuesta = 'todos';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [  
            Icon(MdiIcons.firework,color: Colors.lightBlueAccent,size: 40,),       
            Text('Lista Eventos',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.white),),
            Spacer(),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(image: fondo, fit: BoxFit.cover),
          ),
        child: Column(
          children: [
            
            //LISTA DE EVENTOS
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: StreamBuilder(
                  stream: FirestoreService().FiltrarEventos(respuesta),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      return ListView.separated(
                        separatorBuilder: (context, index) => Divider(),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var evento = snapshot.data!.docs[index];
                          DateTime fechaEvento = evento['fechaYHora'].toDate();
                          bool esProximo = fechaEvento.isAfter(DateTime.now()) && fechaEvento.isBefore(DateTime.now().add(Duration(days: 3)));
                          return ListTile(
                              leading: Icon(
                                esProximo ? Icons.star : Icons.event,
                                color: esProximo ? Colors.orange : Colors.black,),
                              title: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      SizedBox(width: 180, child: Text(evento['nombre'],style: TextStyle(fontWeight: FontWeight.bold,fontSize:17 ,color: esProximo ? Color(0xff4FFFB9) :null))),
                                      SizedBox(width: 180, child: Text(evento['estado'],style: TextStyle(fontWeight: FontWeight.bold,fontSize:17,color: esProximo ?  Color(0xff4FFFB9) :null))),
                                      SizedBox(width: 180, child: Text(formatoFecha.format(evento['fechaYHora'].toDate()),style: TextStyle(fontWeight: FontWeight.bold,fontSize:17,color: esProximo ?  Color(0xff4FFFB9) :null))),
                                    ],
                                  ),
                                  ElevatedButton.icon(
                                      style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.transparent) ),
                                      onPressed: (){
                                          setState(() {
                                              FirestoreService().Incremento(evento.id);
                                          });
                                          }, 
                                      icon: Icon(Icons.favorite,color: Colors.red,),
                                      label: Text(evento['cont'].toString(),style: Theme.of(context).textTheme.headlineMedium,), //label text 
                                  )
                                ],
                              ),
                              subtitle: Row(children: [
                                  
                              ],),
                              
                              onLongPress: () {
                                monstrarInfoEvento(context, evento);
                                                                
                              },
                            );
                        },
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: fondo1, fit: BoxFit.cover),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/Fondo_IZ.jpeg'),
                    fit: BoxFit.cover)
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(MdiIcons.firework, color: Colors.deepPurpleAccent, size: 40),
                        SizedBox(width: 10),
                        Text('Menu Eventos', style: TextStyle(fontSize: 24, fontWeight:
                        FontWeight.bold, color: Colors.black)),
                      ],
                    ),
                    SizedBox(height: 10),
                    FutureBuilder<User?>(
                      future: FirebaseAuth.instance.authStateChanges().first,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error');
                        } else if (snapshot.hasData) {
                          return Text(snapshot.data?.email ?? '');
                        } else {
                          return Text('');
                        }
                      },
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  ListTile(
                title: Text('Iniciar Sesión',style: TextStyle(color: Colors.pink,fontSize: 25),),
                onTap: () {
                  signInWithGoogle();
                  Navigator.pop(context);
                },
              ),
                ],
              ),
              Column(
                children: [
                  ListTile(
                leading: Icon(MdiIcons.filter,color: Color.fromARGB(231, 242, 255, 0),size: 30,),
                title: Text('Filtrar eventos finalizados',style: TextStyle(color: Colors.pink,fontSize: 20),),
                onTap: () {
                  setState(() {
                    respuesta = 'finalizado';
                  });           
                  Navigator.pop(context);
                },
              ),
                ],
              ),
              Column(
                children: [
                  ListTile(
                leading: Icon(MdiIcons.filterMinus,color: Color.fromARGB(231, 242, 255, 0),size: 30,),
                title: Text('Filtrar eventos Proximos',style: TextStyle(color: Colors.pink,fontSize: 20),),
                onTap: () {
                  setState(() {
                    respuesta = 'proximamente';
                  });           
                  Navigator.pop(context);
                },
              ),
                ],
              ),
              Column(
                children: [
                  ListTile(
                leading: Icon(MdiIcons.filterRemove,color: Color.fromARGB(231, 242, 255, 0),size: 30,),
                title: Text('Quitar filtro',style: TextStyle(color: Colors.pink,fontSize: 20),),
                onTap: () {
                  setState(() {
                    respuesta = 'todos';
                  });           
                  Navigator.pop(context); 
                },
              ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }

  signInWithGoogle() async {
      GoogleSignInAccount? googleUser= await GoogleSignIn().signIn();
      GoogleSignInAuthentication? googleAuth=await googleUser?.authentication;
      AuthCredential credential= GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken
      );
      UserCredential user=await FirebaseAuth.instance.signInWithCredential(credential);
      print(user.user?.displayName);
      
  }

}

