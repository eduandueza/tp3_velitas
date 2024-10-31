enum OrderState  { CANCELADO, EN_CURSO, ENTREGADO }

extension OrderStateExtension on OrderState {
  String get name {
    switch (this) {
      case OrderState.CANCELADO:
        return "Cancelado";
      case OrderState.EN_CURSO:
        return "En Curso";
      case OrderState.ENTREGADO:
        return "Entregado";
      default:
        return "";
    }
  }
}