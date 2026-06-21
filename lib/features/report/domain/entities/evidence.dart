import 'package:equatable/equatable.dart';

class Evidence extends Equatable {
  final String url;
  final String? thumbnailUrl;

  const Evidence({required this.url, this.thumbnailUrl});

  String get previewUrl => thumbnailUrl ?? url;

  bool get isVideo => thumbnailUrl != null;

  @override
  List<Object?> get props => [url, thumbnailUrl];
}
