import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CheckPage extends StatefulWidget {
  const CheckPage({Key? key}) : super(key: key);

  @override
  State<CheckPage> createState() => _CheckPageState();
}

class _CheckPageState extends State<CheckPage> {
  CameraController? _cameraController;
  late List<CameraDescription> _cameras;
  bool _isCameraInitialized = false;
  bool _isFlashOn = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    _cameraController = CameraController(
      _cameras[0], // kamera belakang
      ResolutionPreset.medium,
      enableAudio: false,
    );
    await _cameraController!.initialize();
    setState(() => _isCameraInitialized = true);
  }

  Future<void> _takePicture() async {
    if (!_cameraController!.value.isInitialized) return;

    final image = await _cameraController!.takePicture();
    // Simulasikan ke halaman hasil deteksi
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ImagePreviewScreen(imagePath: image.path),
      ),
    );
  }

  void _toggleFlash() async {
    _isFlashOn = !_isFlashOn;
    await _cameraController!.setFlashMode(
      _isFlashOn ? FlashMode.torch : FlashMode.off,
    );
    setState(() {});
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isCameraInitialized
          ? Stack(
              children: [
                CameraPreview(_cameraController!),

                // Border panduan scan
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 250,
                    height: 350,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 4),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),

                // AppBar Deteksi
                Positioned(
                  top: 40,
                  left: 16,
                  right: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.arrow_back, color: Colors.purple),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Deteksi',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),

                // Tombol kontrol bawah
                Positioned(
                  bottom: 30,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.image, color: Colors.white),
                        onPressed: () {
                          // implementasi galeri nanti
                        },
                      ),
                      GestureDetector(
                        onTap: _takePicture,
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            border: Border.all(color: Colors.purple, width: 5),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          _isFlashOn ? Icons.flash_on : Icons.flash_off,
                          color: Colors.white,
                        ),
                        onPressed: _toggleFlash,
                      ),
                    ],
                  ),
                )
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}

// Halaman setelah ambil gambar
class ImagePreviewScreen extends StatefulWidget {
  final String imagePath;

  const ImagePreviewScreen({super.key, required this.imagePath});

  @override
  State<ImagePreviewScreen> createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen> {
  String? _predictionLabel;
  String? _description;
  double? _confidence;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _sendImageToServer();
  }

  Future<void> _sendImageToServer() async {
    try {
      var uri = Uri.parse('https://08b7-103-149-71-10.ngrok-free.app/predict'); // ganti <IP_ADDRESS> dengan IP lokal
      var request = http.MultipartRequest('POST', uri);
      request.files.add(await http.MultipartFile.fromPath('file', widget.imagePath));

      var response = await request.send();
      var responseData = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        var result = json.decode(responseData.body);

        setState(() {
          _predictionLabel = result['class'];
          _confidence = result['confidence'];
          _description = result['description'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _predictionLabel = "Gagal mendapatkan prediksi: ${responseData.body}";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _predictionLabel = "Terjadi kesalahan: $e";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hasil Foto")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          Center(child: Image.file(File(widget.imagePath), height: 300)),
          const SizedBox(height: 24),
          _isLoading
              ? const CircularProgressIndicator()
              : _predictionLabel != null
                  ? Column(
                      children: [
                        Text(
                          "Prediksi: $_predictionLabel",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (_confidence != null)
                          Text(
                            "Tingkat Keyakinan: ${(_confidence! * 100).toStringAsFixed(2)}%",
                            style: const TextStyle(fontSize: 16),
                          ),
                        const SizedBox(height: 12),
                        if (_description != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              _description!,
                              textAlign: TextAlign.justify,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                      ],
                    )
                  : const Text("Prediksi tidak ditemukan."),
        ],
      ),
    );
  }
}
