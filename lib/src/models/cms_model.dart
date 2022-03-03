class CMSModel {
  FillIns fillIns;
  Meta meta;
  List<String> modules;
  String name;
  bool neglectUtterences;
  Response response;
  String type;
  Utterences utterences;

  CMSModel(
      {this.fillIns,
      this.meta,
      this.modules,
      this.name,
      this.neglectUtterences,
      this.response,
      this.type,
      this.utterences});

  CMSModel.fromJson(Map<String, dynamic> json) {
    fillIns = json['fill_ins'] != null
        ? new FillIns.fromJson(json['fill_ins'])
        : null;
    meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
    modules = json['modules'].cast<String>();
    name = json['name'];
    neglectUtterences = json['neglect_utterences'];
    response = json['response'] != null
        ? new Response.fromJson(json['response'])
        : null;
    type = json['type'];
    utterences = json['utterences'] != null
        ? new Utterences.fromJson(json['utterences'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.fillIns != null) {
      data['fill_ins'] = this.fillIns.toJson();
    }
    if (this.meta != null) {
      data['meta'] = this.meta.toJson();
    }
    data['modules'] = this.modules;
    data['name'] = this.name;
    data['neglect_utterences'] = this.neglectUtterences;
    if (this.response != null) {
      data['response'] = this.response.toJson();
    }
    data['type'] = this.type;
    if (this.utterences != null) {
      data['utterences'] = this.utterences.toJson();
    }
    return data;
  }
}

class FillIns {
  String joke;

  FillIns({this.joke});

  FillIns.fromJson(Map<String, dynamic> json) {
    joke = json['joke'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['joke'] = this.joke;
    return data;
  }
}

class Meta {
  String language;
  String type;

  Meta({this.language, this.type});

  Meta.fromJson(Map<String, dynamic> json) {
    language = json['language'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['language'] = this.language;
    data['type'] = this.type;
    return data;
  }
}

class Response {
  String enGB;

  Response({this.enGB});

  Response.fromJson(Map<String, dynamic> json) {
    enGB = json['en-GB'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['en-GB'] = this.enGB;
    return data;
  }
}

class Utterences {
  List<String> enGB;

  Utterences({this.enGB});

  Utterences.fromJson(Map<String, dynamic> json) {
    enGB = json['en-GB'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['en-GB'] = this.enGB;
    return data;
  }
}
