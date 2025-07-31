class SchemeModel {
  final String schemeName;
  final String type;
  final String eligibility;
  final String documentsRequired;
  final String applicationProcess;
  final String officialWebsite;

  SchemeModel({
    required this.schemeName,
    required this.type,
    required this.eligibility,
    required this.documentsRequired,
    required this.applicationProcess,
    required this.officialWebsite,
  });

  /// Convert from Firestore/DB map to SchemeModel
  factory SchemeModel.fromMap(Map<String, dynamic> map) {
    return SchemeModel(
      schemeName: map['scheme_name'] ?? '',
      type: map['type'] ?? '',
      eligibility: map['eligibility'] ?? '',
      documentsRequired: map['documents'] ?? '',
      applicationProcess: map['application_process'] ?? '',
      officialWebsite: map['website'] ?? '',
    );
  }

  /// Convert to Map for Firestore or local DB
  Map<String, dynamic> toMap() {
    return {
      'scheme_name': schemeName,
      'type': type,
      'eligibility': eligibility,
      'documents': documentsRequired,
      'application_process': applicationProcess,
      'website': officialWebsite,
    };
  }
}
