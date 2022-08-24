import 'package:flutter/material.dart';
import 'package:multi_store_app/models/category.dart';
import 'package:provider/provider.dart';

import '../../../components/categ_widgets.dart';
import '../../../providers/locale_provider.dart';
import '../../../services/utils.dart';

class CategoryPageView extends StatelessWidget {
  const CategoryPageView({super.key, required this.category});
  final Category category;

  @override
  Widget build(BuildContext context) {
    final size = Utils(context).getScreenSize;
    final isArabic = Provider.of<LocaleProvider>(context).isArabic;
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            child: SizedBox(
              height: size.height * 0.8,
              width: size.width * 0.75,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CategHeaderLabel(
                    headerLabel: isArabic
                        ? category.arName.toString()
                        : category.enName.toString(),
                  ),
                  SizedBox(
                    height: size.height * 0.6,
                    child: GridView.count(
                      mainAxisSpacing: 70,
                      crossAxisSpacing: 15,
                      crossAxisCount: 3,
                      children: List.generate(category.subcategories!.length,
                          (index) {
                        return SubcategModel(
                          mainCategId: category.id.toString(),
                          subCategId:
                              category.subcategories![index].id.toString(),
                          assetName: category.subcategories![index].imageUrl
                              .toString(),
                          subcategLabel: isArabic
                              ? category.subcategories![index].arSubName
                                  .toString()
                              : category.subcategories![index].enSubName
                                  .toString(),
                        );
                      }),
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: SliderBar(
              maincategName: isArabic
                  ? category.arName.toString()
                  : category.enName.toString(),
            ),
          ),
        ],
      ),
    );
  }
}
