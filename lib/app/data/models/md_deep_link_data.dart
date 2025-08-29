/// Deep link data model
class MdDeepLinkData {
  /// Constructor
  MdDeepLinkData({
    this.invitationId,
    this.tags,
    this.canonicalIdentifier,
    this.clickedBranchLink,
    this.hostId,
  });

  /// From JSON
  factory MdDeepLinkData.fromJson(Map<dynamic, dynamic> json) => MdDeepLinkData(
        invitationId: json['invitation_id'] as String?,
        tags: (json[r'~tags'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList(),
        canonicalIdentifier: json[r'$canonical_identifier'] as String?,
        clickedBranchLink: json[r'+clicked_branch_link'] == true,
        hostId: json['host_id'] as String?,
      );

  /// Invitation ID
  final String? invitationId;

  /// Host ID
  final String? hostId;

  /// Tags
  final List<String>? tags;

  /// Canonical identifier
  final String? canonicalIdentifier;

  /// Clicked branch link
  final bool? clickedBranchLink;

  /// To JSON
  Map<String, dynamic> toJson() => <String, dynamic>{
        'invitation_id': invitationId,
        r'~tags': tags,
        r'$canonical_identifier': canonicalIdentifier,
        r'+clicked_branch_link': clickedBranchLink,
        'host_id': hostId,
      };
}
