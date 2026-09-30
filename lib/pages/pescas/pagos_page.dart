part of '../../main.dart';

// =============================================================
    // PAGOS
    // =============================================================

    class PagoPage extends StatefulWidget {
      final Pesca pesca;
      final Pago? pagoEditar;

      const PagoPage({
        super.key,
        required this.pesca,
        this.pagoEditar,
      });

      @override
      State<PagoPage> createState() =>
          _PagoPageState();
    }

    class _PagoPageState extends State<PagoPage> {
      late DateTime fecha;

      final valorController =
          TextEditingController();
      final referenciaController =
          TextEditingController();
      final observacionController =
          TextEditingController();

      String formaPago = 'Transferencia';

      final formasPago = [
        'Efectivo',
        'Transferencia',
        'Cheque',
        'Depósito',
        'Otro',
      ];

      bool get editando =>
          widget.pagoEditar != null;

      @override
      void initState() {
        super.initState();

        if (editando) {
          final pago =
              widget.pagoEditar!;

          fecha = pago.fecha;
          valorController.text =
              pago.valor.toString();
          formaPago =
              pago.formaPago;
          referenciaController.text =
              pago.referencia;
          observacionController.text =
              pago.observacion;
        } else {
          fecha = DateTime.now();
        }
      }

      double get saldoDisponible {
        if (editando) {
          return widget.pesca
                  .saldoPendiente +
              widget.pagoEditar!.valor;
        }

        return widget.pesca
            .saldoPendiente;
      }

      Future<void> seleccionarFecha() async {
        final seleccion =
            await showDatePicker(
          context: context,
          initialDate: fecha,
          firstDate: DateTime(2020),
          lastDate: DateTime(2100),
        );

        if (seleccion != null) {
          setState(() {
            fecha = seleccion;
          });
        }
      }

      void guardar() {
        final valor =
            double.tryParse(
              valorController.text
                  .replaceAll(',', '.'),
            ) ??
            0;

        if (valor <= 0 ||
            valor >
                saldoDisponible +
                    0.01) {
          mensajeSnack(
            context,
            'Revisa el valor del pago.',
          );

          return;
        }

        if (editando) {
          final pago =
              widget.pagoEditar!;

          pago.fecha = fecha;
          pago.valor = valor;
          pago.formaPago =
              formaPago;
          pago.referencia =
              referenciaController.text;
          pago.observacion =
              observacionController.text;
        } else {
          widget.pesca.pagos.add(
            AppData.crearPago(
              fecha: fecha,
              valor: valor,
              formaPago: formaPago,
              referencia:
                  referenciaController
                      .text,
              observacion:
                  observacionController
                      .text,
            ),
          );
        }

        Navigator.pop(context);
      }

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              editando
                  ? 'Editar pago'
                  : 'Registrar pago',
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.dark,
                    borderRadius:
                        BorderRadius.circular(22),
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'SALDO DISPONIBLE',
                        style: TextStyle(
                          color: Colors.white54,
                        ),
                      ),
                      Text(
                        formatoDinero(
                          saldoDisponible,
                        ),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 27,
                          fontWeight:
                              FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 13),

                tarjetaClara(
                  child: Column(
                    children: [
                      OutlinedButton.icon(
                        onPressed:
                            seleccionarFecha,
                        icon:
                            const Text('📅'),
                        label: Text(
                          formatoFecha(fecha),
                        ),
                      ),

                      const SizedBox(height: 10),

                      TextField(
                        controller:
                            valorController,
                        decoration: inputClaro(
                          'Valor del pago',
                          Icons.attach_money,
                        ),
                      ),

                      const SizedBox(height: 10),

                      DropdownButtonFormField<String>(
                        initialValue: formaPago,
                        decoration:
                            inputSimple(
                          'Forma de pago',
                        ),
                        items: formasPago
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
                              formaPago =
                                  value;
                            });
                          }
                        },
                      ),

                      const SizedBox(height: 10),

                      TextField(
                        controller:
                            referenciaController,
                        decoration:
                            inputSimple(
                          'Referencia / comprobante',
                        ),
                      ),

                      const SizedBox(height: 10),

                      TextField(
                        controller:
                            observacionController,
                        maxLines: 3,
                        decoration:
                            inputSimple(
                          'Observación',
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 13),

                botonNegro(
                  texto: editando
                      ? 'Guardar cambios'
                      : 'Guardar pago',
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

// =============================================================
    // TARJETA HISTORIAL DE PAGO
    // =============================================================

    class PagoCard extends StatelessWidget {
      final Pesca pesca;
      final Pago pago;
      final VoidCallback onChanged;

      const PagoCard({
        super.key,
        required this.pesca,
        required this.pago,
        required this.onChanged,
      });

      @override
      Widget build(BuildContext context) {
        return Padding(
          padding:
              const EdgeInsets.only(
            bottom: 8,
          ),
          child: tarjetaClara(
            child: Row(
              children: [
                iconoMenta(
                  Icons.payments_outlined,
                ),

                const SizedBox(width: 11),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        formatoDinero(
                          pago.valor,
                        ),
                        style:
                            const TextStyle(
                          fontWeight:
                              FontWeight.w900,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '📅 ${formatoFecha(pago.fecha)}',
                        style:
                            const TextStyle(
                          color: AppColors
                              .textSecondary,
                          fontSize: 11,
                        ),
                      ),
                      Text(
                        pago.formaPago,
                        style:
                            const TextStyle(
                          color: AppColors
                              .textSecondary,
                          fontSize: 11,
                        ),
                      ),
                      if (pago
                          .referencia
                          .isNotEmpty)
                        Text(
                          'Ref: ${pago.referencia}',
                          style:
                              const TextStyle(
                            fontSize: 10,
                          ),
                        ),
                      if (pago
                          .observacion
                          .isNotEmpty)
                        Text(
                          pago.observacion,
                          style:
                              const TextStyle(
                            fontSize: 10,
                          ),
                        ),
                    ],
                  ),
                ),

                PopupMenuButton<String>(
                  onSelected:
                      (value) async {
                    if (value ==
                        'editar') {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              PagoPage(
                            pesca: pesca,
                            pagoEditar: pago,
                          ),
                        ),
                      );
                      onChanged();
                    }

                    if (value ==
                        'eliminar') {
                      pesca.pagos
                          .remove(pago);
                      onChanged();
                    }
                  },
                  itemBuilder: (_) =>
                      const [
                    PopupMenuItem(
                      value: 'editar',
                      child: Text(
                        'Editar pago',
                      ),
                    ),
                    PopupMenuItem(
                      value: 'eliminar',
                      child: Text(
                        'Eliminar pago',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }
    }
