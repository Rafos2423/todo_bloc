class Todo {
  final String title;
  final String subtitle;
  bool isDone;
  bool isPinned;
  int indexPinned;

  Todo({this.title = '', this.subtitle = '', this.isDone = false, this.isPinned = false, this.indexPinned = -1});

  Todo copyWith({
    String? title,
    String? subtitle,
    bool? isDone,
    bool? isPinned,
    int? indexPinned,
  }) {
    return Todo(
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      isDone: isDone ?? this.isDone,
      isPinned: isPinned ?? this.isPinned,
      indexPinned: indexPinned ?? this.indexPinned,
    );
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
        title: json['title'],
        subtitle: json['subtitle'],
        isDone: json['isDone'],
        isPinned: json['isPinned'],
        indexPinned: json['indexPinned']);
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'subtitle': subtitle, 'isDone': isDone, 'isPinned': isPinned, 'indexPinned': indexPinned};
  }

  @override
  String toString() {
    return '''Todo: {
   title: $title\n
   subtitle: $subtitle\n
   isDone: $isDone\n
   isPinned: $isPinned\n
   indexPinned: $indexPinned\n
  }''';
  }
}
