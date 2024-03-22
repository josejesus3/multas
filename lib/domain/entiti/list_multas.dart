class ListMultas {
  final int municipio;
  final int status;
  final String? placa;
  final double? cantidad;
  final String? fecha;
  final int? folio;
  final String? folioPago;
  final double? cantidadPago;
  final bool? infraccion;
  final String fechaPago;
  final String? foraneas;

  ListMultas(
      {required this.municipio,
      required this.status,
      this.placa,
      this.cantidad,
      this.fecha,
      this.folio,
      this.folioPago,
      this.cantidadPago,
      this.infraccion,
      required this.fechaPago,
      this.foraneas});
}
