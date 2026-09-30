part of '../main.dart';

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
