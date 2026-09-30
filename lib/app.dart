part of 'main.dart';

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
