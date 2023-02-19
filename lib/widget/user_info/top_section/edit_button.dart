import 'package:flutter/material.dart';

class EditButton extends StatelessWidget {
  final Function() onEdit;

  const EditButton({
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: onEdit == null ? 0.5 : 1.0,
      child:Container(
          width: 36,
          height: 36  ,
          child: Material(
              color: Color(0xFFECECEC),
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
              child: InkWell(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                onTap: onEdit,
                child: Icon(

                  Icons.edit,
                  color: Color(0xFF212121),

                ),
              )
          )

      ),
    );
  }
}