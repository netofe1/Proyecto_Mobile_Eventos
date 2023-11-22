import 'package:ejemplo_validar_form/widget/Detalles_Evento.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

  final AssetImage fondo1 = AssetImage('assets/images/Fondo_Eventos.png');
  final formatoFecha = DateFormat('dd-MM-yyyy hh:mm');
void monstrarInfoEvento(BuildContext context, evento){
     showDialog(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 350,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(image: fondo1, fit: BoxFit.cover),
              color: Colors.lightBlue.shade50,
              border: Border.all(color: Colors.blue.shade900, width: 2),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
              ),
            ),
            padding: EdgeInsets.all(10),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(5, 0, 0, 10),
                  child: Text('Información del Evento', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color:Colors.white)),
                ),
                DetallesEvento(dato: 'Nombre Evento: ${evento['nombre']}', icono: MdiIcons.pacMan),
                DetallesEvento(dato: 'Descripcion: ${evento['descripcion']}', icono: MdiIcons.cardAccountDetailsStar),
                DetallesEvento(dato: 'Tipo Evento: ${evento['tipo']}', icono: MdiIcons.partyPopper),
                DetallesEvento(dato: 'Lugar: ${evento['lugar']}', icono: MdiIcons.eiffelTower),
                DetallesEvento(dato: 'Fecha Evento: ${formatoFecha.format(evento['fechaYHora'].toDate())}', icono: MdiIcons.calendarRange),
                DetallesEvento(dato: 'Likes: ${evento['cont'].toString()}', icono: Icons.favorite),
                Spacer(),
                Container(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(backgroundColor: Colors.white),
                    child: Text('Cerrar'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      
    );  
  }
  