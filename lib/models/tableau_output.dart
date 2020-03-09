class TableauOutput {
  int team;
  int match;
  int scout;
  int time;
  List<Map<String, dynamic>> metrics;

  TableauOutput({this.team, this.match, this.scout, this.time, this.metrics});

  TableauOutput.fromJson(Map<String, dynamic> json) {
    team = json['team'];
    match = json['match'];
    scout = json['scout'];
    time = json['time'];
    if (json['metrics'] != null) {
      metrics = new List<dynamic>();
      json['metrics'].forEach((v) {
        metrics.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['team'] = this.team;
    data['match'] = this.match;
    data['scout'] = this.scout;
    data['time'] = this.time;
    if (this.metrics != null) {
      data['metrics'] = this.metrics.map((v) => v).toList();
    }
    return data;
  }
}