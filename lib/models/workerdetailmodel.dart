
class Worker {
  Medicalinformation? medicalinformation;
  String? sId;
  String? workername;
  String? workeremail;
  int? workernumber;
  String? images;
  String? birthdate;
  int? adharnumber;
  String? createdAt;
  int? iV;

  Worker(
      {this.medicalinformation,
      this.sId,
      this.workername,
      this.workeremail,
      this.workernumber,
      this.images,
      this.birthdate,
      this.adharnumber,
      this.createdAt,
      this.iV});

  Worker.fromJson(Map<String, dynamic> json) {
    medicalinformation = json['medicalinformation'] != null
        ? new Medicalinformation.fromJson(json['medicalinformation'])
        : null;
    sId = json['_id'];
    workername = json['workername'];
    workeremail = json['workeremail'];
    workernumber = json['workernumber'];
    images = json['images'];
    birthdate = json['birthdate'];
    adharnumber = json['adharnumber'];
    createdAt = json['createdAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.medicalinformation != null) {
      data['medicalinformation'] = this.medicalinformation!.toJson();
    }
    data['_id'] = this.sId;
    data['workername'] = this.workername;
    data['workeremail'] = this.workeremail;
    data['workernumber'] = this.workernumber;
    data['images'] = this.images;
    data['birthdate'] = this.birthdate;
    data['adharnumber'] = this.adharnumber;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    return data;
  }
}

class Medicalinformation {
  int? age;
  String? gender;
  int? height;
  int? weight;
  String? bloodgroup;

  Medicalinformation(
      {this.age, this.gender, this.height, this.weight, this.bloodgroup});

  Medicalinformation.fromJson(Map<String, dynamic> json) {
    age = json['age'];
    gender = json['gender'];
    height = json['height'];
    weight = json['weight'];
    bloodgroup = json['bloodgroup'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['age'] = this.age;
    data['gender'] = this.gender;
    data['height'] = this.height;
    data['weight'] = this.weight;
    data['bloodgroup'] = this.bloodgroup;
    return data;
  }
}