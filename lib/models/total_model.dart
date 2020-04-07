class TotalModel {
  int cases;
  int todayCases;
  int deaths;
  int todayDeaths;
  int recovered;
  int active;
  int critical;

  TotalModel(
      {this.cases,
      this.todayCases,
      this.deaths,
      this.todayDeaths,
      this.recovered,
      this.active,
      this.critical});

  TotalModel.fromJson(Map<String, dynamic> json) {
    cases = json['cases'];
    todayCases = json['todayCases'];
    deaths = json['deaths'];
    todayDeaths = json['todayDeaths'];
    recovered = json['recovered'];
    active = json['active'];
    critical = json['critical'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cases'] = this.cases;
    data['todayCases'] = this.todayCases;
    data['deaths'] = this.deaths;
    data['todayDeaths'] = this.todayDeaths;
    data['recovered'] = this.recovered;
    data['active'] = this.active;
    data['critical'] = this.critical;
    return data;
  }
}

