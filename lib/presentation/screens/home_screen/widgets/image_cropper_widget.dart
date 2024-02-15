import 'dart:io';
import 'dart:math';

import 'package:custom_image_crop/custom_image_crop.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ImageCropperWidget extends StatefulWidget {
  final String imagePath;

  final String title;
  const ImageCropperWidget({Key? key, required this.title, required this.imagePath})
      : super(key: key);

  @override
  ImageCropperWidgetState createState() => ImageCropperWidgetState();
}

class ImageCropperWidgetState extends State<ImageCropperWidget> {
  late CustomImageCropController controller;

  final CustomCropShape _currentShape = CustomCropShape.Ratio;
  final CustomImageFit _imageFit = CustomImageFit.fillCropSpace;

  final double _width = 16;
  final double _height = 9;
  final double _radius = 4;

  @override
  void initState() {
    super.initState();
    controller = CustomImageCropController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Column(
        children: [
          Expanded(
            child: CustomImageCrop(
              cropController: controller,
              image: FileImage(File(widget.imagePath)),
              shape: _currentShape,
              ratio: _currentShape == CustomCropShape.Ratio
                  ? Ratio(width: _width, height: _height)
                  : null,
              canRotate: true,
              canMove: true,
              canScale: true,
              borderRadius:
                  _currentShape == CustomCropShape.Ratio ? _radius : 0,
              customProgressIndicator: const CupertinoActivityIndicator(),
              imageFit: _imageFit,
              pathPaint: Paint()
                ..color = Colors.white
                ..strokeWidth = 2.0
                ..style = PaintingStyle.stroke
                ..strokeJoin = StrokeJoin.round,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                    icon: const Icon(Icons.refresh),
                    onPressed: controller.reset),
                IconButton(
                  icon: const Icon(Icons.zoom_in),
                  onPressed: () => controller.addTransition(
                    CropImageData(scale: 1.33),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.zoom_out),
                  onPressed: () => controller.addTransition(
                    CropImageData(scale: 0.75),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.rotate_left),
                  onPressed: () => controller.addTransition(
                    CropImageData(angle: -pi / 4),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.rotate_right),
                  onPressed: () => controller.addTransition(
                    CropImageData(angle: pi / 4),
                  ),
                ),
                const SizedBox(width: 16.0),
                FilledButton(
                  onPressed: () {
                    controller.onCropImage().then((image) {
                      if (image != null) {
                        debugPrint('se termino de procesar la imagen');
                        Navigator.pop(context, image.bytes);
                      }
                    });
                  },
                  child: const Text(
                    'Continuar',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
