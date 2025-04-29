import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '/core/utils/helper.dart';

class LettersPage extends StatefulWidget {
  const LettersPage({super.key});

  @override
  State<LettersPage> createState() => _LettersPageState();
}

class _LettersPageState extends State<LettersPage> {
  bool isGrid = false;
  bool isSorted = true;
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text("Letters"),
        previousPageTitle: "Back",
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            children: [
              //             _buildSortingOptions(), // Uncomment this if you need sorting options
              // const SizedBox(height: 20),
              _buildContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSortingOptions() {
    var usedLetters = letterData.map((e) => e["letter"]).toList();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildLayoutToggleButtons(),
        Row(
          children: [
            const Text(
              "الترتيب من اعلي الي اسفل",
              style: TextStyle(color: CupertinoColors.white, fontSize: 18),
            ),
            CupertinoSwitch(
              value: isSorted,
              onChanged: (bool value) {
                setState(() {
                  isSorted = value;
                  usedLetters =
                      isSorted ? usedLetters : usedLetters.reversed.toList();
                });
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLayoutToggleButtons() {
    return Row(
      children: [
        CupertinoButton(
          onPressed: () {
            setState(() => isGrid = false);
          },
          padding: EdgeInsets.zero,
          child: const Icon(
            CupertinoIcons.list_bullet,
            color: CupertinoColors.activeOrange,
            size: 30,
          ),
        ),
        CupertinoButton(
          onPressed: () {
            setState(() => isGrid = true);
          },
          padding: EdgeInsets.zero,
          child: const Icon(
            CupertinoIcons.grid,
            color: CupertinoColors.activeBlue,
            size: 30,
          ),
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Expanded(child: isGrid ? _buildGridView() : _buildListView());
  }

  Widget _buildGridView() {
    return GridView.builder(
      itemCount: letterData.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 30,
        crossAxisSpacing: 20,
        childAspectRatio: 0.6,
      ),
      itemBuilder: (context, index) {
        return _buildLetterItem(index);
      },
    );
  }

  Widget _buildListView() {
    return ListView.separated(
      itemBuilder: (BuildContext context, int index) {
        return _buildLetterItem(index);
      },
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(height: 15);
      },
      itemCount: letterData.length,
    );
  }

  Widget _buildLetterItem(int index) {
    String letter = letterData[index]["letter"]!;
    String imageFile = letterData[index]["image"]!;
    log(
      "Letter: $imageFile",
      name: "LetterLogger",
    ); // Log the letter and image file
    return Card(
      elevation: 3,
      child: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space between
          children: [
            SizedBox(
              height: 75,
              width: 75,
              child: Image.asset(
                "$lettersLocalPath/$imageFile",
                // errorBuilder: (context, error, stackTrace) {
                //   return const Placeholder();
                // },
              ),
            ),
            Text(
              letter,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
