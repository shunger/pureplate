enum ScanMode {
  barcode('Barcode', 'Live camera scanning', 'qr_code_scanner'),
  plu('PLU Code', 'Enter or search PLU codes', 'dialpad'),
  manual('Manual', 'Enter product details manually', 'edit');

  const ScanMode(this.displayName, this.description, this.iconName);
  final String displayName;
  final String description;
  final String iconName;
}
