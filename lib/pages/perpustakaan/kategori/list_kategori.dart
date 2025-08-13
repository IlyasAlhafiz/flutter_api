import 'package:flutter/material.dart';
import 'package:flutter_api/models/kategori_model.dart';
import 'package:flutter_api/services/kategori_service.dart';
import 'package:flutter_api/pages/perpustakaan/kategori/detail_kategori.dart';
import 'package:flutter_api/pages/perpustakaan/kategori/create_kategori.dart';

class ListKategori extends StatefulWidget {
  const ListKategori({super.key});

  @override
  State<ListKategori> createState() => _ListKategoriState();
}

class _ListKategoriState extends State<ListKategori> {
  late Future<KategoriModel> _futureKategori;

  @override
  void initState() {
    super.initState();
    _futureKategori = KategoriService.listPosts();
  }

  void _refreshKategori() {
    setState(() {
      _futureKategori = KategoriService.listPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Kategori'),
        actions: [
          IconButton(onPressed: _refreshKategori, icon: const Icon(Icons.refresh)),
          IconButton(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreateKategori()),
              );
              if (result == true) _refreshKategori();
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder<KategoriModel>(
        future: _futureKategori,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final kategoriList = snapshot.data?.data ?? [];
          if (kategoriList.isEmpty) {
            return const Center(child: Text('Tidak ada kategori'));
          }

          return ListView.builder(
            itemCount: kategoriList.length,
            itemBuilder: (context, index) {
              final kategori = kategoriList[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  title: Text(kategori.nama ?? 'Tanpa Nama'),
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => KategoriDetail(post: kategori),
                      ),
                    );
                    if (result == true) _refreshKategori();
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
