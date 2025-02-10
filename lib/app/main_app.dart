import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:svg_flutter/svg.dart';

import '../presentation/app.dart';
import '../presentation/home_page.dart';
import '../presentation/map_screen.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _rippleEffect;
  bool _isBorderVisible = false;
  int _currentPageIndex = 2;

  final List<Widget> _pages = [
    const MapScreen(),
    const Scaffold(
      body: Center(
        child: Text("Chat Screen",style: TextStyle(color: Colors.black),),
      ),
    ), // Chat Screen Placeholder
    const HomeScreen(),
    const Scaffold(
      body: Center(
        child: Text("Favorites Screen",style: TextStyle(color: Colors.black),),
      ),
    ), //// Heart Screen Placeholder
    const Scaffold(
      body: Center(
        child: Text("Profile Screen",style: TextStyle(color: Colors.black),),
      ),
    ), //, // Profile Screen Placeholder
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );

    _rippleEffect = Tween<double>(
      begin: 30,
      end: 20,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _isBorderVisible = false);
        _animationController.reset();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onNavItemSelected(int index) {
    setState(() {
      _isBorderVisible = true;
      _currentPageIndex = index;
    });
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppThemeData.lightTheme,
      darkTheme: AppThemeData.lightTheme,
      themeMode: ThemeMode.light,
      home: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            _pages[_currentPageIndex],
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: kBottomNavigationBarHeight * 1.4,
                width: context.sizeWidth(0.82),
                child: Card(
                  color: context.colorScheme.onSurface.withOpacity(0.95),
                  shape: const StadiumBorder(),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(5, (index) {
                      return BottomNavItem(
                        index: index,
                        isSelected: _currentPageIndex == index,
                        onTap: () => _onNavItemSelected(index),
                        rippleEffect: _rippleEffect,
                        isBorderVisible: _isBorderVisible,
                      );
                    }),
                  ),
                ),
              ).padOnly(bottom: context.sizeHeight(0.015)),
            ).slideInFromBottom(
              delay: 3000.ms, animationDuration: 2500.ms, begin: 0.9,
            ),
          ],
        ),
      ),
    );
  }
}

class BottomNavItem extends StatelessWidget {
  final int index;
  final bool isSelected;
  final VoidCallback onTap;
  final Animation<double> rippleEffect;
  final bool isBorderVisible;

  const BottomNavItem({
    required this.index,
    required this.isSelected,
    required this.onTap,
    required this.rippleEffect,
    required this.isBorderVisible,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: isSelected ? 40 : 30,
        height: isSelected ? 40 : 30,
        decoration: BoxDecoration(
          color: isSelected && !isBorderVisible
              ? AppColors.primary
              : index == 0
              ? Colors.black26
              : context.colorScheme.onSurface,
          shape: BoxShape.circle,
          border: isBorderVisible && isSelected
              ? Border.all(color: context.colorScheme.surface, width: 1)
              : null,
        ),
        child: SvgPicture.asset(
          navbarIcons.values.toList()[index],
          colorFilter: ColorFilter.mode( context.colorScheme.surface, BlendMode.srcIn),
          height: isSelected ? 28 : null,
        ),
      ),
    );
  }
}
