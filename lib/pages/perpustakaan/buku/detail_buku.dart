import 'package:flutter/material.dart';
import 'package:flutter_api/models/kategori_model.dart';
import 'package:flutter_api/pages/perpustakaan/kategori/edit_kategori.dart';
import 'package:flutter_api/services/kategori_service.dart';

class KategoriDetail extends StatefulWidget {
  final DataKategori post;

  const KategoriDetail({Key? key, required this.post}) : super(key: key);

  @override
  State<KategoriDetail> createState() => _KategoriDetailState();
}

class _KategoriDetailState extends State<KategoriDetail> {
  bool _isLoading = false;

  Future<void> _deletePost() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Hapus Kategori"),
        content: Text('Yakin ingin menghapus "${widget.post.nama}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Hapus"),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _isLoading = true);
      final success = await KategoriService.deletePost(widget.post.id!);
      if (success && mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Kategori berhasil dihapus")));
      }
      setState(() => _isLoading = false);
    }
  }

  String _formatDate(DateTime date) =>
      "${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Kategori'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _isLoading ? null : _deletePost,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.post.nama ?? 'Tidak ada nama kategori',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (widget.post.createdAt != null)
              Text(
                _formatDate(widget.post.createdAt!),
                style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.edit),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EditKategori(post: widget.post),
            ),
          );
          if (result == true && mounted) {
            Navigator.pop(context, true);
          }
        },
      ),
    );
  }
}
