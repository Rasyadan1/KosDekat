
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/kos.dart';

class KosCard extends StatelessWidget {
  final Kos kos;
  final VoidCallback? onTap;

  const KosCard({
    super.key,
    required this.kos,
    this.onTap,
  });

  String formatRupiah(int harga) {
    final formatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );

    return '${formatter.format(harga)}/bln';
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar sementara
              Container(
                width: 100,
                height: 110,
                decoration: BoxDecoration(
                  color: colors.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.home_work_outlined,
                  size: 42,
                  color: colors.onPrimaryContainer,
                ),
              ),

              const SizedBox(width: 14),

              // Informasi kos
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      kos.nama,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),

                    const SizedBox(height: 5),

                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 16,
                          color: colors.secondary,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(kos.area),
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        Chip(
                          label: Text(kos.tipe),
                          visualDensity: VisualDensity.compact,
                        ),
                        if (kos.kamarMandiDalam)
                          const Chip(
                            label: Text('KM Dalam'),
                            visualDensity: VisualDensity.compact,
                          ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    Text(
                      formatRupiah(kos.hargaBulanan),
                      style: TextStyle(
                        color: colors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      '${kos.jarakKm} km dari Telkom University',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
