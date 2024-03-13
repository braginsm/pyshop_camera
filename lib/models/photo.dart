class Photo {
  const Photo(
      {required this.comment, required this.point, required this.filePath});

  final String comment;
  final ({double latitude, double longitude}) point;
  final String filePath;
}
