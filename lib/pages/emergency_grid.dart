

class GridItem {
  final String title;
  final String path;

//to initialise them
  GridItem({required this.title, required this.path});
}

GridList Emergencygrid = GridList(grid: [
  GridItem(title: 'Contact1', path: 'gridimages/profile1.png'),
  GridItem(title: 'Contact2', path: 'gridimages/profile2.png'),
  GridItem(title: 'Contact3', path: 'gridimages/profile3.png'),
  GridItem(title: 'Contact5', path: 'gridimages/profile4.png'),
  GridItem(title: 'Contact6', path: 'gridimaages/profile6.png'),
]);

class GridList {
  late List<GridItem> grid;

  GridList({required this.grid});
}
