<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%
    String strNombre = "";
    String strCorreo = "";
    String strCupon = "";
    String strPrecio = "";
    String strCantidad = "";
    String strCuotas = "";

    boolean esPost = "POST".equalsIgnoreCase(request.getMethod());
    boolean hayErrores = false;
    List<String> listaErrores = new ArrayList<String>();

    String codigoCotizacion = "";
    String nombreNormalizado = "";
    String correoNormalizado = "";
    String cuponNormalizado = "";
    boolean aplicaDescuento = false;

    double precioUnitario = 0.0;
    int cantidad = 0;
    int mesesFinanciamiento = 1;
    int correlativoAleatorio = 0;

    double subtotal = 0.0;
    double montoDescuento = 0.0;
    double baseImponible = 0.0;
    double montoInteres = 0.0;
    double totalPagar = 0.0;
    double cuotaMensual = 0.0;

    if (esPost) {
        strNombre = request.getParameter("nombre") != null ? request.getParameter("nombre") : "";
        strCorreo = request.getParameter("correo") != null ? request.getParameter("correo") : "";
        strCupon = request.getParameter("cupon") != null ? request.getParameter("cupon") : "";
        strPrecio = request.getParameter("precio") != null ? request.getParameter("precio") : "";
        strCantidad = request.getParameter("cantidad") != null ? request.getParameter("cantidad") : "";
        strCuotas = request.getParameter("cuotas") != null ? request.getParameter("cuotas") : "";

        try {
            if (strPrecio.trim().isEmpty()) {
                listaErrores.add("El precio unitario no puede estar vacío.");
            } else {
                precioUnitario = Double.parseDouble(strPrecio.trim());
            }
        } catch (NumberFormatException e) {
            listaErrores.add("El precio unitario ingresado ('" + strPrecio + "') no tiene un formato numérico válido.");
        }

        try {
            if (strCantidad.trim().isEmpty()) {
                listaErrores.add("La cantidad de equipos no puede estar vacía.");
            } else {
                cantidad = Integer.parseInt(strCantidad.trim());
            }
        } catch (NumberFormatException e) {
            listaErrores.add("La cantidad de equipos ('" + strCantidad + "') debe ser un número entero.");
        }

        try {
            if (strCuotas.trim().isEmpty()) {
                listaErrores.add("Debe especificar los meses de financiamiento.");
            } else {
                mesesFinanciamiento = Integer.parseInt(strCuotas.trim());
            }
        } catch (NumberFormatException e) {
            listaErrores.add("Los meses de financiamiento ('" + strCuotas + "') deben ser un número entero.");
        }

        // Angie Evangelista
        nombreNormalizado = strNombre.trim();
        correoNormalizado = strCorreo.trim().toLowerCase();
        cuponNormalizado = strCupon.trim().toUpperCase();

        String nombreSinEspacios = nombreNormalizado.replace(" ", "");
        if (nombreSinEspacios.isEmpty() || nombreSinEspacios.length() < 3) {
            listaErrores.add("El nombre del cliente debe tener al menos 3 caracteres útiles (sin contar espacios).");
        }

        if (!correoNormalizado.contains("@")) {
            listaErrores.add("El correo electrónico debe incluir el carácter obligatorio '@'.");
        } else if (!correoNormalizado.endsWith(".com") && !correoNormalizado.endsWith(".pe")) {
            listaErrores.add("El correo electrónico debe terminar con el dominio '.com' o '.pe'.");
        }

        if (cuponNormalizado.equalsIgnoreCase("PROMO10")) {
            aplicaDescuento = true;
        }


        // Dante Alanya Molina

                    if (listaErrores.isEmpty()) {
                    correlativoAleatorio = (int) Math.floor(Math.random() * 9000.0 + 1000.0);

                    String prefijoNombre = nombreSinEspacios.substring(0, 3).toUpperCase();
                    codigoCotizacion = "COT-".concat(prefijoNombre).concat("-").concat(String.valueOf(correlativoAleatorio));

                    precioUnitario = Math.max(0.01, precioUnitario);
                    cantidad = Math.max(1, cantidad);
                    mesesFinanciamiento = Math.min(12, Math.max(1, mesesFinanciamiento));

                    subtotal = precioUnitario * cantidad;

                    if (aplicaDescuento) {
                        montoDescuento = subtotal * 0.10;
                    } else {
                        montoDescuento = 0.0;
                    }
                    baseImponible = subtotal - montoDescuento;

                    if (mesesFinanciamiento > 1) {
                        double factorInteres = Math.pow(1.02, mesesFinanciamiento);
                        double totalConInteres = baseImponible * factorInteres;
                        montoInteres = totalConInteres - baseImponible;
                        totalPagar = totalConInteres;
                    } else {
                        montoInteres = 0.0;
                        totalPagar = baseImponible;
                    }

                    totalPagar = Math.round(totalPagar * 100.0) / 100.0;
                    cuotaMensual = Math.ceil(totalPagar / mesesFinanciamiento);
                } else {
                    hayErrores = true;
                }

    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cotizador de Equipos | PA2 - POO (30626)</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light py-4">

<div class="container" style="max-width: 900px;">
    <div class="bg-white p-4 rounded border mb-4">
        <h4 class="fw-bold mb-1">Cotizador de Equipos</h4>
        <div class="text-secondary small mb-2">Evaluación PA2 - Programación Orientada a Objetos (NRC 30626)</div>
    </div>
    <%-- Jesus García--%>
    <div class="row g-4">
        <div class="col-md-6">
            <div class="bg-white p-4 rounded border">
                <h5 class="mb-3">Formulario de Cotización</h5>
                <form action="index.jsp" method="POST">

                    <div class="mb-3">
                        <label for="nombre" class="form-label small fw-semibold">Nombre del Cliente:</label>
                        <input type="text" class="form-control form-control-sm" id="nombre" name="nombre" value="<%= strNombre %>" required>
                    </div>

                    <div class="mb-3">
                        <label for="correo" class="form-label small fw-semibold">Correo Electrónico:</label>
                        <input type="text" class="form-control form-control-sm" id="correo" name="correo" value="<%= strCorreo %>" required>
                    </div>

                    <div class="mb-3">
                        <label for="cupon" class="form-label small fw-semibold">Cupón de Descuento:</label>
                        <input type="text" class="form-control form-control-sm text-uppercase" id="cupon" name="cupon" value="<%= strCupon %>" placeholder="PROMO10">
                    </div>

                    <div class="row g-2 mb-3">
                        <div class="col-6">
                            <label for="precio" class="form-label small fw-semibold">Precio (S/):</label>
                            <input type="number" class="form-control form-control-sm" id="precio" name="precio" step="0.01" min="1" value="<%= strPrecio %>" required>
                        </div>
                        <div class="col-6">
                            <label for="cantidad" class="form-label small fw-semibold">Cantidad:</label>
                            <input type="number" class="form-control form-control-sm" id="cantidad" name="cantidad" min="1" max="100" value="<%= strCantidad %>" required>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="cuotas" class="form-label small fw-semibold">Meses de Financiamiento:</label>
                        <select class="form-select form-select-sm" id="cuotas" name="cuotas">
                            <% for (int i = 1; i <= 12; i++) { %>
                            <option value="<%= i %>" <%= (strCuotas.equals(String.valueOf(i)) ? "selected" : "") %>>
                                <%= i == 1 ? "1 mes (Al contado)" : (i + " meses") %>
                            </option>
                            <% } %>
                        </select>
                    </div>

                    <button type="submit" class="btn btn-primary btn-sm w-100">Procesar Cotización</button>
                </form>
        </div>
    </div>

        <div class="col-md-6">
            <% if (!esPost) { %>
                <div class="bg-white p-4 rounded border text-muted small text-center">
                    Ingrese los datos del formulario y presione "Procesar Cotización".
                </div>

            <% } else if (hayErrores) { %>
                <div class="alert alert-danger small p-3 rounded border">
                    <div class="fw-bold mb-2">Errores encontrados:</div>
                    <ul class="mb-0 ps-3">
                        <% for (String err : listaErrores) { %>
                            <li><%= err %></li>
                        <% } %>
                    </ul>
                </div>

            <% } else { %>
                <div class="bg-white p-4 rounded border">
                    <div class="d-flex justify-content-between align-items-center border-bottom pb-2 mb-3">
                        <h5 class="mb-0">Resumen de Cotización</h5>
                        <span class="badge bg-secondary"><%= codigoCotizacion %></span>
                    </div>

                    <table class="table table-sm table-bordered small mb-0">
                        <tbody>
                            <tr>
                                <th class="bg-light" style="width: 45%;">Cliente</th>
                                <td><%= nombreNormalizado %></td>
                            </tr>
                            <tr>
                                <th class="bg-light">Correo</th>
                                <td><%= correoNormalizado %></td>
                            </tr>
                            <tr>
                                <th class="bg-light">Precio Unitario</th>
                                <td>S/ <%= String.format("%.2f", precioUnitario) %></td>
                            </tr>
                            <tr>
                                <th class="bg-light">Cantidad</th>
                                <td><%= cantidad %></td>
                            </tr>
                            <tr>
                                <th class="bg-light">Subtotal</th>
                                <td>S/ <%= String.format("%.2f", subtotal) %></td>
                            </tr>
                            <tr>
                                <th class="bg-light">Cupón</th>
                                <td><%= aplicaDescuento ? "PROMO10 (-10%)" : "No aplica" %></td>
                            </tr>
                            <% if (aplicaDescuento) { %>
                                <tr>
                                    <th class="bg-light">Descuento</th>
                                    <td>- S/ <%= String.format("%.2f", montoDescuento) %></td>
                                </tr>
                            <% } %>
                            <tr>
                                <th class="bg-light">Plazo</th>
                                <td><%= mesesFinanciamiento %> <%= mesesFinanciamiento == 1 ? "mes" : "meses" %></td>
                            </tr>
                            <% if (mesesFinanciamiento > 1) { %>
                                <tr>
                                    <th class="bg-light">Interés Compuesto</th>
                                    <td>+ S/ <%= String.format("%.2f", montoInteres) %></td>
                                </tr>
                            <% } %>
                            <tr class="table-light fw-bold">
                                <th>Total a Pagar</th>
                                <td>S/ <%= String.format("%.2f", totalPagar) %></td>
                            </tr>
                            <tr>
                                <th class="bg-light">Cuota Mensual</th>
                                <td>S/ <%= String.format("%.2f", cuotaMensual) %></td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            <% } %>
        </div>


</div>

</body>
</html>
