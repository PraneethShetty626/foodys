class FoodItem {
  final String img_url;
  final String name;

  final int price;
  final bool available;

  FoodItem(
      {required this.name,
      required this.img_url,
      required this.price,
      required this.available});

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
        img_url: json['img_url'] ?? "",
        name: json['name'],
        price: json['price'],
        available: json['available']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = name;
    data['img_url'] = img_url;
    data['price'] = price;
    data['available'] = available;

    return data;
  }
}

// List<FoodItem> cachedRestaurantList = [
//   FoodItem(
//     name: "Molon Lave",
//   img_url:"assets/logo.jpg",
//     price: "30",
//     available: true
//   ),
//   FoodItem(
  
//        img_url: "assets/logo.jpg",

//     name: "Bostan Barista",
   
//     price: "50",
//     available: true
   
//   ),
//   FoodItem(
   
//        img_url: "assets/logo.jpg",

//     name: "Family Bean",
//     price: "45",
//     available: true
//   ),
//   FoodItem(
//     img_url: "assets/logo.jpg",

//     name: "Power House",
//     price: "28",
//     available: true
//   ),
//   FoodItem(
//     img_url: "assets/logo.jpg",
    
//     name: "Lureme",
//     price: "55",
//     available: true
//   ),
//    FoodItem(
//     name: "1",
//     img_url: "assets/logo.jpg",
//     price: "30",
//     available: true
//   ),
//   FoodItem(
//     name: "2",
//        img_url: "assets/logo.jpg",

//     price: "50",
//     available: true
//   ),
//   FoodItem(
//     name: "3",
//        img_url: "assets/logo.jpg",

//     price: "45",
//     available: true
//   ),
//   FoodItem(
//     name: "4",
//     img_url: "assets/logo.jpg",

//     price: "28",
//     available: true
//   ),
//   FoodItem(
//     img_url: "assets/logo.jpg",
    
//     name: "Lureme",
//     price: "55",
//     available: true
//   ),
// ];


