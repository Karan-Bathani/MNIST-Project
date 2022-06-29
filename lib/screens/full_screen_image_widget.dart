import 'package:flutter/material.dart';
import 'package:mnist_visionbox/models/pred.dart';
import 'package:mnist_visionbox/utilities/constants.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class MyFullScreenImageWidget extends StatefulWidget {
  final int initialIndex;
  final List<Pred> preds;

  const MyFullScreenImageWidget(this.initialIndex, this.preds, {Key? key})
      : super(key: key);

  @override
  _MyFullScreenImageWidgetState createState() =>
      _MyFullScreenImageWidgetState();
}

class _MyFullScreenImageWidgetState extends State<MyFullScreenImageWidget>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  PageController? _pageController;

  @override
  void initState() {
    _pageController = PageController(initialPage: widget.initialIndex);
    _tabController = TabController(
        initialIndex: widget.initialIndex,
        length: widget.preds.length,
        vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        color: Colors.black,
        child: TabBar(
          isScrollable: true,
          controller: _tabController,
          onTap: (tabIndex) {
            _pageController?.animateToPage(tabIndex,
                duration: const Duration(milliseconds: 270),
                curve: Curves.linear);
          },
          tabs: widget.preds
              .map(
                (image) => Tab(
                  child: Image.memory(
                    image.image,
                    fit: BoxFit.contain,
                    width: 60,
                    height: 60,
                  ),
                ),
              )
              .toList(),
        ),
      ),
      body: Stack(
        children: [
          PhotoViewGallery.builder(
            itemCount: widget.preds.length,
            pageController: _pageController,
            onPageChanged: (pageIndex) {
              _tabController?.animateTo(pageIndex);
              setState(() {});
            },
            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: Image.memory(widget.preds[index].image).image,
                // Contained = the smallest possible size to fit one dimension of the screen
                minScale: PhotoViewComputedScale.contained * 0.8,
                // Covered = the smallest possible size to fit the whole screen
                maxScale: PhotoViewComputedScale.covered * 2,
                heroAttributes:
                    PhotoViewHeroAttributes(tag: widget.preds[index]),
              );
            },
            backgroundDecoration: const BoxDecoration(color: Colors.black),
          ),
          Positioned(
            top: 40,
            right: 10,
            // width: 200,
            // height: 25,
            child: IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.white,
                size: 40,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(color: Colors.black45),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Time: ${widget.preds[_tabController!.index].dateTime.formatDate(pattern: "hh : MM : s a")}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "#${widget.preds[_tabController!.index].number}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 40,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    widget.preds[_tabController!.index].link.contains("http")
                        ? "Link: ${widget.preds[_tabController!.index].link}"
                        : "",
                    softWrap: true,
                    overflow: TextOverflow.visible,
                    maxLines: 2,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
