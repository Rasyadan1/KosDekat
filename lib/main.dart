
import 'package:flutter/material.dart';
import 'package:kosdekat/models/ulasan.dart';
import 'package:kosdekat/themes/app_theme.dart';
import 'models/kos.dart';
import 'widgets/kos_card.dart';
import 'screens/detail_kos_screen.dart';

enum SortKos {
  harga,
  jarak
}

void main() {
  runApp(const KosDekatApp());
}

class KosDekatApp extends StatelessWidget {
  const KosDekatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KosDekat',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int selectedIndex = 0;

final Map<String, List<Ulasan>> ulasanKos = {};

@override
void dispose() {
  searchController.dispose();
  super.dispose();
}

Widget buildFavoritPage() {
  final kosFavorit = daftarKos
      .where((kos) => favoritIds.contains(kos.id))
      .toList();

  if (kosFavorit.isEmpty) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 60),
          SizedBox(height: 12),
          Text('Belum ada kos favorit.'),
        ],
      ),
    );
  }

  return ListView.builder(
    padding: const EdgeInsets.all(16),
    itemCount: kosFavorit.length,
    itemBuilder: (context, index) {
      final kos = kosFavorit[index];

      return KosCard(
        kos: kos,
        onTap: () {
          bukaDetailKos(kos);
        },
      );
    },
  );
}

final Set<String> favoritIds = {};

void bukaDetailKos(Kos kos) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => DetailKosScreen(
        kos: kos,
        isFavorite: favoritIds.contains(kos.id),

        ulasanList: ulasanKos.putIfAbsent(
          kos.id,
          () => [],
        ),

        onUlasanChanged: (ulasanBaru) {
          setState(() {
            ulasanKos[kos.id] = ulasanBaru;
          });
        },

        onFavoriteChanged: (isFavorite) {
          setState(() {
            if (isFavorite) {
              favoritIds.add(kos.id);
            } else {
              favoritIds.remove(kos.id);
            }
          });
        },
      ),
    ),
  );
}


final List<Kos> daftarKos = [
  Kos(
    id: 'K001',
    nama: 'Kost Harmoni',
    area: 'Sukapura',
    tipe: 'Putra',
    hargaBulanan: 1250000,
    kamarMandiDalam: true,
    jarakKm: 0.5,
    diperbarui: DateTime(2026, 11, 1),
  ),
  Kos(
    id: 'K002',
    nama: 'Kost Melati',
    area: 'Sukabirus',
    tipe: 'Putri',
    hargaBulanan: 950000,
    kamarMandiDalam: false,
    jarakKm: 0.8,
    diperbarui: DateTime(2026, 11, 2),
  ),
  Kos(
    id: 'K003',
    nama: 'Kost Bintang',
    area: 'Bojongsoang',
    tipe: 'Campur',
    hargaBulanan: 1500000,
    kamarMandiDalam: true,
    jarakKm: 1.2,
    diperbarui: DateTime(2026, 11, 3),
  ),
];

final TextEditingController searchController = TextEditingController();
String kataKunci = "";
String? tipeDipilih;
SortKos sortKos = SortKos.harga;

List<Kos> get kosTerfilter {
  List<Kos> hasil = daftarKos.where((kos) {
    final cocokKataKunci =
        kos.nama.toLowerCase().contains(kataKunci.toLowerCase()) ||
        kos.area.toLowerCase().contains(kataKunci.toLowerCase());

    final cocokTipe =
        tipeDipilih == null || kos.tipe == tipeDipilih;

    return cocokKataKunci && cocokTipe;
  }).toList();

  if (sortKos == SortKos.harga) {
    hasil.sort(
      (a, b) => a.hargaBulanan.compareTo(b.hargaBulanan),
    );
  } else {
    hasil.sort(
      (a, b) => a.jarakKm.compareTo(b.jarakKm),
    );
  }

  return hasil;
}

Widget buildCariPage() {
  final hasilKos = kosTerfilter;

  return Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Temukan Kos Impianmu',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),

        const SizedBox(height: 6),

        const Text(
          'Cari tempat tinggal nyaman di sekitar Telkom University.',
        ),

        const SizedBox(height: 18),

        // Pencarian
        TextField(
          controller: searchController,
          onChanged: (value) {
            setState(() {
              kataKunci = value;
            });
          },
          decoration: InputDecoration(
            hintText: 'Cari nama kos atau area...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: kataKunci.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      searchController.clear();
                      setState(() {
                        kataKunci = '';
                      });
                    },
                  )
                : null,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            filled: true,
          ),
        ),

        const SizedBox(height: 18),

        // Filter tipe kos
        Text(
          'Tipe Kos',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),

        const SizedBox(height: 10),

        
        SizedBox(
          width: double.infinity,
          child: SegmentedButton<String>(
            expandedInsets: EdgeInsets.zero,
            emptySelectionAllowed: true,
            showSelectedIcon: false,
            segments: const [
              ButtonSegment(
                value: 'Putra',
                label: SizedBox(
                  width: double.infinity,
                  child: Center(child: Text('Putra')),
                ),
              ),
              ButtonSegment(
                value: 'Putri',
                label: SizedBox(
                  width: double.infinity,
                  child: Center(child: Text('Putri')),
                ),
              ),
              ButtonSegment(
                value: 'Campur',
                label: SizedBox(
                  width: double.infinity,
                  child: Center(child: Text('Campur')),
                ),
              ),
            ],
            selected: tipeDipilih == null
                ? <String>{}
                : <String>{tipeDipilih!},
            onSelectionChanged: (selection) {
              setState(() {
                tipeDipilih =
                    selection.isEmpty ? null : selection.first;
              });
            },
          ),
        ),

        const SizedBox(height: 18),

        // Pengurutan
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Daftar Kos',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SegmentedButton<SortKos>(
              segments: const [
                ButtonSegment(
                  value: SortKos.harga,
                  icon: Icon(Icons.payments_outlined),
                  label: Text('Harga'),
                ),
                ButtonSegment(
                  value: SortKos.jarak,
                  icon: Icon(Icons.near_me_outlined),
                  label: Text('Jarak'),
                ),
              ],
              selected: {sortKos},
              onSelectionChanged: (selection) {
                setState(() {
                  sortKos = selection.first;
                });
              },
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Hasil pencarian
        Expanded(
          child: hasilKos.isEmpty
              ? const Center(
                  child: Text('Kos tidak ditemukan.'),
                )
              : ListView.builder(
                  itemCount: hasilKos.length,
                  itemBuilder: (context, index) {
                    final kos = hasilKos[index];

                    return KosCard(
                      kos: kos,
                      onTap: () {
                        bukaDetailKos(kos);
                      }
                    );
                  },
                ),
        ),
      ],
    ),
  );
}

List<Widget> get pages => [
  buildCariPage(),
  buildFavoritPage(),
  const Center(
    child: Text('Halaman Profil'),
  ),
];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'KosDekat',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: IndexedStack(
        index: selectedIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.search),
            label: 'Cari',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favorit',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
