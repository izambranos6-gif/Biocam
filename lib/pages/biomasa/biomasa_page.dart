part of '../../main.dart';

// =============================================================
    // BIOMASA
    // =============================================================

    class BiomasaPage extends StatefulWidget {
      const BiomasaPage({super.key});

      @override
      State<BiomasaPage> createState() =>
          _BiomasaPageState();
    }

    class _BiomasaPageState extends State<BiomasaPage> {
      final cantidadController =
          TextEditingController();
      final lancesController =
          TextEditingController();
      final atarrayaController =
          TextEditingController();
      final hectareasController =
          TextEditingController();
      final gramajeController =
          TextEditingController();

      double camaronLance = 0;
      double camaronM2 = 0;
      double camaronesEstimados = 0;
      double libras = 0;
      double kilos = 0;
      double quintales = 0;

      bool mostrar = false;

      // Forma de ingreso del tamaño de la atarraya:
      // Metros = Biocam calcula m × m.
      // m² = se usa directamente el área ingresada.
      String tipoAtarraya = 'm²';

      double valor(
        TextEditingController controller,
      ) {
        return double.tryParse(
              controller.text
                  .trim()
                  .replaceAll(',', '.'),
            ) ??
            0;
      }

      void calcular() {
        if (cantidadController.text.trim().isEmpty ||
            lancesController.text.trim().isEmpty ||
            atarrayaController.text.trim().isEmpty ||
            hectareasController.text.trim().isEmpty ||
            gramajeController.text.trim().isEmpty) {
          setState(() {
            mostrar = false;
          });

          mensajeSnack(
            context,
            'Completa todos los campos para calcular la biomasa.',
          );
          return;
        }

        final cantidad =
            valor(cantidadController);
        final lances =
            valor(lancesController);
        final atarraya =
            valor(atarrayaController);
        final hectareas =
            valor(hectareasController);
        final gramaje =
            valor(gramajeController);

        if (cantidad <= 0 ||
            lances <= 0 ||
            atarraya <= 0 ||
            hectareas <= 0 ||
            gramaje <= 0) {
          setState(() {
            mostrar = false;
          });

          mensajeSnack(
            context,
            'Ingresa valores mayores a 0 en todos los campos.',
          );

          return;
        }

        final areaAtarraya = tipoAtarraya == 'Metros'
              ? (3.141592653589793 * (atarraya / 2) * (atarraya / 2) * 0.85)
              .roundToDouble()
              : atarraya;

        camaronLance =
            cantidad / lances;

        camaronM2 =
            camaronLance / areaAtarraya;

        final metrosCuadrados =
            hectareas * 10000;

        camaronesEstimados =
            camaronM2 * metrosCuadrados;

        final gramos =
            camaronesEstimados * gramaje;

        libras = gramos / 454;
        kilos = libras / 2.20462;
        quintales = kilos / 45.3592;

        setState(() {
          mostrar = true;
        });
      }

      void limpiar() {
        cantidadController.clear();
        lancesController.clear();
        atarrayaController.clear();
        hectareasController.clear();
        gramajeController.clear();

        setState(() {
          mostrar = false;
        });
      }

      @override
      Widget build(BuildContext context) {
        return SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              18,
              18,
              18,
              25,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Biomasa',
                  style: TextStyle(
                    fontSize: 33,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const Text(
                  'Calculadora de Biomasa',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 16,
                  ),
                ),

                const SizedBox(height: 18),

                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.dark,
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: campoOscuro(
                              cantidadController,
                              'Camarones',
                              Icons.numbers_rounded,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: campoOscuro(
                              lancesController,
                              'Lances',
                              Icons.gesture_rounded,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 9),

                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.darkSoft,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 3,
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.straighten_rounded,
                                    color: Colors.white70,
                                    size: 22,
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: TextField(
                                      controller: atarrayaController,
                                      onChanged: (_) {
                                        setState(() {
                                          mostrar = false;
                                        });
                                      },
                                      keyboardType:
                                          const TextInputType.numberWithOptions(
                                        decimal: true,
                                      ),
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                      decoration: const InputDecoration(
                                        labelText: 'Tamaño de atarraya',
                                        labelStyle: TextStyle(
                                          color: Colors.white54,
                                        ),
                                        border: InputBorder.none,
                                        isDense: true,
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 15,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            width: 118,
                            height: 58,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 11,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.darkSoft,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: tipoAtarraya,
                                isExpanded: true,
                                dropdownColor: AppColors.darkSoft,
                                icon: const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: Colors.white70,
                                ),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: 'm²',
                                    child: Text('m²'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Metros',
                                    child: Text('Metros'),
                                  ),
                                ],
                                onChanged: (value) {
                                  if (value == null ||
                                      value == tipoAtarraya) {
                                    return;
                                  }

                                  setState(() {
                                    tipoAtarraya = value;
                                    atarrayaController.clear();
                                    mostrar = false;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),

                      if (atarrayaController.text.trim().isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 7,
                            left: 4,
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              tipoAtarraya == 'Metros'
                                  ? 'Área calculada: ${formatoNumero(valor(atarrayaController) * valor(atarrayaController))} m²'
                                  : 'Área usada: ${formatoNumero(valor(atarrayaController))} m²',
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),

                      const SizedBox(height: 9),

                      Row(
                        children: [
                          Expanded(
                            child: campoOscuro(
                              hectareasController,
                              'Hectáreas',
                              Icons.landscape_rounded,
                              unidad: 'ha',
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: campoOscuro(
                              gramajeController,
                              'Gramaje',
                              Icons.scale_rounded,
                              unidad: 'g',
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 50,
                              child:
                                  ElevatedButton.icon(
                                onPressed: calcular,
                                style:
                                    ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors.white,
                                  foregroundColor:
                                      Colors.black,
                                ),
                                icon: const Icon(
                                  Icons.calculate_rounded,
                                ),
                                label:
                                    const Text(
                                  'Calcular',
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 8),

                          IconButton(
                            onPressed: limpiar,
                            style: IconButton.styleFrom(
                              backgroundColor:
                                  Colors.white10,
                              foregroundColor:
                                  Colors.white,
                            ),
                            icon: const Icon(
                              Icons.refresh_rounded,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                if (mostrar)
                  resultadoBiomasa()
                else
                  tarjetaClara(
                    child: const Center(
                      child: Text(
                        'Ingresa los datos para calcular la biomasa.',
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      }

      Widget resultadoBiomasa() {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            color: AppColors.black,
            borderRadius: BorderRadius.circular(27),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'RESULTADO',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 9,
                ),
              ),

              const Text(
                'Biomasa estimada',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 16),

              filaBiomasa(
                Icons.gesture_rounded,
                'Camarón por lance',
                camaronLance.toStringAsFixed(2),
              ),

              const SizedBox(height: 7),

              filaBiomasa(
                Icons.grid_view_rounded,
                'Camarones por m²',
                camaronM2.toStringAsFixed(2),
              ),

              const SizedBox(height: 7),

              filaBiomasa(
                Icons.set_meal_rounded,
                'Camarones estimados',
                formatoMiles(camaronesEstimados),
              ),

              const SizedBox(height: 16),

              const Divider(
                color: Colors.white12,
              ),

              const Text(
                'Resultado en unidades',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 10),

              Row(
                children: [
                  unidadBiomasa(
                    Icons.shopping_bag_rounded,
                    libras.toStringAsFixed(2),
                    'Libras',
                  ),
                  const SizedBox(width: 6),
                  unidadBiomasa(
                    Icons.scale_rounded,
                    kilos.toStringAsFixed(2),
                    'Kilos',
                  ),
                  const SizedBox(width: 6),
                  unidadBiomasa(
                    Icons.inventory_2_rounded,
                    quintales.toStringAsFixed(2),
                    'Quintales',
                  ),
                ],
              ),
            ],
          ),
        );
      }
    }
