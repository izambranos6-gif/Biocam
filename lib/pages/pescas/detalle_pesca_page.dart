part of '../../main.dart';

// =============================================================
    // DETALLE DE PESCA
    // =============================================================

    class DetallePescaPage extends StatefulWidget {
      final Pesca pesca;

      const DetallePescaPage({
        super.key,
        required this.pesca,
      });

      @override
      State<DetallePescaPage> createState() =>
          _DetallePescaPageState();
    }

    class _DetallePescaPageState
        extends State<DetallePescaPage> {
      Future<void> editarPesca() async {
        final cambio =
            await Navigator.push<bool>(
          context,
          MaterialPageRoute(
            builder: (_) =>
                EditarPescaPage(
              pesca: widget.pesca,
            ),
          ),
        );

        if (cambio == true) {
          setState(() {});
        }
      }

      Future<void> liquidar() async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                LiquidacionPage(
              pesca: widget.pesca,
            ),
          ),
        );

        setState(() {});
      }

      Future<void> nuevoPago() async {
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PagoPage(
              pesca: widget.pesca,
            ),
          ),
        );

        setState(() {});
      }

      @override
      Widget build(BuildContext context) {
        final pesca = widget.pesca;

        return Scaffold(
          appBar: AppBar(
            title:
                const Text('Detalle de pesca'),
            actions: [
              IconButton(
                onPressed: editarPesca,
                icon: const Icon(
                  Icons.edit_outlined,
                ),
              ),
            ],
          ),

          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              18,
              4,
              18,
              30,
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                // ===================================================
                // INFORMACIÓN SUPERIOR
                // SOLO FECHA, PERSONA Y UNIDAD
                // ===================================================

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.dark,
                    borderRadius:
                        BorderRadius.circular(23),
                  ),
                  child: Column(
                    children: [
                      infoOscura(
                        Icons.calendar_month_outlined,
                        formatoFecha(
                          pesca.fecha,
                        ),
                      ),

                      const Divider(
                        color: Colors.white12,
                      ),

                      infoOscura(
                        Icons.person_outline,
                        pesca.persona.isEmpty
                            ? 'Sin propietario'
                            : pesca.persona,
                      ),

                      const Divider(
                        color: Colors.white12,
                      ),

                      infoOscura(
                        Icons.water_outlined,
                        'Piscina: ${pesca.piscina}',
                      ),

                      const Divider(color: Colors.white12),

                      infoOscura(
                        Icons.set_meal_outlined,
                        'Gramaje: ${formatoNumero(pesca.gramaje)} g',
                      ),

                      const Divider(color: Colors.white12),

                      infoOscura(
                        Icons.scale_outlined,
                        'Unidad: ${pesca.unidad}',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: editarPesca,
                    icon: const Icon(
                      Icons.edit_outlined,
                    ),
                    label: const Text(
                      'Editar pesca',
                    ),
                  ),
                ),

                const SizedBox(height: 21),

                // ===================================================
                // ENTRADAS
                // ===================================================

                tituloSeccion(
                  '📦',
                  'Entradas',
                ),

                const SizedBox(height: 9),

                ...pesca.detalles
                    .asMap()
                    .entries
                    .map(
                  (entry) {
                    final index =
                        entry.key;
                    final item =
                        entry.value;

                    return Padding(
                      padding:
                          const EdgeInsets.only(
                        bottom: 7,
                      ),
                      child: tarjetaClara(
                        child: Row(
                          children: [
                            numeroMenta(
                              '${index + 1}',
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                children: [
                                  Text(
                                    '${item.cantidad} gavetas',
                                    style:
                                        const TextStyle(
                                      fontWeight:
                                          FontWeight
                                              .w800,
                                    ),
                                  ),
                                  Text(
                                    '${formatoNumero(item.pesoUnitario)} '
                                    '${pesca.unidad} por gaveta',
                                    style:
                                        const TextStyle(
                                      color: AppColors
                                          .textSecondary,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '${formatoNumero(item.total)} ${pesca.unidad}',
                              style:
                                  const TextStyle(
                                fontWeight:
                                    FontWeight
                                        .w900,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),

                resumenPescaOscuro(
                  totalGavetas:
                      pesca.totalGavetas,
                  pesoTotal:
                      pesca.pesoTotal,
                  unidad: pesca.unidad,
                ),

                const SizedBox(height: 21),

                // ===================================================
                // LIQUIDACIÓN
                // ===================================================

                tituloSeccion(
                  '💰',
                  'Liquidación',
                ),

                const SizedBox(height: 9),

                if (!pesca.liquidada) ...[
                  tarjetaClara(
                    child: Row(
                      children: [
                        const Text(
                          'Estado',
                        ),
                        const Spacer(),
                        estadoBadge(
                          pesca.estadoPago,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 11),

                  botonNegro(
                    texto: 'Liquidar pesca',
                    icono:
                        Icons.attach_money,
                    onPressed: liquidar,
                  ),
                ] else ...[
                  tarjetaClara(
                    child: Column(
                      children: [
                        resumenFila(
                          'Peso bruto',
                          '${formatoNumero(pesca.pesoTotal)} ${pesca.unidad}',
                        ),

                        resumenFila(
                          'Descuento',
                          '${formatoNumero(pesca.descuento)} ${pesca.unidad}',
                        ),

                        resumenFila(
                          'Motivo',
                          pesca.motivoDescuento,
                        ),

                        resumenFila(
                          'Peso pagable',
                          '${formatoNumero(pesca.pesoPagable)} ${pesca.unidad}',
                        ),

                        resumenFila(
                          'Precio por ${pesca.unidad}',
                          '\$${pesca.precio.toStringAsFixed(2)}',
                        ),

                        const Divider(),

                        resumenFila(
                          'TOTAL A PAGAR',
                          formatoDinero(
                            pesca.totalPagar,
                          ),
                          importante: true,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: liquidar,
                      icon: const Icon(
                        Icons.edit_outlined,
                      ),
                      label: const Text(
                        'Editar liquidación',
                      ),
                    ),
                  ),

                  const SizedBox(height: 21),

                  tituloSeccion(
                    '💵',
                    'Pagos',
                  ),

                  const SizedBox(height: 9),

                  tarjetaClara(
                    child: Column(
                      children: [
                        resumenFila(
                          'Total a pagar',
                          formatoDinero(
                            pesca.totalPagar,
                          ),
                        ),

                        resumenFila(
                          'Total pagado',
                          formatoDinero(
                            pesca.totalPagado,
                          ),
                        ),

                        const Divider(),

                        resumenFila(
                          'Saldo pendiente',
                          formatoDinero(
                            pesca.saldoPendiente,
                          ),
                          importante: true,
                        ),

                        const SizedBox(height: 8),

                        estadoBadge(
                          pesca.estadoPago,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 11),

                  botonMenta(
                    texto: 'Registrar pago',
                    icono:
                        Icons.add_card_outlined,
                    onPressed: nuevoPago,
                  ),

                  const SizedBox(height: 16),

                  if (pesca.pagos.isNotEmpty) ...[
                    tituloSeccion(
                      '🧾',
                      'Historial de pagos',
                    ),

                    const SizedBox(height: 9),

                    ...pesca.pagos.map(
                      (pago) => PagoCard(
                        pesca: pesca,
                        pago: pago,
                        onChanged: () {
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ],
              ],
            ),
          ),
        );
      }
    }
