import 'dart:io';
import 'package:flutter/material.dart';
import '../db/db_detection.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> _detectionHistory = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final history = await DetectionDatabaseHelper.instance.getDetections();
    setState(() => _detectionHistory = history);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Riwayat Deteksi")),
      body: _detectionHistory.isEmpty
          ? const Center(child: Text("Belum ada data deteksi."))
          : ListView.builder(
              itemCount: _detectionHistory.length,
              itemBuilder: (context, index) {
                final data = _detectionHistory[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Image.file(
                      File(data['imagePath']),
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                    ),
                    title: Text(data['label']),
                    subtitle: Text(
                      "${(data['confidence'] * 100).toStringAsFixed(2)}%",
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
    );
  }
}
