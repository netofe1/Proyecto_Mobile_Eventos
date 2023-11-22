

import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {

  Future<void> eventosAgregar(String nombre, String descripcion,String lugar, String tipo, String estado,Timestamp fechaYHoraTimestamp,int cont) async {
    return FirebaseFirestore.instance.collection('Eventos').doc().set({
      'nombre': nombre,
      'descripcion': descripcion,
      'lugar': lugar,
      'tipo': tipo,
      'estado': estado,
      'fechaYHora': fechaYHoraTimestamp,
      'cont':cont,

      
    });
  }

  
  Stream<QuerySnapshot> Eventos() {
    //return FirebaseFirestore.instance.collection('Eventos').snapshots();
    return FirebaseFirestore.instance.collection('Eventos').orderBy('nombre').snapshots();
    // return FirebaseFirestore.instance.collection('estudiantes').get()
  }

  Future<void> eventosBorrar(String docId) async {
    return FirebaseFirestore.instance.collection('Eventos').doc(docId).delete();
  }

  Future<QuerySnapshot> TipoEventos() async {
    return FirebaseFirestore.instance.collection('Tipo_Evento').orderBy('tipo').get();
  }


  Future<void> Incremento(String docId) async{
    return FirebaseFirestore.instance.collection('Eventos').doc(docId).update({'cont': FieldValue.increment(1)});

  }
  Future<void> ActualizarEstadoEvento(String docId) async{
    return FirebaseFirestore.instance.collection('Eventos').doc(docId).update({'estado': 'finalizado'});

  }
  Stream<QuerySnapshot> FiltrarEventos(String respuesta) {
  if (respuesta == 'todos') {
    return FirebaseFirestore.instance.collection('Eventos').snapshots();
  } else if (respuesta == 'finalizado') {
    return FirebaseFirestore.instance.collection('Eventos').where('estado', isEqualTo: 'finalizado').snapshots();
  } else if (respuesta == 'proximamente') {
    return FirebaseFirestore.instance.collection('Eventos').where('estado', isEqualTo: 'proximamente').snapshots();
  }

  return FirebaseFirestore.instance.collection('Eventos').snapshots();
}
  
  

  Future<void> cambiarEstadoEvento(String docId, String nuevoEstado) async {
    return FirebaseFirestore.instance.collection('Eventos').doc(docId).update({
      'estado': nuevoEstado,
    }); 
  }

  }



  




