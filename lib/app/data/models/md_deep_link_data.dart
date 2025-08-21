/// Deep link data model
class MdDeepLinkData {
  /// Default constructor
  MdDeepLinkData({
    this.title,
    this.description,
    this.invitationId,
    this.canonicalIdentifier,
    this.clickedBranchLink,
  });

  /// Factory method to create a BranchData instance from JSON
  factory MdDeepLinkData.fromJson(Map<dynamic, dynamic> json) => MdDeepLinkData(
    title: json[r'$og_title'],
    description: json[r'$og_description'],
    invitationId: json['invitation_id'],
    canonicalIdentifier: json[r'$canonical_identifier'],
    clickedBranchLink: json[r'+clicked_branch_link'] == true,
  );

  ///  Title
  final String? title;

  /// Description
  final String? description;

  /// Slay invite id
  final String? invitationId;

  /// Canonical identifier
  final String? canonicalIdentifier;

  /// Clicked branch link
  final bool? clickedBranchLink;

  /// Convert the BranchData instance to JSON
  Map<String, dynamic> toJson() => <String, dynamic>{
    r'$og_title': title,
    r'$og_description': description,
    'invitation_id': invitationId,
    r'$canonical_identifier': canonicalIdentifier,
    r'+clicked_branch_link': clickedBranchLink,
  };

  @override
  String toString() =>
      'BranchData(invitation_id: $invitationId,clicked: $clickedBranchLink)';
}
