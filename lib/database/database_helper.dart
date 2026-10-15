part of '../main.dart';

// =============================================================
// BASE DE DATOS LOCAL BIOCAM
// =============================================================

class DatabaseHelper {
  DatabaseHelper._();

  static final DatabaseHelper instance =
      DatabaseHelper._();

  static Database? _database;

  static const String nombreBase =
      'biocam.db';

  static const int versionBase = 1;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _iniciarBase();

    return _database!;
  }

  Future<Database> _iniciarBase() async {
    final rutaBase =
        await getDatabasesPath();

    final rutaCompleta =
        path.join(
      rutaBase,
      nombreBase,
    );

    return openDatabase(
      rutaCompleta,
      version: versionBase,

      onConfigure: (db) async {
        await db.execute(
          'PRAGMA foreign_keys = ON',
        );
      },

      onCreate: (db, version) async {
        await _crearTablas(db);
      },
    );
  }

  Future<void> _crearTablas(
    Database db,
  ) async {
    // =========================================================
    // PESCAS
    // =========================================================

    await db.execute(
      '''
      CREATE TABLE pescas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,

        fecha TEXT NOT NULL,

        persona TEXT NOT NULL DEFAULT '',
        piscina TEXT NOT NULL DEFAULT '',

        gramaje REAL NOT NULL DEFAULT 0,

        unidad TEXT NOT NULL DEFAULT 'LB',

        descuento REAL NOT NULL DEFAULT 0,

        motivo_descuento TEXT NOT NULL DEFAULT '',

        precio REAL NOT NULL DEFAULT 0,

        liquidada INTEGER NOT NULL DEFAULT 0,

        fecha_creacion TEXT NOT NULL
      )
      ''',
    );

    // =========================================================
    // DETALLES DE PESCA
    // =========================================================

    await db.execute(
      '''
      CREATE TABLE detalle_pesca (
        id INTEGER PRIMARY KEY AUTOINCREMENT,

        pesca_id INTEGER NOT NULL,

        cantidad INTEGER NOT NULL DEFAULT 0,

        peso_unitario REAL NOT NULL DEFAULT 0,

        FOREIGN KEY (pesca_id)
          REFERENCES pescas(id)
          ON DELETE CASCADE
      )
      ''',
    );

    // =========================================================
    // PAGOS
    // =========================================================

    await db.execute(
      '''
      CREATE TABLE pagos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,

        pesca_id INTEGER NOT NULL,

        fecha TEXT NOT NULL,

        valor REAL NOT NULL DEFAULT 0,

        forma_pago TEXT NOT NULL DEFAULT '',

        referencia TEXT NOT NULL DEFAULT '',

        observacion TEXT NOT NULL DEFAULT '',

        FOREIGN KEY (pesca_id)
          REFERENCES pescas(id)
          ON DELETE CASCADE
      )
      ''',
    );

    // =========================================================
    // GASTOS DE PESCA
    // Preparada para uso futuro.
    // =========================================================

    await db.execute(
      '''
      CREATE TABLE gastos_pesca (
        id INTEGER PRIMARY KEY AUTOINCREMENT,

        pesca_id INTEGER NOT NULL,

        fecha TEXT NOT NULL,

        categoria TEXT NOT NULL DEFAULT '',

        descripcion TEXT NOT NULL DEFAULT '',

        valor REAL NOT NULL DEFAULT 0,

        FOREIGN KEY (pesca_id)
          REFERENCES pescas(id)
          ON DELETE CASCADE
      )
      ''',
    );

    // =========================================================
    // ÍNDICES
    // =========================================================

    await db.execute(
      '''
      CREATE INDEX idx_detalle_pesca_id
      ON detalle_pesca(pesca_id)
      ''',
    );

    await db.execute(
      '''
      CREATE INDEX idx_pagos_pesca_id
      ON pagos(pesca_id)
      ''',
    );

    await db.execute(
      '''
      CREATE INDEX idx_gastos_pesca_id
      ON gastos_pesca(pesca_id)
      ''',
    );
  }

  // =============================================================
  // CERRAR BASE
  // =============================================================

  Future<void> cerrar() async {
    final db = _database;

    if (db != null) {
      await db.close();
      _database = null;
    }
  }

  // =============================================================
  // RUTA DE LA BASE
  // Será útil cuando hagamos respaldo / restauración.
  // =============================================================

  Future<String> obtenerRutaBase() async {
    final rutaBase =
        await getDatabasesPath();

    return path.join(
      rutaBase,
      nombreBase,
    );
  }
}