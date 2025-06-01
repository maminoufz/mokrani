import 'package:flutter/material.dart';
import 'dart:async';

class CustomCarousel extends StatefulWidget {
  final List<Widget> items;
  final double height;
  final Duration autoPlayInterval;
  final bool autoPlay;
  final Function(int)? onPageChanged;
  final double viewportFraction;

  const CustomCarousel({
    Key? key,
    required this.items,
    required this.height,
    this.autoPlayInterval = const Duration(seconds: 5),
    this.autoPlay = true,
    this.onPageChanged,
    this.viewportFraction = 1.0,
  }) : super(key: key);

  @override
  State<CustomCarousel> createState() => _CustomCarouselState();
}

class _CustomCarouselState extends State<CustomCarousel> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: widget.viewportFraction,
      initialPage: _currentPage,
    );

    if (widget.autoPlay) {
      _startAutoPlay();
    }
  }

  void _startAutoPlay() {
    _timer = Timer.periodic(widget.autoPlayInterval, (timer) {
      if (_currentPage < widget.items.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.items.length,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
          if (widget.onPageChanged != null) {
            widget.onPageChanged!(index);
          }
        },
        itemBuilder: (context, index) {
          return widget.items[index];
        },
      ),
    );
  }
}

class CustomCarouselController {
  final PageController _pageController = PageController();

  void nextPage() {
    if (_pageController.hasClients) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  void previousPage() {
    if (_pageController.hasClients) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  void animateToPage(int page) {
    if (_pageController.hasClients) {
      _pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }
}
