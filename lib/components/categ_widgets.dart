import 'package:flutter/material.dart';
import 'package:multi_store_app/providers/category_provider.dart';
import 'package:multi_store_app/screens/subcategory_products/subcateg_products_screen.dart';
import 'package:provider/provider.dart';

import '../providers/dark_theme_provider.dart';
import '../services/utils.dart';

class SliderBar extends StatelessWidget {
  final String maincategName;
  const SliderBar({Key? key, required this.maincategName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Provider.of<DarkThemeProvider>(context).isDarkTheme;
    final categories = Provider.of<CategoryProvider>(context).categories;

    final size = Utils(context).getScreenSize;
    return SizedBox(
      height: size.height * 0.8,
      width: size.width * 0.05,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Container(
          decoration: BoxDecoration(
              color: isDarkTheme
                  ? const Color(0xFF758699)
                  : const Color(0xFFdae3e3),
              borderRadius: BorderRadius.circular(50)),
          child: RotatedBox(
            quarterTurns: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                categories.last.enName == maincategName
                    ? const Text('')
                    : const Text(' << '),
                Text(maincategName.toUpperCase()),
                categories.first.enName == maincategName
                    ? const Text('')
                    : const Text(' >> '),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/* const style = TextStyle(
    color: Colors.brown,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 10); */

class SubcategModel extends StatelessWidget {
  final String mainCategId;
  final String subCategId;
  final String assetName;
  final String subcategLabel;
  const SubcategModel(
      {Key? key,
      required this.assetName,
      required this.mainCategId,
      required this.subCategId,
      required this.subcategLabel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SubCategoryProductsScreen(
                      maincategId: mainCategId,
                      subcategId: subCategId,
                    )));
      },
      child: Column(
        children: [
          Flexible(
            flex: 2,
            child: SizedBox(
              height: 70,
              width: 70,
              child: FadeInImage.assetNetwork(
                placeholder: 'images/inapp/spinner.gif',
                image: assetName,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              subcategLabel,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 11),
            ),
          )
        ],
      ),
    );
  }
}

class CategHeaderLabel extends StatelessWidget {
  final String headerLabel;
  const CategHeaderLabel({Key? key, required this.headerLabel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Text(
        headerLabel,
        style: const TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 1.5),
      ),
    );
  }
}
