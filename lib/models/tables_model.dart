class TablesModel {
  int? id;
  bool? isReserved;
  String? tableNumber;
  int? capacity;
  String? restaurant;

  TablesModel(
      {this.id,
        this.isReserved,
        this.tableNumber,
        this.capacity,
        this.restaurant});

  TablesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isReserved = json['is_reserved'];
    tableNumber = json['table_number'];
    capacity = json['capacity'];
    restaurant = json['restaurant'];
  }

  Map<String, dynamic> toJson(int option) {
    final Map<String, dynamic> data = <String, dynamic>{};
    if(option != 0){
      data['id'] = id.toString();
    }
    data['is_reserved'] = isReserved.toString();
    data['table_number'] = tableNumber.toString();
    data['capacity'] = capacity.toString();
    data['restaurant'] = restaurant.toString();
    return data;
  }
}