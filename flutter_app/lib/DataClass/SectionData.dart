class SectionData {
  List<ArraySection> listSection;

  SectionData({
    this.listSection
  });

  factory SectionData.fromJson(Map<String, dynamic> parseJson){
    var response = parseJson['Response'] as List;

    List<ArraySection> arraySection = response.map((i) =>
        ArraySection.fromJson(i))
        .toList();
    return SectionData(
        listSection: arraySection
    );
  }
}

class ArraySection {
  String sectionId;
  String sectionTitle;

  ArraySection({
    this.sectionId,
    this.sectionTitle
  });

  factory ArraySection.fromJson(Map<String, dynamic> parseJson){
    return ArraySection(
        sectionId: parseJson['section_id'],
        sectionTitle: parseJson['section_title']
    );
  }
}