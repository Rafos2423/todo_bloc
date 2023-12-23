class Todo {
  final String title;
  final String subtitle;
  bool isDone;
  bool isPinned;

  Todo({this.title = '', this.subtitle = '', this.isDone = false, this.isPinned = false});

  Todo copyWith({
    String? title,
    String? subtitle,
    bool? isDone,
    bool? isPinned,
  }) {
    return Todo(
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      isDone: isDone ?? this.isDone,
      isPinned: isPinned ?? this.isPinned,
    );
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
        title: json['title'],
        subtitle: json['subtitle'],
        isDone: json['isDone'],
        isPinned: json['isPinned']);
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'subtitle': subtitle, 'isDone': isDone, 'isPinned': isPinned};
  }

  @override
  String toString() {
    return '''Todo: {
   title: $title\n
   subtitle: $subtitle\n
   isDone: $isDone\n
   isPinned: $isPinned\n
  }''';
  }
}
