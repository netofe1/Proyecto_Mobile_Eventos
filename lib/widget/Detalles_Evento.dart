import 'package:flutter/material.dart';

class DetallesEvento extends StatelessWidget {
  const DetallesEvento({
    super.key,
    required this.dato,
    required this.icono,
  });

  final String dato;
  final IconData icono;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(bottom: 3),
        width: double.infinity,
        padding: EdgeInsets.all(10),
        color: Colors.white,
        child: Row(
          children: [
            Icon(this.icono,size: 40,color: Colors.deepPurpleAccent,),
            Text('   '),
            Expanded(child: Text(' ' + this.dato,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),)),
          ],
        ),
      ),
    );
  }
}
