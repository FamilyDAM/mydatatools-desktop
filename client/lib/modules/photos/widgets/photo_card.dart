import 'dart:io' as io;

import 'package:client/models/module_models.dart';
import 'package:flutter/material.dart';
import 'package:progressive_image/progressive_image.dart';

class PhotoCard extends StatefulWidget {
  const PhotoCard({Key? key, required this.file, required this.width}) : super(key: key);

  final File file;
  final double width;

  @override
  State<PhotoCard> createState() => _PhotoCardState();
}

class _PhotoCardState extends State<PhotoCard> {
  @override
  Widget build(BuildContext context) {
    io.File fileRef = io.File(widget.file.path);
    return Column(
      children: [
        SizedBox(
            width: widget.width,
            height: widget.width,
            child: Stack(children: [
              ProgressiveImage(
                placeholder: const AssetImage('assets/placeholder.jpg'),
                // size: 1.87KB
                thumbnail: FileImage(fileRef),
                // size: 1.29MB
                image: FileImage(fileRef),
                fit: BoxFit.fitHeight,
                repeat: ImageRepeat.noRepeat,
                height: widget.width,
                width: widget.width,
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    height: widget.width / 4,
                    decoration: const BoxDecoration(color: Colors.black26),
                    child: Center(
                      child: Text(
                        widget.file.name,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ))
            ])),
      ],
    );
  }
}
