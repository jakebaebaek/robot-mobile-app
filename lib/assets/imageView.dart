import 'package:flutter/material.dart';

class ImageView extends StatelessWidget{
  final String src;
  const ImageView({Key? key, required this.src}) : super(key: key);
  
  //Scale should be calculated through device width or height.
  @override
  Widget build(BuildContext context) {
    return Image.network(src, scale: 1,);
  }
}