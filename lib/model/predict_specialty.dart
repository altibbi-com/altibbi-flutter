class SubCategory {
  final int subCategoryId;
  final String nameEn;
  final String nameAr;

  SubCategory({
    required this.subCategoryId,
    required this.nameEn,
    required this.nameAr,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      subCategoryId: json['sub_category_id'] as int,
      nameEn: json['name_en'] as String,
      nameAr: json['name_ar'] as String,
    );
  }
}

class PredictSpecialty {
  final int specialtyId;
  final List<SubCategory> subCategories;

  PredictSpecialty({
    required this.specialtyId,
    required this.subCategories,
  });

  factory PredictSpecialty.fromJson(Map<String, dynamic> json) {
    var subCategoriesJson = json['subCategories'] as List;
    List<SubCategory> subCategoryList = subCategoriesJson
        .map((subCategoryJson) => SubCategory.fromJson(subCategoryJson))
        .toList();

    return PredictSpecialty(
      specialtyId: json['specialty_id'] as int,
      subCategories: subCategoryList,
    );
  }
}