import '/core/utils/helper.dart';

class NumbersPage extends StatefulWidget {
  const NumbersPage({super.key});

  @override
  State<NumbersPage> createState() => _NumbersPageState();
}

class _NumbersPageState extends State<NumbersPage> {
  int selectedNumber = 0;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text("Numbers"),
        transitionBetweenRoutes: true,
        previousPageTitle: "Back",
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 15),
              Expanded(
                flex: 2,
                child: PageView.builder(
                  onPageChanged: (index) {
                    setState(() {
                      selectedNumber = index;
                    });
                  },
                  itemCount: numbers.length,
                  controller: PageController(viewportFraction: 1),
                  itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        gradient: const LinearGradient(
                          colors: [
                            primary_color,
                            Color(0xff000000),
                            Color(0xff2B2A2C),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.all(5),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          color: const Color(0xff2A2A2A),
                          image: DecorationImage(
                            fit: BoxFit.contain,
                            image: AssetImage(
                              "$numbersLocalPath/${numbers[selectedNumber]}.png",
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                height: 150,
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    childAspectRatio: 1.1,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: numbers.length,
                  itemBuilder: (context, pageIndex) {
                    return Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          setState(() {
                            selectedNumber = pageIndex;
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [
                                primary_color,
                                Color(0xff000000),
                                Color(0xff2B2A2C),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                          child: Container(
                            margin: const EdgeInsets.all(3),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:
                                  selectedNumber == pageIndex
                                      ? primary_color
                                      : const Color(0xff2A2A2A),
                            ),
                            child: Center(
                              child: Text(
                                numbers[pageIndex],
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 24,
                                  color: CupertinoColors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
