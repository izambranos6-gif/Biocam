part of '../../main.dart';

// =============================================================
    // MIS PESCAS
    // =============================================================

    class HistorialPage extends StatefulWidget {
      final VoidCallback actualizarPrincipal;

      const HistorialPage({
        super.key,
        required this.actualizarPrincipal,
      });

      @override
      State<HistorialPage> createState() =>
          _HistorialPageState();
    }

    class _HistorialPageState
        extends State<HistorialPage> {
      final buscarController =
          TextEditingController();

      String filtroEstado = 'Todas';
      DateTime? filtroFecha;

      List<Pesca> get pescasFiltradas {
        List<Pesca> resultado =
            List.from(AppData.pescas);

        final texto =
            buscarController.text
                .trim()
                .toLowerCase();

        if (texto.isNotEmpty) {
          resultado = resultado.where(
            (pesca) {
              return pesca.persona
                  .toLowerCase()
                  .contains(texto);
            },
          ).toList();
        }

        if (filtroEstado ==
            'Sin liquidar') {
          resultado = resultado
              .where((p) => !p.liquidada)
              .toList();
        }

        if (filtroEstado ==
            'Pendiente') {
          resultado = resultado
              .where(
                (p) =>
                    p.liquidada &&
                    p.totalPagado <= 0,
              )
              .toList();
        }

        if (filtroEstado ==
            'Pago parcial') {
          resultado = resultado
              .where(
                (p) =>
                    p.liquidada &&
                    p.totalPagado > 0 &&
                    p.saldoPendiente >
                        0.01,
              )
              .toList();
        }

        if (filtroEstado ==
            'Pagadas') {
          resultado = resultado
              .where(
                (p) =>
                    p.liquidada &&
                    p.saldoPendiente <=
                        0.01,
              )
              .toList();
        }

        if (filtroFecha != null) {
          resultado = resultado
              .where(
                (p) => mismaFecha(
                  p.fecha,
                  filtroFecha!,
                ),
              )
              .toList();
        }

        return resultado;
      }

      Future<void> seleccionarFecha() async {
        final seleccion =
            await showDatePicker(
          context: context,
          initialDate:
              filtroFecha ?? DateTime.now(),
          firstDate: DateTime(2020),
          lastDate: DateTime(2100),
        );

        if (seleccion != null) {
          setState(() {
            filtroFecha = seleccion;
          });
        }
      }

      void limpiarFiltros() {
        buscarController.clear();

        setState(() {
          filtroEstado = 'Todas';
          filtroFecha = null;
        });
      }

      @override
      Widget build(BuildContext context) {
        final resultados =
            pescasFiltradas;

        return SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Pescas',
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const NuevaPescaPage()),
                        );
                        setState(() {});
                        widget.actualizarPrincipal();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.black,
                        foregroundColor: Colors.white,
                      ),
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Nueva pesca'),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(
                  18,
                  4,
                  18,
                  8,
                ),
                child: tarjetaClara(
                  child: Column(
                    children: [
                      TextField(
                        controller: buscarController,
                        onChanged: (_) {
                          setState(() {});
                        },
                        decoration: inputClaro(
                          'Buscar por nombre',
                          Icons.search,
                        ),
                      ),

                      const SizedBox(height: 10),

                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 46,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: Colors.black26,
                                ),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  value: filtroEstado,
                                  isExpanded: true,
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down_rounded,
                                  ),
                                  selectedItemBuilder: (context) {
                                    return [
                                      'Todas',
                                      'Sin liquidar',
                                      'Pendiente',
                                      'Pago parcial',
                                      'Pagadas',
                                    ].map(
                                      (item) {
                                        return Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Estado: $item',
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 11,
                                              color: AppColors.text,
                                            ),
                                          ),
                                        );
                                      },
                                    ).toList();
                                  },
                                  items: [
                                    'Todas',
                                    'Sin liquidar',
                                    'Pendiente',
                                    'Pago parcial',
                                    'Pagadas',
                                  ].map(
                                    (item) {
                                      return DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: const TextStyle(
                                            fontSize: 11,
                                          ),
                                        ),
                                      );
                                    },
                                  ).toList(),
                                  onChanged: (value) {
                                    if (value != null) {
                                      setState(() {
                                        filtroEstado = value;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 8),

                          Expanded(
                            child: SizedBox(
                              height: 46,
                              child: OutlinedButton.icon(
                                onPressed: seleccionarFecha,
                                icon: const Text(
                                  '📅',
                                ),
                                label: Text(
                                  filtroFecha == null
                                      ? 'Todas las fechas'
                                      : formatoFecha(
                                          filtroFecha!,
                                        ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 4),

                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${resultados.length} pescas encontradas',
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: limpiarFiltros,
                            child: const Text(
                              'Limpiar',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 6),

              Expanded(
                child: ListView.builder(
                  padding:
                      const EdgeInsets.fromLTRB(
                    18,
                    3,
                    18,
                    95,
                  ),
                  itemCount:
                      resultados.length,
                  itemBuilder:
                      (context, index) {
                    final pesca =
                        resultados[index];

                    return Padding(
                      padding:
                          const EdgeInsets.only(
                        bottom: 9,
                      ),
                      child: InkWell(
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  DetallePescaPage(
                                pesca: pesca,
                              ),
                            ),
                          );

                          setState(() {});
                          widget
                              .actualizarPrincipal();
                        },
                        child: Container(
                          padding:
                              const EdgeInsets.all(
                            14,
                          ),
                          decoration:
                              BoxDecoration(
                            color:
                                AppColors.dark,
                            borderRadius:
                                BorderRadius
                                    .circular(
                              22,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  iconoMenta(Icons.waves),
                                  const SizedBox(width: 11),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          pesca.persona.isEmpty
                                              ? 'Sin propietario'
                                              : pesca.persona,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w900,
                                            fontSize: 15,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          formatoFecha(pesca.fecha),
                                          style: const TextStyle(
                                            color: Colors.white54,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  estadoBadge(pesca.estadoPago),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.darkSoft,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: vistaPreviaDato(
                                            '🌊',
                                            'Piscina',
                                            pesca.piscina.trim().isEmpty
                                                ? 'Sin especificar'
                                                : pesca.piscina,
                                          ),
                                        ),
                                        Expanded(
                                          child: vistaPreviaDato(
                                            '🦐',
                                            'Gramaje',
                                            '${formatoNumero(pesca.gramaje)} g',
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 9),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: vistaPreviaDato(
                                            '📦',
                                            'Gavetas',
                                            '${pesca.totalGavetas}',
                                          ),
                                        ),
                                        Expanded(
                                          child: vistaPreviaDato(
                                            '⚖️',
                                            'Peso',
                                            '${formatoNumero(pesca.pesoTotal)} ${pesca.unidad}',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      pesca.liquidada
                                          ? '💰 Total: ${formatoDinero(pesca.totalPagar)}'
                                          : '💰 Sin liquidar',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  if (pesca.liquidada)
                                    Text(
                                      pesca.saldoPendiente <= 0.01
                                          ? 'Pagado: ${formatoDinero(pesca.totalPagado)}'
                                          : 'Saldo: ${formatoDinero(pesca.saldoPendiente)}',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  const SizedBox(width: 6),
                                  const Icon(
                                    Icons.chevron_right_rounded,
                                    color: Colors.white54,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }

    }