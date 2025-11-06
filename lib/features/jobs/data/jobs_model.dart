class JobModel {
  final String id;
  final String title;
  final String company;
  final String salary;
  final List<String> tags;
  final String description;
  final List<String> requirements;

  JobModel({
    required this.id,
    required this.title,
    required this.company,
    required this.salary,
    required this.tags,
    required this.description,
    required this.requirements,
  });

  factory JobModel.fromMap(Map<String, dynamic> data, String docId) {
    return JobModel(
      id: docId,
      title: data['title'] ?? '',
      company: data['company'] ?? '',
      salary: data['salary'] ?? '',
      tags: List<String>.from(data['tags'] ?? []),
      description: data['description'] ?? '',
      requirements: List<String>.from(data['requirements'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'company': company,
      'salary': salary,
      'tags': tags,
      'description': description,
      'requirements': requirements,
    };
  }
}
