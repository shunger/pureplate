enum IdentifierType {
  barcode('Barcode'),
  plu('PLU Code'),
  custom('Custom'),
  visual('Visual');

  const IdentifierType(this.displayName);
  final String displayName;
}
