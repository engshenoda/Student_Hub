import 'package:equatable/equatable.dart';

class ProfileModel extends Equatable {
  final String name;
  final String jobTitle;
  final String aboutMe;
  final List<String> skills;
  final Education education;
  final List<String> languages;
  final List<Experience> experiences;
  final String photoUrl;

  const ProfileModel({
    required this.name,
    required this.jobTitle,
    required this.aboutMe,
    required this.skills,
    required this.education,
    required this.languages,
    required this.experiences,
    required this.photoUrl,
  });

  /// Empty factory useful for Cubit initial state
  factory ProfileModel.empty() => ProfileModel(
    name: '',
    jobTitle: '',
    aboutMe: '',
    skills: const [],
    education: Education.empty(),
    languages: const [],
    experiences: const [],
    photoUrl: '',
  );

  ProfileModel copyWith({
    String? name,
    String? jobTitle,
    String? aboutMe,
    List<String>? skills,
    Education? education,
    List<String>? languages,
    List<Experience>? experiences,
    String? photoUrl,
  }) {
    return ProfileModel(
      name: name ?? this.name,
      jobTitle: jobTitle ?? this.jobTitle,
      aboutMe: aboutMe ?? this.aboutMe,
      skills: skills ?? List.unmodifiable(this.skills),
      education: education ?? this.education,
      languages: languages ?? List.unmodifiable(this.languages),
      experiences: experiences ?? List.unmodifiable(this.experiences),
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  factory ProfileModel.fromMap(Map<String, dynamic>? map) {
    if (map == null) return ProfileModel.empty();

    List<String> _safeList(dynamic value) {
      if (value is List) {
        return value.map((e) => e.toString()).toList();
      }
      return [];
    }

    return ProfileModel(
      name: map['name'] ?? '',
      jobTitle: map['jobTitle'] ?? map['title'] ?? '',
      aboutMe: map['aboutMe'] ?? map['about'] ?? '',
      skills: _safeList(map['skills']),
      education: Education.fromMap(
        map['education'] != null
            ? Map<String, dynamic>.from(map['education'])
            : null,
      ),
      languages: _safeList(map['languages']),
      experiences:
          (map['experiences'] as List<dynamic>?)
              ?.map((e) => Experience.fromMap(Map<String, dynamic>.from(e)))
              .toList() ??
          [],
      photoUrl: map['photoUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'title': jobTitle,
    'aboutMe': aboutMe,
    'skills': skills,
    'education': education.toMap(),
    'languages': languages,
    'experiences': experiences.map((e) => e.toMap()).toList(),
    'photoUrl': photoUrl,
  };

  /// convenience helpers
  ProfileModel addSkill(String skill) {
    final newSkills = List<String>.from(skills)..add(skill);
    return copyWith(skills: newSkills);
  }

  ProfileModel addExperience(Experience exp) {
    final newExps = List<Experience>.from(experiences)..add(exp);
    return copyWith(experiences: newExps);
  }

  @override
  List<Object?> get props => [
    name,
    jobTitle,
    aboutMe,
    skills,
    education,
    languages,
    experiences,
    photoUrl,
  ];
}

class Education extends Equatable {
  final String university;
  final String year;
  final String degree;

  const Education({
    required this.university,
    required this.year,
    required this.degree,
  });

  factory Education.empty() =>
      const Education(university: '', year: '', degree: '');

  factory Education.fromMap(Map<String, dynamic>? map) {
    if (map == null) return Education.empty();
    return Education(
      university: map['university'] ?? '',
      year: map['year'] ?? '',
      degree: map['degree'] ?? '',
    );
  }

  Map<String, dynamic> toMap() => {
    'university': university,
    'year': year,
    'degree': degree,
  };

  @override
  List<Object?> get props => [university, year, degree];
}

class Experience extends Equatable {
  final String title;
  final String year;

  const Experience({required this.title, required this.year});

  factory Experience.empty() => const Experience(title: '', year: '');

  factory Experience.fromMap(Map<String, dynamic>? map) {
    if (map == null) return Experience.empty();
    return Experience(title: map['title'] ?? '', year: map['year'] ?? '');
  }

  Map<String, dynamic> toMap() => {'title': title, 'year': year};

  @override
  List<Object?> get props => [title, year];
}
