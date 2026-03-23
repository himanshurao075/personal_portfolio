class PortfolioData {
  PortfolioData({
    required this.basics,
    required this.about,
    required this.services,
    required this.skillGroups,
    required this.experience,
    required this.projects,
    required this.education,
    required this.certifications,
    required this.recommendations,
  });

  factory PortfolioData.fromJson(Map<String, dynamic> json) {
    return PortfolioData(
      basics: Basics.fromJson(json['basics'] as Map<String, dynamic>),
      about: (json['about'] as List<dynamic>).cast<String>(),
      services: (json['services'] as List<dynamic>).cast<String>(),
      skillGroups: _readList(
        json['skillGroups'],
        (item) => SkillGroup.fromJson(item as Map<String, dynamic>),
      ),
      experience: _readList(
        json['experience'],
        (item) => ExperienceItem.fromJson(item as Map<String, dynamic>),
      ),
      projects: _readList(
        json['projects'],
        (item) => ProjectItem.fromJson(item as Map<String, dynamic>),
      ),
      education: _readList(
        json['education'],
        (item) => EducationItem.fromJson(item as Map<String, dynamic>),
      ),
      certifications: _readList(
        json['certifications'],
        (item) => CertificationItem.fromJson(item as Map<String, dynamic>),
      ),
      recommendations: _readList(
        json['recommendations'],
        (item) => RecommendationItem.fromJson(item as Map<String, dynamic>),
      ),
    );
  }

  final Basics basics;
  final List<String> about;
  final List<String> services;
  final List<SkillGroup> skillGroups;
  final List<ExperienceItem> experience;
  final List<ProjectItem> projects;
  final List<EducationItem> education;
  final List<CertificationItem> certifications;
  final List<RecommendationItem> recommendations;

  static List<T> _readList<T>(Object? source, T Function(Object? item) mapper) {
    return (source as List<dynamic>).map(mapper).toList();
  }
}

class Basics {
  Basics({
    required this.name,
    required this.headline,
    required this.tagline,
    required this.location,
    required this.experienceLabel,
    required this.summary,
    required this.availability,
    required this.phone,
    required this.email,
    required this.linkedin,
    required this.github,
    required this.heroStats,
  });

  factory Basics.fromJson(Map<String, dynamic> json) {
    return Basics(
      name: json['name'] as String,
      headline: json['headline'] as String,
      tagline: json['tagline'] as String,
      location: json['location'] as String,
      experienceLabel: json['experienceLabel'] as String,
      summary: json['summary'] as String,
      availability: Availability.fromJson(
        json['availability'] as Map<String, dynamic>,
      ),
      phone: json['phone'] as String,
      email: json['email'] as String,
      linkedin: json['linkedin'] as String,
      github: json['github'] as String,
      heroStats: PortfolioData._readList(
        json['heroStats'],
        (item) => StatItem.fromJson(item as Map<String, dynamic>),
      ),
    );
  }

  final String name;
  final String headline;
  final String tagline;
  final String location;
  final String experienceLabel;
  final String summary;
  final Availability availability;
  final String phone;
  final String email;
  final String linkedin;
  final String github;
  final List<StatItem> heroStats;
}

class Availability {
  Availability({
    required this.openToFullTime,
    required this.openToFreelance,
    required this.openToConsulting,
    required this.preferredModes,
  });

  factory Availability.fromJson(Map<String, dynamic> json) {
    return Availability(
      openToFullTime: json['openToFullTime'] as bool,
      openToFreelance: json['openToFreelance'] as bool,
      openToConsulting: json['openToConsulting'] as bool,
      preferredModes: (json['preferredModes'] as List<dynamic>).cast<String>(),
    );
  }

  final bool openToFullTime;
  final bool openToFreelance;
  final bool openToConsulting;
  final List<String> preferredModes;
}

class StatItem {
  StatItem({required this.label, required this.value});

  factory StatItem.fromJson(Map<String, dynamic> json) {
    return StatItem(
      label: json['label'] as String,
      value: json['value'] as String,
    );
  }

  final String label;
  final String value;
}

class SkillGroup {
  SkillGroup({required this.title, required this.items});

  factory SkillGroup.fromJson(Map<String, dynamic> json) {
    return SkillGroup(
      title: json['title'] as String,
      items: (json['items'] as List<dynamic>).cast<String>(),
    );
  }

  final String title;
  final List<String> items;
}

class ExperienceItem {
  ExperienceItem({
    required this.role,
    required this.company,
    required this.period,
    required this.location,
    required this.highlights,
  });

  factory ExperienceItem.fromJson(Map<String, dynamic> json) {
    return ExperienceItem(
      role: json['role'] as String,
      company: json['company'] as String,
      period: json['period'] as String,
      location: json['location'] as String,
      highlights: (json['highlights'] as List<dynamic>).cast<String>(),
    );
  }

  final String role;
  final String company;
  final String period;
  final String location;
  final List<String> highlights;
}

class ProjectItem {
  ProjectItem({
    required this.title,
    required this.category,
    required this.summary,
    required this.tech,
  });

  factory ProjectItem.fromJson(Map<String, dynamic> json) {
    return ProjectItem(
      title: json['title'] as String,
      category: json['category'] as String,
      summary: json['summary'] as String,
      tech: (json['tech'] as List<dynamic>).cast<String>(),
    );
  }

  final String title;
  final String category;
  final String summary;
  final List<String> tech;
}

class EducationItem {
  EducationItem({
    required this.institution,
    required this.degree,
    required this.period,
    required this.grade,
  });

  factory EducationItem.fromJson(Map<String, dynamic> json) {
    return EducationItem(
      institution: json['institution'] as String,
      degree: json['degree'] as String,
      period: json['period'] as String,
      grade: json['grade'] as String,
    );
  }

  final String institution;
  final String degree;
  final String period;
  final String grade;
}

class CertificationItem {
  CertificationItem({
    required this.title,
    required this.issuer,
    required this.issued,
    required this.credentialId,
  });

  factory CertificationItem.fromJson(Map<String, dynamic> json) {
    return CertificationItem(
      title: json['title'] as String,
      issuer: json['issuer'] as String,
      issued: json['issued'] as String,
      credentialId: json['credentialId'] as String,
    );
  }

  final String title;
  final String issuer;
  final String issued;
  final String credentialId;
}

class RecommendationItem {
  RecommendationItem({
    required this.name,
    required this.role,
    required this.quote,
  });

  factory RecommendationItem.fromJson(Map<String, dynamic> json) {
    return RecommendationItem(
      name: json['name'] as String,
      role: json['role'] as String,
      quote: json['quote'] as String,
    );
  }

  final String name;
  final String role;
  final String quote;
}
