class MeetingModel {
  final String id;
  final int studentId;
  final int meetId;
  final List<Emotion> textEmotions;
  final List<Emotion> videoEmotions;
  final List<Emotion> audioEmotions;
  final int v;
  final String title;
  final String hostName;
  final String description;

  MeetingModel({
    required this.id,
    required this.studentId,
    required this.meetId,
    required this.textEmotions,
    required this.videoEmotions,
    required this.audioEmotions,
    required this.v,
    required this.title,
    required this.hostName,
    required this.description,
  });

  factory MeetingModel.fromJson(Map<String, dynamic> json) => MeetingModel(
        id: json['_id'] as String,
        studentId: json['student_id'] as int,
        meetId: json['meet_id'] as int,
        textEmotions: (json['text_emotions'] as List)
            .map((e) => Emotion.fromJson(e))
            .toList(),
        videoEmotions: (json['video_emotions'] as List)
            .map((e) => Emotion.fromJson(e))
            .toList(),
        audioEmotions: (json['audio_emotions'] as List)
            .map((e) => Emotion.fromJson(e))
            .toList(),
        v: json['__v'] as int,
        title: json['title'] as String,
        hostName: json['host_name'] as String,
        description: json['description'] as String,
      );

  Map<String, dynamic> toJson() => {
        '_id': id,
        'student_id': studentId,
        'meet_id': meetId,
        'text_emotions': textEmotions.map((e) => e.toJson()).toList(),
        'video_emotions': videoEmotions.map((e) => e.toJson()).toList(),
        'audio_emotions': audioEmotions.map((e) => e.toJson()).toList(),
        '__v': v,
        'title': title,
        'host_name': hostName,
        'description': description,
      };
}

class Emotion {
  final int happy;
  final int surprised;
  final int confused;
  final int bored;
  final int pnf;

  Emotion({
    required this.happy,
    required this.surprised,
    required this.confused,
    required this.bored,
    required this.pnf,
  });

  factory Emotion.fromJson(Map<String, dynamic> json) => Emotion(
        happy: json['happy'] as int,
        surprised: json['surprised'] as int,
        confused: json['confused'] as int,
        bored: json['bored'] as int,
        pnf: json['pnf'] as int,
      );

  Map<String, dynamic> toJson() => {
        'happy': happy,
        'surprised': surprised,
        'confused': confused,
        'bored': bored,
        'pnf': pnf,
      };
}
