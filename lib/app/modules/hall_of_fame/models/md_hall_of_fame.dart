/// Model class for Hall of Fame entry
class MdHallOfFame {
  /// Hall of fame constructor
  MdHallOfFame({
    this.id,
    this.name,
    this.description,
    this.imageUrl,
    this.isActive,
    this.isCurrent,
  });

  /// Unique identifier
  final String? id;

  /// Name of the entry
  final String? name;

  /// Description of the entry
  final String? description;

  /// Image URL
  final String? imageUrl;

  /// Is active
  final bool? isActive;

  /// Is current
  final bool? isCurrent;
}
