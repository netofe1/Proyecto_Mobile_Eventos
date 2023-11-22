import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ejemplo_validar_form/pages/Agregar_Eventos_page.dart';
import 'package:ejemplo_validar_form/services/firestore_service.dart';
import 'package:ejemplo_validar_form/widget/D_Eventos.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class Test extends StatefulWidget {
  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  final AssetImage fondo = AssetImage('assets/images/Fondo_Eventos2.png');

  final GlobalKey<ScaffoldState> Key1 = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: Key1,
        appBar:AppBar(
          title: Text('Menu Administrador'),
          leading: Icon(MdiIcons.shieldAccount, color: Colors.black,size: 40,),
          actions: [
            PopupMenuButton(
            itemBuilder: (context) => [PopupMenuItem(child: Text('Cerrar Sesión'), value: 'logout')],
            onSelected: (opcion)async {
              await GoogleSignIn().signOut();
              FirebaseAuth.instance.signOut();
            },
          ),
        ],
        ),

        body:Container(
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
                  stream: FirestoreService().Eventos(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      return ListView.separated(
                        separatorBuilder: (context, index) => Divider(),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var evento = snapshot.data!.docs[index];
                          return Slidable(
                            startActionPane: ActionPane(
                              motion: ScrollMotion(),
                              children: [
                                SlidableAction(
                                  backgroundColor: Colors.red,
                                  icon: MdiIcons.trashCan,
                                  label: 'Borrar',
                                  onPressed: (context) {
                                    confirmarBorrado(context, evento).then((confirmaBorrado) {
                                    if (confirmaBorrado) {
                                     setState(() {
                                          FirestoreService().eventosBorrar(evento.id);                  
                                      }
                                      );
                                     }
                                      },
                                    );
                                    
                                  },
                                ),
                                
                              ],
                            ),
                            
                            endActionPane: ActionPane(
                              motion: ScrollMotion(),
                              children: [
                                Container(
                                  
                                  child: SlidableAction(
                                    backgroundColor: Colors.blue,
                                    icon: MdiIcons.calendarRemove,
                                    label: 'F',
                                    
                                    
                                    onPressed: (context) {
                                      confirmarEdicion(context, evento).then((confirmaEditFin) {
                                      if (confirmaEditFin) {
                                       setState(() {
                                            FirestoreService().cambiarEstadoEvento(evento.id,'finalizado');                  
                                        }
                                        );
                                       }
                                        },
                                      );
                                      
                                    },
                                  ),
                                ),
                                Container(
                                  
                                  child: SlidableAction(
                                    backgroundColor: Colors.blue,
                                    icon: MdiIcons.calendarStar,
                                    label: 'P',
                                    
                                    onPressed: (context) {
                                      confirmarEdicion(context, evento).then((confirmaEditProx) {
                                      if (confirmaEditProx) {
                                       setState(() {
                                            FirestoreService().cambiarEstadoEvento(evento.id,'proximamente');                  
                                        }
                                        );
                                       }
                                        },
                                      );
                                      
                                    },
                                  ),
                                ),
                              ],
                            ),
                            child: ListTile(
                              leading: Icon(MdiIcons.partyPopper,color: Colors.redAccent,),
                              title: Text(evento['nombre']),
                              subtitle: Text(evento['estado']),
                  
                              onLongPress: () {
                                monstrarInfoEvento(context, evento);
                                                                
                              },
                            ),
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
      floatingActionButton: Container(
        padding: EdgeInsets.only(left: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            FloatingActionButton.extended(
              backgroundColor: Colors.red,
              label: Text('Nuevo Evento'),
              icon: Icon(MdiIcons.receiptTextPlusOutline,size: 35,),
              onPressed: () {
                MaterialPageRoute route = MaterialPageRoute(builder: (context) => AgregarEventosPage());
                Navigator.push(context, route);
              },
            ),
          ],
        ),
      ),
    );
  }
  Future<dynamic> confirmarBorrado(BuildContext context, evento) {
    return showDialog(
      barrierDismissible: false,
      context: Key1.currentContext!,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmar Borrado'),
          content: Text('¿Desea confirmar borrar el evento ${evento['nombre']}?'),
          actions: [
            TextButton(
              child: Text('NO'),
              onPressed: () => Navigator.pop(context, false),
            ),
            ElevatedButton(
              child: Text('SI'),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        );
      },
    );
  }
   
  Future<dynamic> confirmarEdicion(BuildContext context, evento) {
    return showDialog(
      barrierDismissible: false,
      context: Key1.currentContext!,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmar Edicion'),
          content: Text('¿Desea editar el estado ${evento['estado']} del evento ${evento['nombre']}?'),
          actions: [
            TextButton(
              child: Text('NO'),
              onPressed: () => Navigator.pop(context, false),
            ),
            ElevatedButton(
              child: Text('SI'),
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        );
      },
    );
  }
}