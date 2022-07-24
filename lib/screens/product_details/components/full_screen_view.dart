import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app/components/app_bar_back_button.dart';

import '../../../services/utils.dart';

class FullScreenView extends StatefulWidget {
  final List<String> imagesList;
  const FullScreenView({super.key, required this.imagesList});

  @override
  State<FullScreenView> createState() => _FullScreenViewState();
}

class _FullScreenViewState extends State<FullScreenView> {
  final PageController _pageController = PageController();
  final _transformationController = TransformationController();
  TapDownDetails? _doubleTapDetails;
  bool _isScrolable = false;
  int currentIndex = 0;

  void _handleDoubleTapDown(TapDownDetails details) {
    _doubleTapDetails = details;
    print(details.kind);
    if (details.kind == PointerDeviceKind.touch) {
      setState(() {
        _isScrolable = !_isScrolable;
      });
    }
  }

  void _handleDoubleTap() {
    if (_transformationController.value != Matrix4.identity()) {
      _transformationController.value = Matrix4.identity();
    } else {
      final position = _doubleTapDetails!.localPosition;
      // For a 3x zoom
      _transformationController.value = Matrix4.identity()
        ..translate(-position.dx * 2, -position.dy * 2)
        ..scale(3.0);
      // Fox a 2x zoom
      // ..translate(-position.dx, -position.dy)
      // ..scale(2.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: const AppBarBackButton(),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
              child: Text(
                '${currentIndex + 1}/${widget.imagesList.length}',
                style: const TextStyle(
                  fontSize: 24,
                  letterSpacing: 8,
                ),
              ),
            ),
            SizedBox(
              height: size.height * 0.5,
              child: PageView(
                controller: _pageController,
                onPageChanged: (value) {
                  print(value);
                  setState(() {
                    currentIndex = value;
                  });
                },
                physics: _isScrolable
                    ? const NeverScrollableScrollPhysics()
                    : const ScrollPhysics(),
                children: List.generate(widget.imagesList.length, (index) {
                  return GestureDetector(
                    onDoubleTapDown: _handleDoubleTapDown,
                    onDoubleTap: _handleDoubleTap,
                    //L78
                    child: InteractiveViewer(
                      transformationController: _transformationController,
                      child: FadeInImage.assetNetwork(
                        placeholder: 'images/inapp/ripple.gif',
                        image: widget.imagesList[index],
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              height: size.height * 0.2,
              child: _imagesListView(currentIndex: currentIndex),
            )
          ],
        ),
      ),
    );
  }

  ListView _imagesListView({required int currentIndex}) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: widget.imagesList.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            _pageController.jumpToPage(index);
            setState(() {
              currentIndex = index;
            });
          },
          child: Container(
            width: 120,
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(
                  width: 4,
                  color: currentIndex == index
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context)
                          .colorScheme
                          .secondary
                          .withOpacity(0.2)),
              borderRadius: BorderRadius.circular(15),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: FadeInImage.assetNetwork(
                placeholder: 'images/inapp/ripple.gif',
                image: widget.imagesList[index],
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }
}
