part of '../main.dart';

// =============================================================
// DATOS DE BIOCAM
// WEB: memoria temporal
// ANDROID: SQLite local
// =============================================================

class AppData {
  static int nextPescaId = 1;
  static int nextPagoId = 1;

  static final List<Pesca> pescas = [];

  // =============================================================
  // SABER SI DEBEMOS USAR SQLITE
  // =============================================================

  static bool get usarBaseLocal {
    if (kIsWeb) {
      return false;
    }

    return defaultTargetPlatform ==
        TargetPlatform.android;
  }

  // =============================================================
  // INICIALIZAR DATOS
  // =============================================================

  static Future<void> inicializar() async {
    if (!usarBaseLocal) {
      return;
    }

    final db =
        await DatabaseHelper.instance.database;

    pescas.clear();

    final pescasGuardadas =
        await db.query(
      'pescas',
      orderBy: 'id DESC',
    );

    int mayorPescaId = 0;
    int mayorPagoId = 0;

    for (final fila in pescasGuardadas) {
      final pescaId =
          fila['id'] as int;

      if (pescaId > mayorPescaId) {
        mayorPescaId = pescaId;
      }

      // ---------------------------------------------------------
      // DETALLES DE LA PESCA
      // ---------------------------------------------------------

      final detallesGuardados =
          await db.query(
        'detalle_pesca',
        where: 'pesca_id = ?',
        whereArgs: [pescaId],
        orderBy: 'id ASC',
      );

      final detalles =
          detallesGuardados.map(
        (detalle) {
          return DetallePesca(
            cantidad:
                detalle['cantidad'] as int,
            pesoUnitario:
                (detalle['peso_unitario']
                        as num)
                    .toDouble(),
          );
        },
      ).toList();

      // ---------------------------------------------------------
      // PAGOS DE LA PESCA
      // ---------------------------------------------------------

      final pagosGuardados =
          await db.query(
        'pagos',
        where: 'pesca_id = ?',
        whereArgs: [pescaId],
        orderBy: 'id ASC',
      );

      final pagos =
          pagosGuardados.map(
        (filaPago) {
          final pagoId =
              filaPago['id'] as int;

          if (pagoId > mayorPagoId) {
            mayorPagoId = pagoId;
          }

          return Pago(
            id: pagoId,
            fecha: DateTime.parse(
              filaPago['fecha'] as String,
            ),
            valor:
                (filaPago['valor'] as num)
                    .toDouble(),
            formaPago:
                filaPago['forma_pago']
                    as String,
            referencia:
                filaPago['referencia']
                    as String,
            observacion:
                filaPago['observacion']
                    as String,
          );
        },
      ).toList();

      // ---------------------------------------------------------
      // CREAR OBJETO PESCA
      // ---------------------------------------------------------

      final pesca = Pesca(
        id: pescaId,
        fecha: DateTime.parse(
          fila['fecha'] as String,
        ),
        persona:
            fila['persona'] as String,
        piscina:
            fila['piscina'] as String,
        gramaje:
            (fila['gramaje'] as num)
                .toDouble(),
        unidad:
            fila['unidad'] as String,
        detalles: detalles,
        pagos: pagos,
        descuento:
            (fila['descuento'] as num)
                .toDouble(),
        motivoDescuento:
            fila['motivo_descuento']
                as String,
        precio:
            (fila['precio'] as num)
                .toDouble(),
        liquidada:
            (fila['liquidada'] as int) ==
                1,
      );

      pescas.add(pesca);
    }

    nextPescaId =
        mayorPescaId + 1;

    nextPagoId =
        mayorPagoId + 1;
  }

  // =============================================================
  // CREAR PESCA
  // =============================================================

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
              pesoUnitario:
                  item.pesoUnitario,
            ),
          )
          .toList(),
    );

    pescas.insert(
      0,
      pesca,
    );

    if (usarBaseLocal) {
      guardarPesca(pesca);
    }

    return pesca;
  }

  // =============================================================
  // CREAR PAGO
  // =============================================================

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

  // =============================================================
  // GUARDAR PESCA COMPLETA
  // =============================================================

  static Future<void> guardarPesca(
    Pesca pesca,
  ) async {
    if (!usarBaseLocal) {
      return;
    }

    final db =
        await DatabaseHelper.instance.database;

    await db.transaction(
      (txn) async {
        // -------------------------------------------------------
        // PESCA
        // -------------------------------------------------------

        await txn.insert(
          'pescas',
          {
            'id': pesca.id,
            'fecha':
                pesca.fecha.toIso8601String(),
            'persona':
                pesca.persona,
            'piscina':
                pesca.piscina,
            'gramaje':
                pesca.gramaje,
            'unidad':
                pesca.unidad,
            'descuento':
                pesca.descuento,
            'motivo_descuento':
                pesca.motivoDescuento,
            'precio':
                pesca.precio,
            'liquidada':
                pesca.liquidada ? 1 : 0,
            'fecha_creacion':
                DateTime.now()
                    .toIso8601String(),
          },
          conflictAlgorithm:
              ConflictAlgorithm.replace,
        );

        // -------------------------------------------------------
        // DETALLES
        // -------------------------------------------------------

        await txn.delete(
          'detalle_pesca',
          where: 'pesca_id = ?',
          whereArgs: [
            pesca.id,
          ],
        );

        for (final detalle
            in pesca.detalles) {
          await txn.insert(
            'detalle_pesca',
            {
              'pesca_id':
                  pesca.id,
              'cantidad':
                  detalle.cantidad,
              'peso_unitario':
                  detalle.pesoUnitario,
            },
          );
        }

        // -------------------------------------------------------
        // PAGOS
        // -------------------------------------------------------

        await txn.delete(
          'pagos',
          where: 'pesca_id = ?',
          whereArgs: [
            pesca.id,
          ],
        );

        for (final pago
            in pesca.pagos) {
          await txn.insert(
            'pagos',
            {
              'id':
                  pago.id,
              'pesca_id':
                  pesca.id,
              'fecha':
                  pago.fecha
                      .toIso8601String(),
              'valor':
                  pago.valor,
              'forma_pago':
                  pago.formaPago,
              'referencia':
                  pago.referencia,
              'observacion':
                  pago.observacion,
            },
            conflictAlgorithm:
                ConflictAlgorithm.replace,
          );
        }
      },
    );
  }

  // =============================================================
  // GUARDAR PAGO
  // =============================================================

  static Future<void> guardarPago(
    Pesca pesca,
  ) async {
    await guardarPesca(
      pesca,
    );
  }

  // =============================================================
  // GUARDAR CAMBIOS DE LIQUIDACIÓN
  // =============================================================

  static Future<void> guardarLiquidacion(
    Pesca pesca,
  ) async {
    await guardarPesca(
      pesca,
    );
  }

  // =============================================================
  // GUARDAR EDICIÓN DE PESCA
  // =============================================================

  static Future<void> guardarEdicionPesca(
    Pesca pesca,
  ) async {
    await guardarPesca(
      pesca,
    );
  }

  // =============================================================
  // ELIMINAR PESCA
  // =============================================================

  static void eliminarPesca(
    Pesca pesca,
  ) {
    pescas.remove(
      pesca,
    );

    if (usarBaseLocal) {
      _eliminarPescaBase(
        pesca.id,
      );
    }
  }

  static Future<void> _eliminarPescaBase(
    int pescaId,
  ) async {
    if (!usarBaseLocal) {
      return;
    }

    final db =
        await DatabaseHelper.instance.database;

    await db.delete(
      'pescas',
      where: 'id = ?',
      whereArgs: [
        pescaId,
      ],
    );
  }

  // =============================================================
  // GUARDAR TODA LA INFORMACIÓN
  // =============================================================

  static Future<void> guardarTodo() async {
    if (!usarBaseLocal) {
      return;
    }

    for (final pesca in pescas) {
      await guardarPesca(
        pesca,
      );
    }
  }
}