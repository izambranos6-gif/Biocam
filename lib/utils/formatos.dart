part of '../main.dart';

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
