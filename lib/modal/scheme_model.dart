class Scheme {
  List<String>? applicationProcess;
  List<String>? documentsRequired;
  List<String>? eligibility;
  String? officialWebsite;
  String? schemeName;
  String? type;

  Scheme({
    this.applicationProcess,
    this.documentsRequired,
    this.eligibility,
    this.officialWebsite,
    this.schemeName,
    this.type,
  });

  factory Scheme.fromJson(Map<String, dynamic> json) {
    return Scheme(
      applicationProcess: List<String>.from(json['application_process'] ?? []),
      documentsRequired: List<String>.from(json['documents_required'] ?? []),
      eligibility: List<String>.from(json['eligibility'] ?? []),
      officialWebsite: json['official_website'],
      schemeName: json['scheme_name'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'application_process': applicationProcess,
      'documents_required': documentsRequired,
      'eligibility': eligibility,
      'official_website': officialWebsite,
      'scheme_name': schemeName,
      'type': type,
    };
  }
}
