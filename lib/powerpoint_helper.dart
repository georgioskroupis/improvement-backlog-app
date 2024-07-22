import 'dart:io';
import 'dart:typed_data'; // Import for ByteData
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_pptx/flutter_pptx.dart';
import 'package:path_provider/path_provider.dart';
import 'improvement_item.dart';

class PowerPointHelper {
  static Future<File> createPowerPoint(ImprovementItem item) async {
    final pptx = FlutterPowerPoint();

    // Load the image asset
    ByteData imageData = await rootBundle.load('assets/improvement_canvas.jpg');
    final buffer = imageData.buffer.asUint8List();

    // Create a temporary file for the image
    final tempDir = await getTemporaryDirectory();
    final imageFile = File('${tempDir.path}/improvement_canvas.jpg');
    await imageFile.writeAsBytes(buffer);

    // Create a new slide using widgets with a background image
    await pptx.addWidgetSlide((size) => Stack(
          children: [
            Positioned.fill(
              child: Image.file(
                imageFile,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              left: 100,
              top: 100,
              child: Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent, width: 2.0),
                  color: Colors.white,
                ),
                child: Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 100,
              top: 150,
              child: Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent, width: 2.0),
                  color: Colors.white,
                ),
                child: Text(
                  'Champion: ${item.champion}',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 100,
              top: 200,
              child: Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent, width: 2.0),
                  color: Colors.white,
                ),
                child: Text(
                  'Issue: ${item.issue}',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 100,
              top: 250,
              child: Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent, width: 2.0),
                  color: Colors.white,
                ),
                child: Text(
                  'Improvement: ${item.improvement}',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Positioned(
              left: 100,
              top: 300,
              child: Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent, width: 2.0),
                  color: Colors.white,
                ),
                child: Text(
                  'Outcome: ${item.outcome}',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ));

    // Save the PowerPoint file
    final outputDir = await getTemporaryDirectory();
    final outputFile = File('${outputDir.path}/ImprovementItem.pptx');
    final bytes = await pptx.save();

    // Ensure the bytes are not null and convert them to List<int>
    if (bytes != null) {
      await outputFile.writeAsBytes(bytes.toList());
    } else {
      throw Exception('Failed to generate PowerPoint file.');
    }

    return outputFile;
  }
}
