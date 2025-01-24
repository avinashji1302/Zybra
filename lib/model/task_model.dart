class TaskModel {
  final int? id;
  final String title;
  final String description;
  final bool isComplete; 

  TaskModel({
    this.id,
    required this.title,
    required this.description,
    this.isComplete = false,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "description": description,
      "isComplete": isComplete ? 1 : 0, 
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      isComplete: map['isComplete'] == 1,  
    );
  }
}
