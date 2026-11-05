
import 'package:flutter/material.dart';
import '../models/ulasan.dart';

class UlasanFormScreen extends StatefulWidget {
  final String namaKos;

  const UlasanFormScreen({
    super.key,
    required this.namaKos,
  });

  @override
  State<UlasanFormScreen> createState() => _UlasanFormScreenState();
}

class _UlasanFormScreenState extends State<UlasanFormScreen> {
  final TextEditingController namaController = TextEditingController();
  final TextEditingController komentarController = TextEditingController();

  int rating = 5;

  void kirimUlasan() {
    if (namaController.text.trim().isEmpty ||
        komentarController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nama dan komentar wajib diisi.'),
        ),
      );
      return;
    }

    final ulasan = Ulasan(
      namaPengguna: namaController.text.trim(),
      rating: rating,
      komentar: komentarController.text.trim(),
      tanggal: DateTime.now(),
    );

    Navigator.pop(context, ulasan);
  }

  @override
  void dispose() {
    namaController.dispose();
    komentarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tulis Ulasan'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Ulasan untuk ${widget.namaKos}',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),

          const SizedBox(height: 24),

          const Text(
            'Berikan Rating',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return IconButton(
                onPressed: () {
                  setState(() {
                    rating = index + 1;
                  });
                },
                icon: Icon(
                  index < rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 36,
                ),
              );
            }),
          ),

          Center(
            child: Text('$rating dari 5 bintang'),
          ),

          const SizedBox(height: 24),

          TextField(
            controller: namaController,
            decoration: const InputDecoration(
              labelText: 'Nama pengguna',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person_outline),
            ),
          ),

          const SizedBox(height: 16),

          TextField(
            controller: komentarController,
            maxLines: 5,
            decoration: const InputDecoration(
              labelText: 'Tulis komentar kamu',
              hintText: 'Bagaimana pengalamanmu dengan kos ini?',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
          ),

          const SizedBox(height: 24),

          FilledButton.icon(
            onPressed: kirimUlasan,
            icon: const Icon(Icons.send),
            label: const Text('Kirim Ulasan'),
          ),
        ],
      ),
    );
  }
}
