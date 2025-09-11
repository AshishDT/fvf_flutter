/// Crew model
class MdCrew {
  /// Constructor
  MdCrew({
    this.crewId,
    this.isCrewStrekak,
    this.streakCount,
  });

  /// From JSON
  factory MdCrew.fromJson(Map<String, dynamic> json) => MdCrew(
        crewId: json['crew_id'],
        isCrewStrekak: json['is_crew_strekak'],
        streakCount: json['streak_count'],
      );

  /// Crew ID
  String? crewId;

  /// Is crew streak active
  bool? isCrewStrekak;

  /// Streak count
  int? streakCount;

  /// To JSON
  Map<String, dynamic> toJson() => <String, dynamic>{
        'crew_id': crewId,
        'is_crew_strekak': isCrewStrekak,
        'streak_count': streakCount,
      };
}
