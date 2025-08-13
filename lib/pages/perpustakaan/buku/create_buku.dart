import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_api/services/kategori_service.dart';

class CreateKategori extends StatefulWidget {
  const CreateKategori({Key? key}) : super(key: key);

  @override
  State<CreateKategori> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreateKategori> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();

  @override
  void dispose() {
    _namaController.dispose();
    super.dispose();
  }

  Future<void> _createKategori() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await KategoriService.createPost(
      _namaController.text,
    );

    if (success && mounted) {
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Post berhasil dibuat'),
            backgroundColor: Colors.green),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Gagal membuat post'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Post')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Title
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(labelText: 'Nama Kategori'),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Nama tidak boleh kosong' : null,
              ),
              const SizedBox(height: 16),

              // Submit

              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _createKategori,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Simpan',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
