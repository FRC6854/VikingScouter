Map<String, dynamic> json = {
  "items": [
    {
      "name": "Cargo Ship Hatch Panels Sandstorm",
      "type": "counter",
      "value": 0
    },
    {
      "name": "Cargo Ship Cargo Sandstorm",
      "type": "counter",
      "value": 0
    },
    {
      "name": "Rocket Hatch Panels Sandstorm",
      "type": "counter",
      "value": 0
    },
    {
      "name": "Rocket Cargo Sandstorm",
      "type": "counter",
      "value": 0
    },
    {
      "name": "Autoline Crossed",
      "type": "checkbox",
      "value": 0
    },
    {
      "name": "Cargo Ship Hatch Panels",
      "type": "counter",
      "value": 0
    },
    {
      "name": "Cargo Ship Cargo",
      "type": "counter",
      "value": 0
    },
    {
      "name": "Rocket Hatch Panels",
      "type": "counter",
      "value": 0
    },
    {
      "name": "Rocket Cargo",
      "type": "counter",
      "value": 0
    },
    {
      "name": "Total RP",
      "type": "number",
      "value": 0
    },
    {
      "name": "Total Points for Team",
      "type": "number",
      "value": 0
    },
    {
      "name": "Level of Climb",
      "type": "number",
      "value": 0
    },
    
  ]
};

class ItemsList {
  List<Item> items;

  ItemsList({this.items});

  ItemsList.fromJson(Map<String, dynamic> json) {
    if (json['items'] != null) {
      items = new List<Item>();
      json['items'].forEach((v) {
        items.add(new Item.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null) {
      data['items'] = this.items.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Item {
  String name;
  String type;
  int value;

  Item({this.name, this.type, this.value});

  Item.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    type = json['type'];
    value = json['value'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['type'] = this.type;
    data['value'] = this.value;
    return data;
  }
}
