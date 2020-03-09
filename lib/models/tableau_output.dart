class TableauOutput {
  int team;
  int match;
  int scout;
  int time;
  Metrics metrics;

  TableauOutput({this.team, this.match, this.scout, this.time, this.metrics});

  TableauOutput.fromJson(Map<String, dynamic> json) {
    team = json['team'];
    match = json['match'];
    scout = json['scout'];
    time = json['time'];
    metrics =
    json['metrics'] != null ? new Metrics.fromJson(json['metrics']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['team'] = this.team;
    data['match'] = this.match;
    data['scout'] = this.scout;
    data['time'] = this.time;
    if (this.metrics != null) {
      data['metrics'] = this.metrics.toJson();
    }
    return data;
  }
}

class Metrics {
  Map<String, dynamic> values;

  Metrics({values});

  Metrics.fromJson(Map<String, dynamic> json) {
    values = json;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    this.values.forEach((k, v) =>
        data[k] = this.values[k]
    );
    return data;
  }
}