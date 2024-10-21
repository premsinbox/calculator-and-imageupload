import 'package:flutter/material.dart';
import '../Constants.dart';
import '../Getx/getx_view.dart';
import 'Upload/Controller/image_controller.dart';
import 'Upload/View/image_view.dart';
import '../Provider/provider_controller.dart';
import '../Provider/provider_view.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CalculatorModel()),
        ChangeNotifierProvider(create: (_) => ImageController()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CustomLayout(),
    );
  }
}

class NavigationProvider extends ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void setIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}

class CustomLayout extends StatelessWidget {
  final List<Widget> _pages = [
    CalcApp(),
    GetxCalcApp(),
    ImagePickerScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, navigationProvider, child) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  children: [
                    Container(
                      color: greycolor,
                      height: constraints.maxHeight * 0.120,
                      padding: const EdgeInsets.symmetric(
                          vertical: 22, horizontal: 10),
                      alignment: Alignment.topLeft,
                      child: Image.network(
                        'https://res.cloudinary.com/dfpzh53td/f_auto,q_auto/radicalstart/header/3x4v3_1_2_py8bbc.png',
                        height: constraints.maxHeight * 0.2,
                      ),
                    ),
                    Expanded(
                      child: Stack(
                        children: [
                          Container(
                            color: greycolor,
                          ),
                          Positioned(
                            top: 0,
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25),
                                topRight: Radius.circular(25),
                              ),
                              child: Container(
                                color: Colors.white,
                                child: _pages[navigationProvider.selectedIndex],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          bottomNavigationBar: Container(
            height: 85,
            decoration: BoxDecoration(
              color: greycolor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
              child: BottomNavigationBar(
                items: <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Image.network(
                      'https://cdn.icon-icons.com/icons2/1660/PNG/512/3844470-home-house_110332.png',
                      color: navigationProvider.selectedIndex == 0
                          ? maincolor
                          : Colors.grey,
                      height: 25,
                      width: 25,
                    ),
                    label: 'Provider',
                  ),
                  BottomNavigationBarItem(
                    icon: Image.network(
                      'https://cdn.icon-icons.com/icons2/2719/PNG/512/circles_three_icon_175301.png',
                      color: navigationProvider.selectedIndex == 1
                          ? maincolor
                          : Colors.grey,
                      height: 25,
                      width: 25,
                    ),
                    label: 'GetX',
                  ),
                  BottomNavigationBarItem(
                    icon: Image.network(
                      'https://cdn.icon-icons.com/icons2/1993/PNG/512/frame_gallery_image_images_photo_picture_pictures_icon_123209.png',
                      color: navigationProvider.selectedIndex == 2
                          ? maincolor
                          : Colors.grey,
                      height: 25,
                      width: 25,
                    ),
                    label: 'Upload',
                  ),
                ],
                currentIndex: navigationProvider.selectedIndex,
                selectedItemColor: maincolor,
                unselectedItemColor: Colors.grey,
                backgroundColor: Color(0xFFF0F0F0),
                onTap: (index) {
                  navigationProvider.setIndex(index);
                },
                showSelectedLabels: true,
                showUnselectedLabels: true,
              ),
            ),
          ),
        );
      },
    );
  }
}
