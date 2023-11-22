import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ejemplo_validar_form/services/firestore_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class AgregarEventosPage extends StatefulWidget {
  const AgregarEventosPage({super.key});

  @override
  State<AgregarEventosPage> createState() => _AgregarEventosPageState();
}

class _AgregarEventosPageState extends State<AgregarEventosPage> {
  TextEditingController nombreCtrl = TextEditingController();
  TextEditingController descripcionCtrl = TextEditingController();
  TextEditingController lugarCtrl = TextEditingController();

  DateTime fechaSeleccionada = DateTime.now();
  TimeOfDay horaSeleccionada = TimeOfDay.now();
  Timestamp fecha = Timestamp.now();
  final int cont = 0;

 
  File? subirImagen;

  String tipo = '';
  String estado = 'proximamente';
  final AssetImage fondo = AssetImage('assets/images/Fondo_Eventos2.png');
  final Key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [  
            Icon(MdiIcons.firework,color: Colors.lightBlueAccent,size: 40,),       
            Text('Agregar Eventos',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.white),),
            Spacer(),
          ],
        ),
      ),
      body: 
      Form(
        
        key: Key,
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(image: fondo, fit: BoxFit.cover),
            ),
          child: ListView(
            children: [
              Divider(),
              //NOMBRE EVENTO
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black),                
                ),
                padding: EdgeInsets.symmetric(horizontal: 10),
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  keyboardType: TextInputType.name,
                  controller: nombreCtrl,
                  decoration: InputDecoration(
                    label: Text('Nombre del evento',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
                  ),
                  validator: (nombre) {
                    if (nombre!.isEmpty) {
                      return 'Indique el nombre';
                    }
                    return null;
                  },
                ),
              ),  
              Divider(),
              //DESCRIPCION   
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black),
                
                ),
                padding: EdgeInsets.symmetric(horizontal: 10),
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  controller: descripcionCtrl,
                  decoration: InputDecoration(
                    label: Text('Descripcion del Evento',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
                  ),
                  validator: (descripcion) {
                    if (descripcion!.isEmpty) {
                      return 'Indique la descripcion';
                    }
                    return null;
                  },
                ),
              ),  
              //lugar evento
              Divider(),
               Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.black),
                
                ),
                padding: EdgeInsets.symmetric(horizontal: 10),
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: TextFormField(
                  controller: lugarCtrl,
                  decoration: InputDecoration(
                    label: Text('Lugar del evento',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
                  ),
                  validator: (lugar) {
                    if (lugar!.isEmpty) {
                      return 'Indique el lugar';
                    }
                    return null;
                  },
                ),
              ),
            //fecha y hora
            Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Text('Fecha seleccionada: ${DateFormat('dd/MM/yyyy').format(fechaSeleccionada)}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text('Hora seleccionada: ${horaSeleccionada.format(context)}',style: TextStyle(fontSize: 20),
            ),
                      ],
                    ),
                    
                    Spacer(),
                    IconButton(
                      icon: Icon(MdiIcons.calendar),
                      onPressed: () {
                        _seleccionarFechaYHora(context);
                        


                      },
                    ),
                  ],
                ),
              ),

            //ESTADO DEL EVENTO
            Container(
                padding: EdgeInsets.symmetric(horizontal: 15),
                margin: EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Estado Evento',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
                    RadioListTile(
                      title: Text('Proximamente'),
                      value: 'proximamente',
                      groupValue: estado,
                      onChanged: (estadoSeleccionada) {
                        setState(() {
                          estado = estadoSeleccionada!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              //TIPO DE EVENTO
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              margin: EdgeInsets.symmetric(horizontal: 15),
              child: FutureBuilder(
                          future: FirestoreService().TipoEventos(),
                          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
                              return Text('Cargando Tipo de Eventos...');
                            } else {
                              var tipos = snapshot.data!.docs;
                              return DropdownButtonFormField<String>(
                                value: tipo == '' ? tipos[0]['tipo'] : tipo,
                                decoration: InputDecoration(
                                  labelText: 'Tipo de Eventos',
                                  labelStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20
                                  )
                                  ),                      
                                items: tipos.map<DropdownMenuItem<String>>((tip) {
                                  return DropdownMenuItem<String>(
                                    child: Text(tip['tipo']),
                                    value: tip['tipo'],
                                  );
                                }).toList(),
                                onChanged: (tipoSeleccionada) {
                                  setState(() {
                                    tipo = tipoSeleccionada!;
                                  });
                                },
                              );
                            }
                          }),
            ),
            //imagen
            subirImagen != null ? Image.file(subirImagen!): Container(
              margin: EdgeInsets.all(20),
              height: 200,
              width: double.infinity,
              color: Colors.blueGrey,
            ),
            Container(
                padding: EdgeInsets.fromLTRB(30, 0, 30, 10),
                margin: EdgeInsets.only(top: 20),
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: Text('Subir Imagen', style: TextStyle(color: Colors.white)),
                  onPressed: ()async {
                    final XFile? images = await getImage();
                    setState(() {
                      subirImagen = File(images!.path);

                    });
                    
                  },
                ),
              ),
            Container(
                margin: EdgeInsets.only(top: 30),
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  child: Text('Agregar Evento', style: TextStyle(color: Colors.white)),
                  onPressed: () async {
                    if (Key.currentState!.validate()) {
                      FirestoreService().eventosAgregar(
                        nombreCtrl.text.trim(),
                        descripcionCtrl.text.trim(),   
                        lugarCtrl.text.trim(),                      
                        tipo,
                        estado,
                        fecha,
                        cont,

                      );
                      
                      await uploadImage(subirImagen!);

                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> _seleccionarFechaYHora(BuildContext context) async {
    final DateTime? fechaSeleccionadaNueva = await showDatePicker(
      context: context,
      initialDate: fechaSeleccionada,
      firstDate: DateTime(2022),
      lastDate: DateTime(2025),
    );

    if (fechaSeleccionadaNueva != null) {
      final TimeOfDay? horaSeleccionadaNueva = await showTimePicker(
        context: context,
        initialTime: horaSeleccionada,
      );

      if (horaSeleccionadaNueva != null) {
        setState(() {
          fechaSeleccionada = fechaSeleccionadaNueva;
          horaSeleccionada = horaSeleccionadaNueva;
          final Timestamp fechaYHoraTimestamp = Timestamp.fromDate(
          DateTime(fechaSeleccionada.year, fechaSeleccionada.month, fechaSeleccionada.day, horaSeleccionada.hour, horaSeleccionada.minute),);
          fecha = fechaYHoraTimestamp;
        });
      }
    }
  }
  Future<XFile?> getImage() async{
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    return  image;

  }

  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<bool> uploadImage(File images) async{
    
    final String namefile = images.path.split("/").last;
    

    Reference ref = storage.ref().child("Imagenes").child(namefile);

    final UploadTask uploadTask = ref.putFile(images);

    final TaskSnapshot snapshot =await uploadTask.whenComplete(() => true);

    
    
    if (snapshot.state == TaskState.success){
        return true;
      } else{
        return false;
      }
    }
}

