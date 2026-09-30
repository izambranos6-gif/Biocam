part of '../main.dart';

// =============================================================
    // INICIO
    // =============================================================

    class InicioPage extends StatelessWidget {
      final VoidCallback abrirBiomasa;
      final VoidCallback abrirPescas;
      final VoidCallback actualizar;

      const InicioPage({
        super.key,
        required this.abrirBiomasa,
        required this.abrirPescas,
        required this.actualizar,
      });

      int get pendientes {
        return AppData.pescas
            .where((p) => p.estadoPago != 'Pagado')
            .length;
      }

      int get pagadas {
        return AppData.pescas
            .where((p) => p.estadoPago == 'Pagado')
            .length;
      }

      Pesca? get ultimaPesca {
        if (AppData.pescas.isEmpty) return null;

        final lista = List<Pesca>.from(AppData.pescas)
          ..sort((a, b) {
            final porFecha = b.fecha.compareTo(a.fecha);
            if (porFecha != 0) return porFecha;
            return b.id.compareTo(a.id);
          });

        return lista.first;
      }

      Color colorEstado(String estado) {
        switch (estado) {
          case 'Pagado':
            return AppColors.mint;
          case 'Pago parcial':
            return AppColors.lavender;
          case 'Pendiente':
            return const Color(0xFFFFE3A3);
          default:
            return const Color(0xFFE7E7EA);
        }
      }

      Future<void> abrirUltimaPesca(
        BuildContext context,
        Pesca pesca,
      ) async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetallePescaPage(
              pesca: pesca,
            ),
          ),
        );

        actualizar();
      }

      @override
      Widget build(BuildContext context) {
        final reciente = ultimaPesca;

        return SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tarjeta principal de identidad de Biocam.
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.dark,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: 22,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: Transform.translate(
                            offset: const Offset(0, -10),
                            child: SizedBox(
                              width: 100,
                              height: 100,
                              child: Image.asset(
                                'assets/images/camaron_das.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(right: 112),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'BIOCAM',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.4,
                              ),
                            ),
                            SizedBox(height: 9),
                            Text(
                              'Tu control diario',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            SizedBox(height: 6),
                            Text(
                              'Control de biomasa y pescas',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  'Resumen',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 11),

                Row(
                  children: [
                    Expanded(
                      child: tarjetaResumenBonita(
                        icono: Icons.waves,
                        valor: '${AppData.pescas.length}',
                        titulo: 'Pescas',
                        fondo: AppColors.mint,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: tarjetaResumenBonita(
                        icono: Icons.check_rounded,
                        valor: '$pagadas',
                        titulo: 'Liquidadas',
                        fondo: const Color(0xFFE9F7EF),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: tarjetaResumenBonita(
                        icono: Icons.schedule_rounded,
                        valor: '$pendientes',
                        titulo: 'Pendientes',
                        fondo: const Color(0xFFFFF1D6),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                const Text(
                  'Acciones rápidas',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 11),

                Row(
                  children: [
                    Expanded(
                      child: accesoRapidoBonito(
                        icono: Icons.bar_chart_rounded,
                        titulo: 'Biomasa',
                        descripcion: 'Calcular',
                        oscuro: false,
                        onTap: abrirBiomasa,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: accesoRapidoBonito(
                        icono: Icons.add_rounded,
                        titulo: 'Nueva pesca',
                        descripcion: 'Registrar',
                        oscuro: true,
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const NuevaPescaPage(),
                            ),
                          );
                          actualizar();
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                const Text(
                  'Actividad reciente',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 11),

                if (reciente == null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.waves,
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Todavía no tienes pescas registradas.',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  InkWell(
                    borderRadius: BorderRadius.circular(24),
                    onTap: () => abrirUltimaPesca(context, reciente),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.dark,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: AppColors.mint,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: const Icon(
                                  Icons.waves,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      reciente.persona,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      formatoFecha(reciente.fecha),
                                      style: const TextStyle(
                                        color: Colors.white60,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 9,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: colorEstado(reciente.estadoPago),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  reciente.estadoPago,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Container(
                            padding: const EdgeInsets.all(13),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.07),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'PESO',
                                        style: TextStyle(
                                          color: Colors.white38,
                                          fontSize: 9,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${formatoNumero(reciente.pesoTotal)} ${reciente.unidad}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: 1,
                                  height: 34,
                                  color: Colors.white12,
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'SALDO',
                                        style: TextStyle(
                                          color: Colors.white38,
                                          fontSize: 9,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        reciente.liquidada
                                            ? formatoDinero(reciente.saldoPendiente)
                                            : 'Sin liquidar',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.chevron_right_rounded,
                                  color: Colors.white54,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      }
    }

    Widget tarjetaResumenBonita({
      required IconData icono,
      required String valor,
      required String titulo,
      required Color fondo,
    }) {
      return Container(
        padding: const EdgeInsets.fromLTRB(12, 13, 10, 13),
        decoration: BoxDecoration(
          color: fondo,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.72),
                borderRadius: BorderRadius.circular(11),
              ),
              child: Icon(
                icono,
                size: 18,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              valor,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 1),
            Text(
              titulo,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      );
    }

    Widget accesoRapidoBonito({
      required IconData icono,
      required String titulo,
      required String descripcion,
      required bool oscuro,
      required VoidCallback onTap,
    }) {
      final fondo = oscuro ? AppColors.dark : Colors.white;
      final texto = oscuro ? Colors.white : AppColors.text;
      final secundario =
          oscuro ? Colors.white60 : AppColors.textSecondary;

      return InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 128),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: fondo,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.mint,
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(
                      icono,
                      color: Colors.black,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: secundario,
                    size: 19,
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                titulo,
                style: TextStyle(
                  color: texto,
                  fontSize: 15,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                descripcion,
                style: TextStyle(
                  color: secundario,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      );
    }
