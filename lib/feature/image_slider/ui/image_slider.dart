import 'package:flutter/material.dart';
import 'dart:async';

class ImageSlider extends StatefulWidget {
  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  Timer? _autoSlideTimer;

  final List<String> _sliderImages = [
    "https://imgs.search.brave.com/SiOXjRDzxqRsmVKucSCWRiUNkQjJFQUTlam6wQ7P0QI/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9pbWcu/amFncmFuam9zaC5j/b20vaW1hZ2VzLzIw/MjUvRmVicnVhcnkv/MTEyMjAyNS9zY2hl/bWVzLndlYnA"
    ,"https://imgs.search.brave.com/C41JvxFv0cqD0rBUjpcFxOFZTzePpCs9nDwFRnJg50o/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly93d3cu/bXlzY2hlbWUuZ292/LmluL19uZXh0L2lt/YWdlP3VybD1odHRw/czovL2Nkbi5teXNj/aGVtZS5pbi9pbWFn/ZXMvc2xpZGVzaG93/L21vYmlsZS9iYW5u/ZXIyLndlYnAmdz0z/ODQwJnE9NzU"
    ,"https://imgs.search.brave.com/xEYKxNMhBS28MKXFxmgy_YFzDYGhGnizip73UzkYqMs/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly9zdGF0/aWMubXlnb3YuaW4v/bWVkaWEvcXVpei8y/MDI1LzA3L215Z292/XzY4NjM5MmQxYmEz/NzIucG5n"
    ,"https://imgs.search.brave.com/2OFz7-RGmeFgruEI7h_pwOq9qB_ndW6Xdx5TODeuvB8/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly93d3cu/bXlzY2hlbWUuZ292/LmluL19uZXh0L2lt/YWdlP3VybD1odHRw/czovL2Nkbi5teXNj/aGVtZS5pbi9pbWFn/ZXMvc2xpZGVzaG93/L21vYmlsZS9iYW5u/ZXI0LndlYnAmdz0z/ODQwJnE9NzU",
  ];

  @override
  void initState() {
    super.initState();
    _autoSlideTimer = Timer.periodic(Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        int nextPage = (_currentIndex + 1) % _sliderImages.length;
        _pageController.animateToPage(
          nextPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _autoSlideTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 220,
          child: PageView.builder(
            controller: _pageController,
            itemCount: _sliderImages.length,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Image.network(
                      _sliderImages[index],
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) => const Center(
                          child: Icon(Icons.broken_image, size: 50, color: Colors.grey)),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        // Indicator Dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_sliderImages.length, (index) {
            return AnimatedContainer(
              duration: Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: _currentIndex == index ? 12 : 8,
              height: _currentIndex == index ? 12 : 8,
              decoration: BoxDecoration(
                color: _currentIndex == index ? Colors.blue : Colors.grey.shade400,
                shape: BoxShape.circle,
              ),
            );
          }),
        ),
      ],
    );
  }
}
