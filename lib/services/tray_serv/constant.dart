enum MenuItemEnum {
  capture(label: 'Capture'),
  debug(label: 'Debug'),
  exit(label: 'Exit'),
  ;

  const MenuItemEnum({required this.label});

  final String label;

  static MenuItemEnum? fromName(String? name) {
    for (final item in MenuItemEnum.values) {
      if (item.name == name) {
        return item;
      }
    }

    return null;
  }
}
