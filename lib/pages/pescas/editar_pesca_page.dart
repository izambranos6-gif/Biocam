part of '../../main.dart';

// =============================================================
    // EDITAR PESCA
    // =============================================================

    class EditarPescaPage
        extends StatefulWidget {
      final Pesca pesca;

      const EditarPescaPage({
        super.key,
        required this.pesca,
      });

      @override
      State<EditarPescaPage> createState() =>
          _EditarPescaPageState();
    }

    class _EditarPescaPageState
        extends State<EditarPescaPage> {
      late DateTime fecha;
      late String unidad;

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

      final List<DetallePesca> detalles = [];

      @override
      void initState() {
        super.initState();

        fecha = widget.pesca.fecha;
        unidad = widget.pesca.unidad;

        personaController.text =
            widget.pesca.persona;
        piscinaController.text = widget.pesca.piscina;
        gramajeController.text = widget.pesca.gramaje.toString();

        detalles.addAll(
          widget.pesca.detalles.map(
            (item) => DetallePesca(
              cantidad: item.cantidad,
              pesoUnitario:
                  item.pesoUnitario,
            ),
          ),
        );
      }

      void guardar() {
        if (detalles.isEmpty) {
          mensajeSnack(
            context,
            'Debe existir al menos una entrada.',
          );

          return;
        }

        widget.pesca.fecha = fecha;
        final gramaje = double.tryParse(gramajeController.text.trim().replaceAll(',', '.'));
        // La piscina es opcional; el gramaje sí debe ser válido.
        if (gramaje == null || gramaje <= 0) {
          mensajeSnack(context, 'Revisa el gramaje.');
          return;
        }
        widget.pesca.persona =
            personaController.text.trim();
        widget.pesca.piscina = piscinaController.text.trim();
        widget.pesca.gramaje = gramaje;
        widget.pesca.unidad = unidad;
        widget.pesca.detalles =
            detalles;

        Navigator.pop(
          context,
          true,
        );
      }

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          appBar:
              AppBar(title: const Text('Editar pesca')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
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
                  decoration: inputClaro('Piscina', Icons.water_outlined),
                ),

                const SizedBox(height: 10),

                TextField(
                  controller: gramajeController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: inputClaro('Gramaje del camarón (g)', Icons.scale_outlined),
                ),

                const SizedBox(height: 13),

                ...detalles
                    .asMap()
                    .entries
                    .map(
                  (entry) {
                    final index =
                        entry.key;
                    final item =
                        entry.value;

                    return Card(
                      child: ListTile(
                        title: Text(
                          '${item.cantidad} gavetas',
                        ),
                        subtitle: Text(
                          '${formatoNumero(item.pesoUnitario)} $unidad c/u',
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            setState(() {
                              detalles
                                  .removeAt(
                                index,
                              );
                            });
                          },
                          icon: const Icon(
                            Icons.delete_outline,
                          ),
                        ),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 13),

                botonMenta(
                  texto: 'Guardar cambios',
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
