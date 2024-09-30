class Article {
  final int articleId;
  final String slug;
  final int subCategoryId;
  final String title;
  final String body;
  final String articleReferences;
  final String activationDate;
  final String publishStatus;
  final bool adultContent;
  final bool featured;
  final String dateAdded;
  final String dateModified;
  final String bodyClean;
  final String imageUrl;
  final String url;

  Article({
    required this.articleId,
    required this.slug,
    required this.subCategoryId,
    required this.title,
    required this.body,
    required this.articleReferences,
    required this.activationDate,
    required this.publishStatus,
    required this.adultContent,
    required this.featured,
    required this.dateAdded,
    required this.dateModified,
    required this.bodyClean,
    required this.imageUrl,
    required this.url,
  });

  // Factory constructor to create an instance from a JSON map
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      articleId: json['article_id'],
      slug: json['slug'],
      subCategoryId: json['sub_category_id'],
      title: json['title'],
      body: json['body'],
      articleReferences: json['article_references'],
      activationDate: json['activation_date'],
      publishStatus: json['publish_status'],
      adultContent: json['adult_content'] == 1,
      featured: json['featured'] == 1,
      dateAdded: json['date_added'],
      dateModified: json['date_modified'],
      bodyClean: json['body_clean'],
      imageUrl: json['imageUrl'],
      url: json['url'],
    );
  }
}