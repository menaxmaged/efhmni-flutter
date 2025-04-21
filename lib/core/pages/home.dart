import '/core/utils/helper.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar.large(
        largeTitle: Text("Home"),
        transitionBetweenRoutes: true,
      ),
      child: Center(
        child: Column(
          children: [
            Image(image: AssetImage("assets/images/logo.png")),
            Text("Hello World!"),
          ],
        ),
      ),
    );
  }
}
