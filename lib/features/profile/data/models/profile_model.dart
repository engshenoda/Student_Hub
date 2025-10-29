class ProfileModel {
  final String name;
  final String title;
  final String aboutMe;
  final List<String> skills;
  final Education education;
  final List<String> languages;
  final List<Experience> experiences;
  final String photoUrl;

  ProfileModel({
    required this.name,
    required this.title,
    required this.aboutMe,
    required this.skills,
    required this.education,
    required this.languages,
    required this.experiences,
    required this.photoUrl,
  });

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      name: map['name'] ?? '',
      title: map['title'] ?? '',
      aboutMe: map['aboutMe'] ?? '',
      skills: List<String>.from(map['skills'] ?? []),
      education: Education.fromMap(map['education'] ?? {}),
      languages: List<String>.from(map['languages'] ?? []),
      experiences: (map['experiences'] as List<dynamic>?)
              ?.map((e) => Experience.fromMap(e))
              .toList() ??
          [],
      photoUrl: map['photoUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'title': title,
        'aboutMe': aboutMe,
        'skills': skills,
        'education': education.toMap(),
        'languages': languages,
        'experiences': experiences.map((e) => e.toMap()).toList(),
        'photoUrl': photoUrl,
      };
}

class Education {
  final String university;
  final String year;
  final String degree;

  Education({required this.university, required this.year, required this.degree});

  factory Education.fromMap(Map<String, dynamic> map) => Education(
        university: map['university'] ?? '',
        year: map['year'] ?? '',
        degree: map['degree'] ?? '',
      );

  Map<String, dynamic> toMap() => {
        'university': university,
        'year': year,
        'degree': degree,
      };
}

class Experience {
  final String title;
  final String year;

  Experience({required this.title, required this.year});

  factory Experience.fromMap(Map<String, dynamic> map) => Experience(
        title: map['title'] ?? '',
        year: map['year'] ?? '',
      );

  Map<String, dynamic> toMap() => {
        'title': title,
        'year': year,
      };
}
