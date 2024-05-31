class ReservationRequestModel {
  String? restaurant;
  String? desertItems;
  String? table;
  DateTime? reservationTime;
  String? totalPrice;
  String? menuItems;
  String? OrderName;

  ReservationRequestModel(
      {this.restaurant,
        this.desertItems,
        this.table,
        this.reservationTime,
        this.totalPrice,
        this.menuItems,this.OrderName,});

  ReservationRequestModel.fromJson(Map<String, dynamic> json) {
    restaurant = json['restaurant'];
    desertItems = json['Desert_items'];
    table = json['table'];
    reservationTime = DateTime.tryParse(json['reservation_time'].toString());
    totalPrice = json['total_price'];
    menuItems = json['menu_items'];
    OrderName = json['order_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['restaurant'] = restaurant;
    data['Desert_items'] = desertItems;
    data['table'] = table;
    data['reservation_time'] = DateTime.now().toIso8601String();
    data['total_price'] = totalPrice;
    data['menu_items'] = menuItems;
    data['order_name'] = OrderName;
    return data;
  }
}