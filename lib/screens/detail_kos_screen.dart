
import 'package:flutter/material.dart';
import 'package:kosdekat/screens/ulasan_screen.dart';

import '../models/kos.dart';
import '../models/ulasan.dart';

class DetailKosScreen extends StatefulWidget {
  final Kos kos;
  final bool isFavorite;
  final ValueChanged<bool> onFavoriteChanged;
  final List<Ulasan> ulasanList;
  final ValueChanged<List<Ulasan>> onUlasanChanged;

  const DetailKosScreen({
  super.key,
  required this.kos,
  required this.isFavorite,
  required this.onFavoriteChanged,
  required this.ulasanList,
  required this.onUlasanChanged,
});

  @override
  State<DetailKosScreen> createState() => _DetailKosScreenState();
}

class _DetailKosScreenState extends State<DetailKosScreen> {

  
Future<void> tambahUlasan() async {
  final hasil = await Navigator.push<Ulasan>(
    context,
    MaterialPageRoute(
      builder: (context) => UlasanFormScreen(
        namaKos: widget.kos.nama,
      ),
    ),
  );

  if (!mounted) return;

  if (hasil != null) {
    final ulasanTerbaru = [
      hasil,
      ...widget.ulasanList,
    ];

    widget.onUlasanChanged(ulasanTerbaru);

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ulasan berhasil ditambahkan.'),
      ),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    final kos = widget.kos;
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Kos'),
        actions: [
          IconButton(
            onPressed: () {
              widget.onFavoriteChanged(!widget.isFavorite);
              setState(() {});
            },
            icon: Icon(
              widget.isFavorite
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: widget.isFavorite ? Colors.red : null,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: colors.primaryContainer,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(
              Icons.home_work_outlined,
              size: 80,
              color: colors.onPrimaryContainer,
            ),
          ),

          const SizedBox(height: 20),

          Text(
            kos.nama,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),

          const SizedBox(height: 8),

          Text('${kos.area} • ${kos.jarakKm} km dari Telkom University'),

          const SizedBox(height: 16),

          Text(
            'Rp${kos.hargaBulanan.toString()}/bln',
            style: TextStyle(
              color: colors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),

          const Divider(height: 32),

          Text(
            'Informasi Kos',
            style: Theme.of(context).textTheme.titleLarge,
          ),

          const SizedBox(height: 12),

          ListTile(
            leading: const Icon(Icons.people_outline),
            title: const Text('Tipe Kos'),
            subtitle: Text(kos.tipe),
          ),

          ListTile(
            leading: const Icon(Icons.bathroom_outlined),
            title: const Text('Kamar Mandi'),
            subtitle: Text(
              kos.kamarMandiDalam ? 'Kamar mandi dalam' : 'Kamar mandi luar',
            ),
          ),

          const Divider(height: 32),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Ulasan Pengguna',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              TextButton.icon(
                onPressed: tambahUlasan,
                icon: const Icon(Icons.add),
                label: const Text('Tulis'),
              ),
            ],
          ),

          if (widget.ulasanList.isEmpty)
            const Padding(
              padding: EdgeInsets.all(20),
              child: Center(
                child: Text('Belum ada ulasan untuk kos ini.'),
              ),
            )
          else
            ...widget.ulasanList.map((ulasan) {
              return Card(
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  title: Text(ulasan.namaPengguna),
                  subtitle: Text(ulasan.komentar),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 18,
                      ),
                      Text('${ulasan.rating}'),
                    ],
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}
