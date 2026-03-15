class PaginationModel {
  final int currentPage;
  final int totalPages;
  final bool hasNext;

  const PaginationModel({
    required this.currentPage,
    required this.totalPages,
    required this.hasNext,
  });
}