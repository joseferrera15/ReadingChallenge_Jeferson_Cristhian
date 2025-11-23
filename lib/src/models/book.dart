class Book
{
  final String id;
  final String title;
  final String author;
  final String coverImage;
  final int currentPage;
  final int totalPages;
  final String status; 

  Book({
    required this.id,
    required this.title,
    required this.author,
    this.coverImage = "",
    required this.currentPage,
    required this.totalPages,
    required this.status,
  });

  factory Book.fromJson(Map<String, dynamic> json) => Book(
    id: json['id'], 
    title: json['title'],
    author: json['author'],
    coverImage: json['cover'], //!= null ? NetworkImage(json['coverImage']) : null,
    currentPage: json['currentPage'],
    totalPages: json['totalPages'],
    status: json['status'],
  );

  Map<String, dynamic> toJson()
  {
    return 
    {
      'title': title,
      'author': author,
      'cover': coverImage,// != null ? (coverImage as NetworkImage).url : null,
      'currentPage': currentPage,
      'totalPages': totalPages,
      'status': status,
    };
  }
}