/// Who the barn belongs to and where it is — collected once, up front,
/// and carried through to the saved history record and the PDF report.
/// Deliberately not part of BarnInput: it has nothing to do with the
/// physical barn the formulas calculate from, so it never touches
/// calculations/.
class BarnOwnerInfo {
  final String ownerName;
  final String location;

  const BarnOwnerInfo({required this.ownerName, required this.location});
}