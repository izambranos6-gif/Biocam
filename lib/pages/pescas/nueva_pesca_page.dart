part of '../../main.dart';

// =============================================================
    // NUEVA PESCA
    // =============================================================

    class NuevaPescaPage extends StatefulWidget {
      const NuevaPescaPage({super.key});

      @override
      State<NuevaPescaPage> createState() =>
          _NuevaPescaPageState();
    }

    class _NuevaPescaPageState
        extends State<NuevaPescaPage> {
      DateTime fecha = DateTime.now();

      final personaController =
          TextEditingController();
      final piscinaController =
          TextEditingController();
      final gramajeController =
          TextEditingController();
      final cantidadController =
          TextEditingController();
      final pesoController =
          TextEditingController();

      String unidad = 'LB';

      final List<DetallePesca> detalles = [];

      int get totalGavetas {
        return detalles.fold(
          0,
          (total, item) =>
              total + item.cantidad,
        );
      }

      double get pesoTotal {
        return detalles.fold(
          0.0,
          (total, item) =>
              total + item.total,
        );
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

      void agregarEntrada() {
        final cantidad = int.tryParse(
          cantidadController.text.trim(),
        );

        final peso = double.tryParse(
          pesoController.text
              .trim()
              .replaceAll(',', '.'),
        );

        if (cantidad == null ||
            cantidad <= 0 ||
            peso == null ||
            peso <= 0) {
          mensajeSnack(
            context,
            'Ingresa gavetas y peso válidos.',
          );

          return;
        }

        setState(() {
          detalles.add(
            DetallePesca(
              cantidad: cantidad,
              pesoUnitario: peso,
            ),
          );

          cantidadController.clear();
          pesoController.clear();
        });
      }

      void guardarPesca() {
        final gramaje = double.tryParse(
          gramajeController.text.trim().replaceAll(',', '.'),
        );

        // La piscina es opcional.
        if (gramaje == null || gramaje <= 0) {
          mensajeSnack(context, 'Ingresa un gramaje válido.');
          return;
        }

        if (detalles.isEmpty) {
          mensajeSnack(
            context,
            'Agrega al menos una entrada.',
          );

          return;
        }

        final pesca =
            AppData.crearPesca(
          fecha: fecha,
          persona:
              personaController.text.trim(),
          piscina: piscinaController.text.trim(),
          gramaje: gramaje,
          unidad: unidad,
          detalles: detalles,
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                DetallePescaPage(
              pesca: pesca,
            ),
          ),
        );
      }

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar:
              AppBar(title: const Text('Nueva pesca')),
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
                tituloSeccion(
                  '📝',
                  'Datos de la pesca',
                ),

                const SizedBox(height: 11),

                tarjetaClara(
                  child: Column(
                    children: [
                      InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: seleccionarFecha,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 6,
        ),
        child: Row(
          children: [
            iconoMenta(
              Icons.calendar_month_outlined,
            ),

            const SizedBox(width: 12),

            const Expanded(
              child: Text(
                'Fecha',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            Text(
              formatoFecha(fecha),
              style: const TextStyle(
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(width: 5),

            const Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    ),

                      TextField(
                        controller:
                            personaController,
                        decoration: inputClaro(
                          'Dueño / Persona',
                          Icons.person_outline,
                        ),
                      ),

                      const SizedBox(height: 10),

                      TextField(
                        controller: piscinaController,
                        decoration: inputClaro(
                          'Piscina',
                          Icons.water_outlined,
                        ),
                      ),

                      const SizedBox(height: 10),

                      TextField(
                        controller: gramajeController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: inputClaro(
                          'Gramaje del camarón (g)',
                          Icons.scale_outlined,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                tituloSeccion(
                  '📦',
                  'Registrar gavetas / bin',
                ),

                const SizedBox(height: 11),

                tarjetaClara(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller:
                                  cantidadController,
                              keyboardType:
                                  TextInputType.number,
                              decoration:
                                  inputSimple(
                                'Gavetas',
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller:
                                  pesoController,
                              keyboardType:
                                  const TextInputType
                                      .numberWithOptions(
                                decimal: true,
                              ),
                              decoration:
                                  inputSimple(
                                'Peso',
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      DropdownButtonFormField<String>(
                        initialValue: unidad,
                        decoration:
                            inputSimple('Unidad'),
                        items: const [
                          DropdownMenuItem(
                            value: 'LB',
                            child: Text('LB'),
                          ),
                          DropdownMenuItem(
                            value: 'KG',
                            child: Text('KG'),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              unidad = value;
                            });
                          }
                        },
                      ),

                      const SizedBox(height: 12),

                      botonNegro(
                        texto: 'Añadir',
                        icono: Icons.add_rounded,
                        onPressed:
                            agregarEntrada,
                      ),
                    ],
                  ),
                ),

                if (detalles.isNotEmpty) ...[
                  const SizedBox(height: 20),

                  tituloSeccion(
                    '📋',
                    'Entradas registradas',
                  ),

                  const SizedBox(height: 9),

                  ...detalles
                      .asMap()
                      .entries
                      .map(
                    (entry) {
                      final index = entry.key;
                      final item =
                          entry.value;

                      return Padding(
                        padding:
                            const EdgeInsets.only(
                          bottom: 8,
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
                                      '${formatoNumero(item.pesoUnitario)} $unidad por gaveta',
                                      style:
                                          const TextStyle(
                                        color: AppColors
                                            .textSecondary,
                                        fontSize:
                                            11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                '${formatoNumero(item.total)} $unidad',
                                style:
                                    const TextStyle(
                                  fontWeight:
                                      FontWeight
                                          .w900,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    detalles
                                        .removeAt(
                                      index,
                                    );
                                  });
                                },
                                icon:
                                    const Icon(
                                  Icons
                                      .delete_outline,
                                  color: Colors
                                      .redAccent,
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
                        totalGavetas,
                    pesoTotal: pesoTotal,
                    unidad: unidad,
                  ),

                  const SizedBox(height: 13),

                  botonMenta(
                    texto: 'Guardar pesca',
                    icono:
                        Icons.save_outlined,
                    onPressed: guardarPesca,
                  ),
                ],
              ],
            ),
          ),
        );
      }
    }
