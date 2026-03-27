class Song {
  final String id;
  final String title;
  final String artistId;
  final Duration duration;
  final String imageUrl;

  final String? artistName;
  final String? artistGenre;

  Song({
    required this.id,
    required this.title,
    required this.artistId,
    required this.duration, 
    required this.imageUrl,
    this.artistName,
    this.artistGenre,
  });

  @override
  String toString() {
    return 'Song(id: $id, title: $title, artist: $artistId, duration: $duration, image: $imageUrl, genre: $artistGenre, artistName: $artistName)';
  }
}
