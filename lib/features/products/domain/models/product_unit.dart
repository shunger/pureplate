enum ProductUnit {
  each('Each', 'ea', false),
  pound('Pound', 'lb', true),
  kilogram('Kilogram', 'kg', true),
  ounce('Ounce', 'oz', true),
  gram('Gram', 'g', true),
  bunch('Bunch', 'bunch', false),
  bag('Bag', 'bag', false),
  container('Container', 'cont', false),
  bottle('Bottle', 'btl', false),
  can('Can', 'can', false),
  box('Box', 'box', false),
  package('Package', 'pkg', false);

  const ProductUnit(this.displayName, this.abbreviation, this.isWeightBased);
  final String displayName;
  final String abbreviation;
  final bool isWeightBased;
}
