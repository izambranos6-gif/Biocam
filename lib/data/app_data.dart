part of '../main.dart';

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
