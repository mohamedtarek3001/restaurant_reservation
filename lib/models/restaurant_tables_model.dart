class RestaurantTablesModel {
  int? id;
  bool? isReserved;
  String? tableNumber;
  int? capacity;

  RestaurantTablesModel(
      {this.id, this.isReserved, this.tableNumber, this.capacity});

  RestaurantTablesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isReserved = json['is_reserved'];
    tableNumber = json['table_number'];
    capacity = json['capacity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['is_reserved'] = this.isReserved;
    data['table_number'] = this.tableNumber;
    data['capacity'] = this.capacity;
    return data;
  }
}