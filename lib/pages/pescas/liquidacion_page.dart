part of '../../main.dart';

// =============================================================
    // LIQUIDACIÓN
    // =============================================================

    class LiquidacionPage extends StatefulWidget {
      final Pesca pesca;

      const LiquidacionPage({
        super.key,
        required this.pesca,
      });

      @override
      State<LiquidacionPage> createState() =>
          _LiquidacionPageState();
    }

    class _LiquidacionPageState
        extends State<LiquidacionPage> {
      final descuentoController =
          TextEditingController();
      final precioController =
          TextEditingController();
      final otroMotivoController =
          TextEditingController();

      String motivo = 'Sin descuento';

      final motivos = [
        'Sin descuento',
        'Agua',
        'Calidad',
        'Disparidad',
        'Sucio',
        'Otro',
      ];

      @override
      void initState() {
        super.initState();

        descuentoController.text =
            widget.pesca.descuento
                .toString();

        precioController.text =
            widget.pesca.precio > 0
                ? widget.pesca.precio
                    .toString()
                : '';

        final guardado = widget
            .pesca.motivoDescuento;

        if (widget.pesca.descuento <= 0 && guardado.isEmpty) {
          motivo = 'Sin descuento';
          descuentoController.text = '0';
        } else if (guardado.isNotEmpty) {
          if (motivos.contains(
            guardado,
          )) {
            motivo = guardado;
          } else {
            motivo = 'Otro';
            otroMotivoController.text =
                guardado;
          }
        }
      }

      double get descuento {
        return double.tryParse(
              descuentoController.text
                  .replaceAll(',', '.'),
            ) ??
            0;
      }

      double get precio {
        return double.tryParse(
              precioController.text
                  .replaceAll(',', '.'),
            ) ??
            0;
      }

      double get pesoPagable {
        final resultado =
            widget.pesca.pesoTotal -
                descuento;

        return resultado < 0
            ? 0
            : resultado;
      }

      double get total {
        return pesoPagable * precio;
      }

      String get motivoFinal {
        if (motivo == 'Sin descuento') return 'Sin descuento';

        if (motivo == 'Otro') {
          return otroMotivoController.text
              .trim();
        }

        return motivo;
      }

      void guardar() {
        if (motivo == 'Sin descuento') {
          descuentoController.text = '0';
        }

        if (descuento < 0 ||
            descuento >
                widget.pesca.pesoTotal) {
          mensajeSnack(
            context,
            'El descuento no es válido.',
          );

          return;
        }

        if (precio <= 0) {
          mensajeSnack(
            context,
            'Ingresa un precio válido.',
          );

          return;
        }

        if (motivo == 'Otro' &&
            otroMotivoController.text
                .trim()
                .isEmpty) {
          mensajeSnack(
            context,
            'Ingresa el motivo del descuento.',
          );

          return;
        }

        widget.pesca.descuento =
            descuento;
        widget.pesca.motivoDescuento =
            motivoFinal;
        widget.pesca.precio =
            precio;
        widget.pesca.liquidada =
            true;

        Navigator.pop(context);
      }

      @override
      Widget build(BuildContext context) {
        final pesca = widget.pesca;

        return Scaffold(
          appBar:
              AppBar(title: const Text('Liquidar pesca')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                tarjetaClara(
                  child: Column(
                    children: [
                      resumenFila(
                        'Peso bruto',
                        '${formatoNumero(pesca.pesoTotal)} ${pesca.unidad}',
                        importante: true,
                      ),
                      resumenFila(
                        'Gavetas',
                        '${pesca.totalGavetas}',
                      ),
                      resumenFila(
                        'Persona',
                        pesca.persona,
                      ),
                      resumenFila('Piscina', pesca.piscina),
                      resumenFila('Gramaje', '${formatoNumero(pesca.gramaje)} g'),
                    ],
                  ),
                ),

                const SizedBox(height: 13),

                tarjetaClara(
                  child: Column(
                    children: [
                      TextField(
                        controller:
                            descuentoController,
                        enabled: motivo != 'Sin descuento',
                        keyboardType:
                            const TextInputType
                                .numberWithOptions(
                          decimal: true,
                        ),
                        onChanged: (_) {
                          setState(() {});
                        },
                        decoration:
                            inputSimple(
                          'Descuento (${pesca.unidad})',
                        ),
                      ),

                      const SizedBox(height: 10),

                      DropdownButtonFormField<String>(
                        initialValue: motivo,
                        decoration:
                            inputSimple(
                          'Motivo del descuento',
                        ),
                        items: motivos
                            .map(
                              (item) =>
                                  DropdownMenuItem(
                                value: item,
                                child:
                                    Text(item),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              motivo = value;
                              if (motivo == 'Sin descuento') {
                                descuentoController.text = '0';
                              }
                            });
                          }
                        },
                      ),

                      if (motivo == 'Otro') ...[
                        const SizedBox(height: 10),
                        TextField(
                          controller:
                              otroMotivoController,
                          decoration:
                              inputClaro(
                            'Especifique el motivo',
                            Icons.edit_note,
                          ),
                        ),
                      ],

                      const SizedBox(height: 10),

                      TextField(
                        controller:
                            precioController,
                        keyboardType:
                            const TextInputType
                                .numberWithOptions(
                          decimal: true,
                        ),
                        onChanged: (_) {
                          setState(() {});
                        },
                        decoration: inputClaro(
                          'Precio por ${pesca.unidad}',
                          Icons.attach_money,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 13),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.dark,
                    borderRadius:
                        BorderRadius.circular(23),
                  ),
                  child: Column(
                    children: [
                      resumenOscuro(
                        'Peso bruto',
                        '${formatoNumero(pesca.pesoTotal)} ${pesca.unidad}',
                      ),
                      resumenOscuro(
                        'Descuento',
                        '${formatoNumero(descuento)} ${pesca.unidad}',
                      ),
                      resumenOscuro(
                        'Motivo',
                        motivoFinal.isEmpty
                            ? motivo
                            : motivoFinal,
                      ),
                      resumenOscuro(
                        'Peso pagable',
                        '${formatoNumero(pesoPagable)} ${pesca.unidad}',
                      ),
                      resumenOscuro(
                        'Precio',
                        '\$${precio.toStringAsFixed(2)}',
                      ),

                      const Divider(
                        color: Colors.white12,
                      ),

                      const Text(
                        'TOTAL A PAGAR',
                        style: TextStyle(
                          color: Colors.white54,
                        ),
                      ),

                      Text(
                        formatoDinero(total),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 29,
                          fontWeight:
                              FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 13),

                botonNegro(
                  texto: 'Guardar liquidación',
                  icono:
                      Icons.save_outlined,
                  onPressed: guardar,
                ),
              ],
            ),
          ),
        );
      }
    }
