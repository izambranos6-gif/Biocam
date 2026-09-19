import 'package:flutter/material.dart';

void main() {
  runApp(const BiocamApp());
}

// =============================================================
// COLORES
// =============================================================

class AppColors {
  static const background = Color(0xFFF6F6F6);
  static const white = Color(0xFFFFFFFF);

  static const black = Color(0xFF151515);
  static const dark = Color(0xFF292929);
  static const darkSoft = Color(0xFF353535);

  static const text = Color(0xFF181818);
  static const textSecondary = Color(0xFF777777);

  static const mint = Color(0xFFDDF6EF);
  static const lavender = Color(0xFFF2DFF8);
  static const lavenderSoft = Color(0xFFF8EFFB);

  static const redBg = Color(0xFFFFE5E5);
  static const redText = Color(0xFFB42323);

  static const orangeBg = Color(0xFFFFEFD6);
  static const orangeText = Color(0xFFB86A00);

  static const greenBg = Color(0xFFDDF5E5);
  static const greenText = Color(0xFF17783A);

  static const blueBg = Color(0xFFE7EEFF);
  static const blueText = Color(0xFF3159B8);
}

// =============================================================
// CONFIGURACIÓN
// =============================================================

class AppSettings {
  static String nombreEmpresa = 'Biocam';
}

// =============================================================
// MODELOS
// =============================================================

class DetallePesca {
  int cantidad;
  double pesoUnitario;

  DetallePesca({
    required this.cantidad,
    required this.pesoUnitario,
  });

  double get total => cantidad * pesoUnitario;
}

class Pago {
  int id;
  DateTime fecha;
  double valor;
  String formaPago;
  String referencia;
  String observacion;

  Pago({
    required this.id,
    required this.fecha,
    required this.valor,
    required this.formaPago,
    this.referencia = '',
    this.observacion = '',
  });
}

class Pesca {
  int id;
  DateTime fecha;
  String persona;
  String piscina;
  double gramaje;
  String unidad;

  List<DetallePesca> detalles;
  List<Pago> pagos;

  double descuento;
  String motivoDescuento;
  double precio;

  bool liquidada;

  Pesca({
    required this.id,
    required this.fecha,
    required this.persona,
    required this.piscina,
    required this.gramaje,
    required this.unidad,
    required this.detalles,
    List<Pago>? pagos,
    this.descuento = 0,
    this.motivoDescuento = '',
    this.precio = 0,
    this.liquidada = false,
  }) : pagos = pagos ?? [];

  int get totalGavetas {
    return detalles.fold(
      0,
      (total, item) => total + item.cantidad,
    );
  }

  double get pesoTotal {
    return detalles.fold(
      0.0,
      (total, item) => total + item.total,
    );
  }

  double get pesoPagable {
    final valor = pesoTotal - descuento;
    return valor < 0 ? 0 : valor;
  }

  double get totalPagar {
    return pesoPagable * precio;
  }

  double get totalPagado {
    return pagos.fold(
      0.0,
      (total, pago) => total + pago.valor,
    );
  }

  double get saldoPendiente {
    final saldo = totalPagar - totalPagado;
    return saldo < 0 ? 0 : saldo;
  }

  String get estadoPago {
    if (!liquidada) return 'Sin liquidar';

    if (totalPagado <= 0) {
      return 'Pendiente';
    }

    if (saldoPendiente > 0.01) {
      return 'Pago parcial';
    }

    return 'Pagado';
  }
}

// =============================================================
// DATOS LOCALES
// =============================================================

class AppData {
  static int nextPescaId = 1;
  static int nextPagoId = 1;

  static final List<Pesca> pescas = [];

  static Pesca crearPesca({
    required DateTime fecha,
    required String persona,
    required String piscina,
    required double gramaje,
    required String unidad,
    required List<DetallePesca> detalles,
  }) {
    final pesca = Pesca(
      id: nextPescaId++,
      fecha: fecha,
      persona: persona,
      piscina: piscina,
      gramaje: gramaje,
      unidad: unidad,
      detalles: detalles
          .map(
            (item) => DetallePesca(
              cantidad: item.cantidad,
              pesoUnitario: item.pesoUnitario,
            ),
          )
          .toList(),
    );

    pescas.insert(0, pesca);

    return pesca;
  }

  static Pago crearPago({
    required DateTime fecha,
    required double valor,
    required String formaPago,
    required String referencia,
    required String observacion,
  }) {
    return Pago(
      id: nextPagoId++,
      fecha: fecha,
      valor: valor,
      formaPago: formaPago,
      referencia: referencia,
      observacion: observacion,
    );
  }

  static void eliminarPesca(Pesca pesca) {
    pescas.remove(pesca);
  }
}

// =============================================================
// FUNCIONES
// =============================================================

String formatoFecha(DateTime fecha) {
  return '${fecha.day.toString().padLeft(2, '0')}/'
      '${fecha.month.toString().padLeft(2, '0')}/'
      '${fecha.year}';
}

String formatoNumero(double valor) {
  if (valor == valor.roundToDouble()) {
    return valor.toStringAsFixed(0);
  }

  return valor.toStringAsFixed(2);
}

String formatoDinero(double valor) {
  final partes = valor.toStringAsFixed(2).split('.');
  final entero = partes[0];

  String resultado = '';

  for (int i = 0; i < entero.length; i++) {
    final restante = entero.length - i;

    resultado += entero[i];

    if (restante > 1 && restante % 3 == 1) {
      resultado += '.';
    }
  }

  return '\$$resultado,${partes[1]}';
}

String formatoMiles(double valor) {
  final texto = valor.round().toString();

  String resultado = '';
  int contador = 0;

  for (int i = texto.length - 1; i >= 0; i--) {
    resultado = texto[i] + resultado;
    contador++;

    if (contador == 3 && i != 0) {
      resultado = ',$resultado';
      contador = 0;
    }
  }

  return resultado;
}

bool mismaFecha(DateTime a, DateTime b) {
  return a.year == b.year &&
      a.month == b.month &&
      a.day == b.day;
}

// =============================================================
// APP
// =============================================================

class BiocamApp extends StatelessWidget {
  const BiocamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Biocam',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.black,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.text,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          titleTextStyle: TextStyle(
            color: AppColors.text,
            fontWeight: FontWeight.w900,
            fontSize: 19,
          ),
        ),
      ),
      home: const SplashBiocamPage(),
    );
  }
}

class SplashBiocamPage extends StatefulWidget {
  const SplashBiocamPage({super.key});

  @override
  State<SplashBiocamPage> createState() => _SplashBiocamPageState();
}

class _SplashBiocamPageState extends State<SplashBiocamPage>
    with TickerProviderStateMixin {
  late final AnimationController _entrada;
  late final AnimationController _pulso;

  @override
  void initState() {
    super.initState();

    _entrada = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();

    _pulso = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
      lowerBound: 0.0,
      upperBound: 1.0,
    )..repeat(reverse: true);

    Future.delayed(const Duration(milliseconds: 4000), () {
      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 420),
          pageBuilder: (_, animation, __) => const MainPage(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _entrada.dispose();
    _pulso.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAF9),
      body: Center(
        child: FadeTransition(
          opacity: CurvedAnimation(
            parent: _entrada,
            curve: Curves.easeOut,
          ),
          child: AnimatedBuilder(
            animation: _pulso,
            builder: (context, child) {
              final escala = 1.0 + (_pulso.value * 0.035);

              return Transform.scale(
                scale: escala,
                child: child,
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Image.asset(
                'assets/images/biocam_logo.png',
                width: 420,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return const Text(
                    'BIOCAM',
                    style: TextStyle(
                      color: Color(0xFF18252A),
                      fontSize: 46,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

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
                    right: -12,
                    top: -14,
                    child: Container(
                      width: 116,
                      height: 116,
                      decoration: BoxDecoration(
                        color: AppColors.mint,
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 18,
                    top: 14,
                    child: const Text(
                      '🦐',
                      style: TextStyle(fontSize: 54),
                    ),
                  ),
                  Positioned(
                    right: 20,
                    bottom: 2,
                    child: const Icon(
                      Icons.waves,
                      color: Colors.white24,
                      size: 58,
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
                    titulo: 'Pagadas',
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
      mensajeSnack(
        context,
        'Completa todos los campos.',
      );

      return;
    }

    camaronLance =
        cantidad / lances;

    camaronM2 =
        camaronLance / atarraya;

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

                  campoOscuro(
                    atarrayaController,
                    'Tamaño de atarraya',
                    Icons.straighten_rounded,
                    unidad: 'm²',
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
                    controller:
                        buscarController,
                    onChanged: (_) {
                      setState(() {});
                    },
                    decoration:
                        inputClaro(
                      'Buscar por nombre',
                      Icons.search,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Wrap(
                    spacing: 6,
                    runSpacing: 5,
                    children: [
                      chipEstado(
                        'Todas',
                      ),
                      chipEstado(
                        'Sin liquidar',
                      ),
                      chipEstado(
                        'Pendiente',
                      ),
                      chipEstado(
                        'Pago parcial',
                      ),
                      chipEstado(
                        'Pagadas',
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child:
                            OutlinedButton.icon(
                          onPressed:
                              seleccionarFecha,
                          icon:
                              const Text(
                            '📅',
                          ),
                          label: Text(
                            filtroFecha ==
                                    null
                                ? 'Todas las fechas'
                                : formatoFecha(
                                    filtroFecha!,
                                  ),
                          ),
                        ),
                      ),

                      if (filtroFecha !=
                          null)
                        IconButton(
                          onPressed: () {
                            setState(() {
                              filtroFecha =
                                  null;
                            });
                          },
                          icon:
                              const Icon(
                            Icons.close,
                          ),
                        ),
                    ],
                  ),

                  TextButton(
                    onPressed:
                        limpiarFiltros,
                    child: const Text(
                      'Limpiar filtros',
                    ),
                  ),
                ],
              ),
            ),
          ),

          Text(
            '${resultados.length} pescas encontradas',
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

  Widget chipEstado(String texto) {
    final seleccionado =
        filtroEstado == texto;

    return ChoiceChip(
      label: Text(texto),
      selected: seleccionado,
      showCheckmark: false,
      selectedColor: AppColors.black,
      labelStyle: TextStyle(
        color: seleccionado
            ? Colors.white
            : AppColors.text,
        fontSize: 10,
      ),
      onSelected: (_) {
        setState(() {
          filtroEstado = texto;
        });
      },
    );
  }
}

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

// =============================================================
// COMPONENTES
// =============================================================

Widget circuloSuperior({
  required Widget child,
}) {
  return Container(
    width: 43,
    height: 43,
    decoration: const BoxDecoration(
      color: Colors.white,
      shape: BoxShape.circle,
    ),
    child: Center(child: child),
  );
}

Widget capsula(
  String texto,
  bool seleccionado,
) {
  return Expanded(
    child: Container(
      padding:
          const EdgeInsets.symmetric(
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: seleccionado
            ? AppColors.black
            : Colors.white,
        borderRadius:
            BorderRadius.circular(25),
      ),
      child: Center(
        child: Text(
          texto,
          style: TextStyle(
            color: seleccionado
                ? Colors.white
                : Colors.black,
            fontSize: 10,
          ),
        ),
      ),
    ),
  );
}

Widget miniResumenInicio({
  required String emoji,
  required String valor,
  required String titulo,
}) {
  return Container(
    padding: const EdgeInsets.all(11),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius:
          BorderRadius.circular(19),
    ),
    child: Column(
      children: [
        Text(emoji),
        Text(
          valor,
          style: const TextStyle(
            fontSize: 22,
            fontWeight:
                FontWeight.w900,
          ),
        ),
        Text(
          titulo,
          style: const TextStyle(
            fontSize: 9,
            color:
                AppColors.textSecondary,
          ),
        ),
      ],
    ),
  );
}

Widget menuPrincipal({
  required IconData icono,
  required String titulo,
  required String descripcion,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.dark,
        borderRadius:
            BorderRadius.circular(23),
      ),
      child: Row(
        children: [
          iconoMenta(icono),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style:
                      const TextStyle(
                    color: Colors.white,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),
                Text(
                  descripcion,
                  style:
                      const TextStyle(
                    color:
                        Colors.white54,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right,
            color: Colors.white54,
          ),
        ],
      ),
    ),
  );
}

Widget tarjetaClara({
  required Widget child,
}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius:
          BorderRadius.circular(19),
    ),
    child: child,
  );
}

Widget iconoMenta(
  IconData icono,
) {
  return Container(
    width: 45,
    height: 45,
    decoration: BoxDecoration(
      color: AppColors.mint,
      borderRadius:
          BorderRadius.circular(14),
    ),
    child: Icon(icono),
  );
}

Widget numeroMenta(
  String texto,
) {
  return Container(
    width: 38,
    height: 38,
    decoration: BoxDecoration(
      color: AppColors.mint,
      borderRadius:
          BorderRadius.circular(11),
    ),
    child: Center(
      child: Text(
        texto,
        style: const TextStyle(
          fontWeight:
              FontWeight.w900,
        ),
      ),
    ),
  );
}

Widget tituloSeccion(
  String emoji,
  String texto,
) {
  return Row(
    children: [
      Text(
        emoji,
        style:
            const TextStyle(
          fontSize: 18,
        ),
      ),
      const SizedBox(width: 7),
      Text(
        texto,
        style:
            const TextStyle(
          fontSize: 17,
          fontWeight:
              FontWeight.w900,
        ),
      ),
    ],
  );
}

InputDecoration inputClaro(
  String titulo,
  IconData icono,
) {
  return InputDecoration(
    labelText: titulo,
    prefixIcon: Icon(icono),
    filled: true,
    fillColor:
        AppColors.background,
    border: OutlineInputBorder(
      borderRadius:
          BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
  );
}

InputDecoration inputSimple(
  String titulo,
) {
  return InputDecoration(
    labelText: titulo,
    filled: true,
    fillColor:
        AppColors.background,
    border: OutlineInputBorder(
      borderRadius:
          BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
  );
}

Widget botonNegro({
  required String texto,
  required IconData icono,
  required VoidCallback onPressed,
}) {
  return SizedBox(
    width: double.infinity,
    height: 50,
    child: ElevatedButton.icon(
      onPressed: onPressed,
      style:
          ElevatedButton.styleFrom(
        backgroundColor:
            AppColors.black,
        foregroundColor:
            Colors.white,
      ),
      icon: Icon(icono),
      label: Text(texto),
    ),
  );
}

Widget botonMenta({
  required String texto,
  required IconData icono,
  required VoidCallback onPressed,
}) {
  return SizedBox(
    width: double.infinity,
    height: 50,
    child: ElevatedButton.icon(
      onPressed: onPressed,
      style:
          ElevatedButton.styleFrom(
        backgroundColor:
            AppColors.mint,
        foregroundColor:
            Colors.black,
      ),
      icon: Icon(icono),
      label: Text(texto),
    ),
  );
}

Widget resumenPescaOscuro({
  required int totalGavetas,
  required double pesoTotal,
  required String unidad,
}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.dark,
      borderRadius:
          BorderRadius.circular(20),
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            children: [
              const Text(
                'Total gavetas',
                style: TextStyle(
                  color:
                      Colors.white54,
                ),
              ),
              Text(
                '$totalGavetas',
                style:
                    const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight:
                      FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              const Text(
                'Peso total',
                style: TextStyle(
                  color:
                      Colors.white54,
                ),
              ),
              FittedBox(
                child: Text(
                  '${formatoNumero(pesoTotal)} $unidad',
                  style:
                      const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight:
                        FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget vistaPreviaDato(
  String emoji,
  String titulo,
  String valor,
) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(emoji, style: const TextStyle(fontSize: 15)),
      const SizedBox(width: 6),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              titulo,
              style: const TextStyle(
                color: Colors.white38,
                fontSize: 8,
              ),
            ),
            Text(
              valor,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget estadoBadge(
  String estado,
) {
  Color fondo;
  Color texto;

  switch (estado) {
    case 'Pagado':
      fondo = AppColors.greenBg;
      texto = AppColors.greenText;
      break;

    case 'Pago parcial':
      fondo = AppColors.orangeBg;
      texto = AppColors.orangeText;
      break;

    case 'Pendiente':
      fondo = AppColors.redBg;
      texto = AppColors.redText;
      break;

    default:
      fondo = AppColors.blueBg;
      texto = AppColors.blueText;
  }

  return Container(
    padding:
        const EdgeInsets.symmetric(
      horizontal: 9,
      vertical: 5,
    ),
    decoration: BoxDecoration(
      color: fondo,
      borderRadius:
          BorderRadius.circular(20),
    ),
    child: Text(
      estado,
      style: TextStyle(
        color: texto,
        fontSize: 9,
        fontWeight:
            FontWeight.w800,
      ),
    ),
  );
}

Widget infoOscura(
  IconData icono,
  String texto,
) {
  return Padding(
    padding:
        const EdgeInsets.symmetric(
      vertical: 6,
    ),
    child: Row(
      children: [
        Icon(
          icono,
          color: AppColors.mint,
          size: 21,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            texto,
            style:
                const TextStyle(
              color: Colors.white,
              fontWeight:
                  FontWeight.w700,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget resumenFila(
  String titulo,
  String valor, {
  bool importante = false,
}) {
  return Padding(
    padding:
        const EdgeInsets.symmetric(
      vertical: 4,
    ),
    child: Row(
      children: [
        Expanded(
          child: Text(
            titulo,
            style:
                const TextStyle(
              color: AppColors
                  .textSecondary,
            ),
          ),
        ),
        Text(
          valor,
          style: TextStyle(
            fontWeight: importante
                ? FontWeight.w900
                : FontWeight.w700,
          ),
        ),
      ],
    ),
  );
}

Widget resumenOscuro(
  String titulo,
  String valor,
) {
  return Padding(
    padding:
        const EdgeInsets.symmetric(
      vertical: 4,
    ),
    child: Row(
      children: [
        Expanded(
          child: Text(
            titulo,
            style:
                const TextStyle(
              color:
                  Colors.white54,
            ),
          ),
        ),
        Text(
          valor,
          style:
              const TextStyle(
            color: Colors.white,
            fontWeight:
                FontWeight.w800,
          ),
        ),
      ],
    ),
  );
}

Widget campoOscuro(
  TextEditingController controller,
  String titulo,
  IconData icono, {
  String? unidad,
}) {
  return Container(
    decoration: BoxDecoration(
      color: AppColors.darkSoft,
      borderRadius:
          BorderRadius.circular(16),
    ),
    child: TextField(
      controller: controller,
      keyboardType:
          const TextInputType
              .numberWithOptions(
        decimal: true,
      ),
      style:
          const TextStyle(
        color: Colors.white,
      ),
      decoration:
          InputDecoration(
        prefixIcon: Icon(
          icono,
          color: Colors.white70,
        ),
        labelText: titulo,
        suffixText: unidad,
        labelStyle:
            const TextStyle(
          color:
              Colors.white54,
        ),
        suffixStyle:
            const TextStyle(
          color:
              Colors.white54,
        ),
        border: InputBorder.none,
      ),
    ),
  );
}

Widget filaBiomasa(
  IconData icono,
  String titulo,
  String valor,
) {
  return Container(
    padding: const EdgeInsets.all(11),
    decoration: BoxDecoration(
      color: AppColors.dark,
      borderRadius:
          BorderRadius.circular(16),
    ),
    child: Row(
      children: [
        Icon(
          icono,
          color: Colors.white,
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            titulo,
            style:
                const TextStyle(
              color:
                  Colors.white70,
            ),
          ),
        ),
        Column(
          crossAxisAlignment:
              CrossAxisAlignment.end,
          children: [
            Text(
              valor,
              style:
                  const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight:
                    FontWeight.w900,
              ),
            ),
            const Text(
              'camarones',
              style: TextStyle(
                color:
                    Colors.white54,
                fontSize: 8,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget unidadBiomasa(
  IconData icono,
  String valor,
  String titulo,
) {
  return Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(
        vertical: 11,
        horizontal: 4,
      ),
      decoration: BoxDecoration(
        color: AppColors.dark,
        borderRadius:
            BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.mint,
              borderRadius:
                  BorderRadius.circular(10),
            ),
            child: Icon(
              icono,
              size: 18,
            ),
          ),
          const SizedBox(height: 7),
          FittedBox(
            child: Text(
              valor,
              style:
                  const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight:
                    FontWeight.w900,
              ),
            ),
          ),
          Text(
            titulo,
            style:
                const TextStyle(
              color:
                  Colors.white60,
              fontSize: 8,
            ),
          ),
        ],
      ),
    ),
  );
}

void mensajeSnack(
  BuildContext context,
  String texto,
) {
  ScaffoldMessenger.of(context)
      .showSnackBar(
    SnackBar(
      content: Text(texto),
      backgroundColor:
          AppColors.black,
      behavior:
          SnackBarBehavior.floating,
    ),
  );
}