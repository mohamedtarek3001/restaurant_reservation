class ReservationsModel {
  int? id;
  int? customer;
  int? restaurant;
  List<int>? menuItems;
  List<int>? desertItems;
  int? table;
  String? reservationTime;
  String? totalPrice;
  String? orderName;

  ReservationsModel(
      {this.id,
        this.customer,
        this.restaurant,
        this.menuItems,
        this.desertItems,
        this.table,
        this.reservationTime,
        this.totalPrice,
        this.orderName,
      });

  ReservationsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    customer = json['customer'];
    restaurant = json['restaurant'];
    menuItems = json['menu_items'].cast<int>();
    desertItems = json['Desert_items'].cast<int>();
    table = json['table'];
    reservationTime = json['reservation_time'];
    totalPrice = json['total_price'];
    orderName = json['order_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['customer'] = this.customer;
    data['restaurant'] = this.restaurant;
    data['menu_items'] = this.menuItems;
    data['Desert_items'] = this.desertItems;
    data['table'] = this.table;
    data['reservation_time'] = this.reservationTime;
    data['total_price'] = this.totalPrice;
    data['order_name'] = this.orderName;
    return data;
  }
}