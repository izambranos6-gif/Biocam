part of '../main.dart';

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
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 3,
        ),
        child: Row(
          children: [
            Icon(
              icono,
              color: Colors.white70,
              size: 22,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: controller,
                keyboardType:
                    const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                style: const TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  labelText: titulo,
                  labelStyle: const TextStyle(
                    color: Colors.white54,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding:
                      const EdgeInsets.symmetric(
                    vertical: 15,
                  ),
                ),
              ),
            ),
            if (unidad != null) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Text(
                  unidad,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ],
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
              const SizedBox(height: 2),
              Text(
                titulo,
                style:
                    const TextStyle(
                  color:
                      Colors.white70,
                  fontSize: 13,
                  fontWeight:
                      FontWeight.w700,
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
