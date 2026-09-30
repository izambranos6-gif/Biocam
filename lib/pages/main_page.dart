part of '../main.dart';

// =============================================================
    // NAVEGACIÓN PRINCIPAL
    // =============================================================

    class MainPage extends StatefulWidget {
      const MainPage({super.key});

      @override
      State<MainPage> createState() =>
          _MainPageState();
    }

    class _MainPageState extends State<MainPage> {
      int pagina = 0;

      void cambiarPagina(int index) {
        setState(() {
          pagina = index;
        });
      }

      @override
      Widget build(BuildContext context) {
        return Scaffold(
          body: IndexedStack(
            index: pagina,
            children: [
              InicioPage(
                abrirBiomasa: () {
                  cambiarPagina(1);
                },
                abrirPescas: () {
                  cambiarPagina(2);
                },
                actualizar: () {
                  setState(() {});
                },
              ),
              const BiomasaPage(),
              HistorialPage(
                actualizarPrincipal: () {
                  setState(() {});
                },
              ),
            ],
          ),

          bottomNavigationBar: SafeArea(
            top: false,
            child: Container(
              margin: const EdgeInsets.fromLTRB(
                14,
                3,
                14,
                10,
              ),
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: AppColors.black,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Row(
                children: [
                  navItem(
                    index: 0,
                    icono: Icons.home_rounded,
                    texto: 'Inicio',
                  ),
                  navItem(
                    index: 1,
                    icono: Icons.bar_chart_rounded,
                    texto: 'Biomasa',
                  ),
                  navItem(
                    index: 2,
                    icono: Icons.assignment_rounded,
                    texto: 'Pescas',
                  ),
                ],
              ),
            ),
          ),
        );
      }

      Widget navItem({
        required int index,
        required IconData icono,
        required String texto,
      }) {
        final seleccionado = pagina == index;

        return Expanded(
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () {
              cambiarPagina(index);
            },
            child: AnimatedContainer(
              duration: const Duration(
                milliseconds: 200,
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 9,
              ),
              decoration: BoxDecoration(
                color: seleccionado
                    ? AppColors.dark
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icono,
                    size: 22,
                    color: seleccionado
                        ? AppColors.mint
                        : Colors.white54,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    texto,
                    style: TextStyle(
                      color: seleccionado
                          ? Colors.white
                          : Colors.white54,
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }
