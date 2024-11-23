class Video {
  final int id;
  final String title;
  final String description;
  final String videoUrl;
  final String videoType;

  Video({
    required this.id,
    required this.title,
    required this.description,
    required this.videoUrl,
    required this.videoType,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    return Video(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      videoUrl: json['video_url'],
      videoType: json['video_type'],
    );
  }
}
