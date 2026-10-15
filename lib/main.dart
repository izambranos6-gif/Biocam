import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:flutter/foundation.dart';

part 'config/app_colors.dart';
part 'config/app_settings.dart';
part 'models/pesca_models.dart';
part 'data/app_data.dart';
part 'utils/formatos.dart';
part 'app.dart';
part 'pages/main_page.dart';
part 'pages/inicio_page.dart';
part 'pages/biomasa/biomasa_page.dart';
part 'pages/pescas/nueva_pesca_page.dart';
part 'pages/pescas/historial_page.dart';
part 'pages/pescas/detalle_pesca_page.dart';
part 'pages/pescas/editar_pesca_page.dart';
part 'pages/pescas/liquidacion_page.dart';
part 'pages/pescas/pagos_page.dart';
part 'widgets/app_widgets.dart';
part 'database/database_helper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppData.inicializar();

  runApp(const BiocamApp());
}
