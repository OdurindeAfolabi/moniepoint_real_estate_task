import 'dart:async';
import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:moniepoint_task/presentation/app.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  // Animation Controllers
  late final AnimationController _navController;
  late final AnimationController _dpController;
  late final AnimationController _circleController;
  late final AnimationController _widthController;
  late final AnimationController _containerController;
  late final AnimationController _contentController;

  // Animations
  late final Animation<double> _dpAnimation;
  late final Animation<double> _circleAnimation;
  late final Animation<double> _widthAnimation;
  late final Animation<Offset> _navAnimation;
  late final Animation<Offset> _containerAnimation;
  late final Animation<double> _contentAnimation;

  // State Variables
  static const int _maxAmount = 1460;
  int _amount = 0;
  int _numValue1 = 0;
  int _numValue2 = 0;
  bool _expandText = false;
  bool _hideCircleRow = false;
  Timer? _timer;

  // Scroll Controller
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAmountAnimation();
    _triggerDelayedUpdates();
  }

  void _initializeAnimations() {
    _navController = _createAnimationController(duration: 300);
    _dpController = _createAnimationController(duration: 1000);
    _circleController = _createAnimationController(duration: 3500);
    _widthController = _createAnimationController(duration: 1500);
    _containerController = _createAnimationController(duration: 1000);
    _contentController = _createAnimationController(duration: 1000);

    _dpAnimation = _createTweenAnimation(begin: 20.0, end: 50.0, controller: _dpController);
    _circleAnimation = _createTweenAnimation(begin: 0.0, end: 100.0, controller: _circleController);
    _widthAnimation = _createTweenAnimation(begin: 0.0, end: 400.0, controller: _widthController);
    _navAnimation = _createOffsetAnimation(begin: const Offset(0.0, 0.99), end: Offset.zero, controller: _navController);
    _containerAnimation = _createOffsetAnimation(begin: const Offset(-1.0, 0.0), end: Offset.zero, controller: _containerController);
    _contentAnimation = _createTweenAnimation(begin: 0.0, end: 1.0, controller: _contentController);

    _containerController.forward().then((_) => _contentController.forward());
  }

  AnimationController _createAnimationController({required int duration}) {
    return AnimationController(
      duration: Duration(milliseconds: duration),
      vsync: this,
    )..forward();
  }

  Animation<double> _createTweenAnimation({required double begin, required double end, required AnimationController controller}) {
    return Tween(begin: begin, end: end).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
  }

  Animation<Offset> _createOffsetAnimation({required Offset begin, required Offset end, required AnimationController controller}) {
    return Tween(begin: begin, end: end).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));
  }

  void _startAmountAnimation() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      if (_amount >= _maxAmount) {
        timer.cancel();
      } else {
        setState(() => _amount += 5);
      }
    });
  }

  void _triggerDelayedUpdates() {
    Future.delayed(const Duration(milliseconds: 1200), () => setState(() => _expandText = true));
    Future.delayed(const Duration(milliseconds: 1800), () => setState(() {
      _numValue1 = 1034;
      _numValue2 = 2212;
    }));
    Future.delayed(const Duration(milliseconds: 2600), () {
      setState(() => _hideCircleRow = true);
      _scrollToOffstageSection(); // Trigger scroll animation
    });
  }

  void _scrollToOffstageSection() {
    // Calculate the offset to scroll to the Offstage section
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent, // Scroll to the bottom
          duration: const Duration(milliseconds: 1200),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _navController.dispose();
    _dpController.dispose();
    _circleController.dispose();
    _widthController.dispose();
    _containerController.dispose();
    _contentController.dispose();
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFFA5957E).withOpacity(0.1),
              const Color(0xFFF9D8AF).withOpacity(0.9),
            ],
            stops: const [0.2, 7.0],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView(
          controller: _scrollController, // Attach the ScrollController
          children: [
            Column(
              children: [
                _buildTopBar(),
                _buildWelcomeText(),
                const SizedBox(height: 60),
                _buildBuyRentRow(),
                const SizedBox(height: 60),
                _buildBottomContent(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SlideTransition(
            position: _containerAnimation,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: FadeTransition(
                opacity: _contentAnimation,
                child: const Row(
                  children: [
                    Icon(Icons.location_on_rounded, color: Color(0XFFa4957e)),
                    SizedBox(width: 8),
                    Text(
                      "Saint Petersburg",
                      style: TextStyle(color: Color(0XFFa4957e), fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedBuilder(
            animation: _dpAnimation,
            builder: (context, child) {
              return Container(
                width: _dpAnimation.value,
                height: _dpAnimation.value,
                decoration: const BoxDecoration(
                  color: Color(0xFFE48E28),
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage("assets/images/dp.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeText() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 5),
          const Text(
            'Hi, Marina',
            style: TextStyle(color: Color(0xFFbcb0a0), fontSize: 22, fontWeight: FontWeight.w500),
          ).animate().fadeIn(delay: 1500.ms),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'let\'s select your',
                style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.w500),
              ).animate().fadeIn(delay: 1800.ms),
              const Text(
                'perfect place',
                style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.w500),
              ).animate().fadeIn(delay: 2100.ms),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBuyRentRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildCircleContainer(
          color: AppColors.primary,
          text: 'BUY',
          value: _numValue1,
          subText: 'offers',
        ),
        _buildCircleContainer(
          color: Theme.of(context).colorScheme.surface,
          text: 'Rent',
          value: _numValue2,
          subText: 'offers',
          isRent: true,
        ),
      ],
    );
  }

  Widget _buildCircleContainer({
    required Color color,
    required String text,
    required int value,
    required String subText,
    bool isRent = false,
  }) {
    return AnimatedBuilder(
      animation: _circleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: 1 + (_circleAnimation.value / 95),
          child: Container(
            width: 80,
            height: isRent ? 80 : 100,
            padding: EdgeInsets.all(isRent ? 5 : 15),
            margin: EdgeInsets.only(left: isRent ? 0 : 10, right: isRent ? 10 : 0),
            decoration: BoxDecoration(
              color: color,
              shape: isRent ? BoxShape.rectangle : BoxShape.circle,
              borderRadius: isRent ? BorderRadius.circular(12) : null,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  text,
                  style: TextStyle(
                    color: isRent ? const Color(0XFFa4957e) : Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 15),
                AnimatedFlipCounter(
                  duration: const Duration(milliseconds: 1500),
                  value: value,
                  wholeDigits: 4,
                  hideLeadingZeroes: true,
                  thousandSeparator: ' ',
                  textStyle: TextStyle(
                    color: isRent ? const Color(0XFFa4957e) : Colors.white,
                    fontSize: isRent ? 13 : 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subText,
                  style: TextStyle(
                    color: isRent ? const Color(0XFFa4957e) : Colors.white,
                    fontSize: 7,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomContent() {
    return Offstage(
      offstage: !_hideCircleRow,
      child: Container(
        width: MediaQuery.sizeOf(context).width,
        padding: const EdgeInsets.all(6),
        alignment: Alignment.bottomCenter,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        child: Column(
          children: [
            const ImgWidget(text: 'Gladkova St., 25'),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.4,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ImgWidget(
                      imgPath: ImagesPaths.furniture3,
                      imgHeight: MediaQuery.sizeOf(context).height * 0.5,
                      milliseconds: 3600,
                      text: 'Malaga St., 92',
                      sliderWidth: 0.36,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        2,
                            (index) => Expanded(
                          child: ImgWidget(
                            imgPath: index.isEven ? ImagesPaths.furniture4 : ImagesPaths.furniture1,
                            imgHeight: MediaQuery.sizeOf(context).height * 0.4,
                            milliseconds: 3650,
                            text: index == 0 ? 'Margaret., 32' : 'Trefeleva., 43',
                            sliderWidth: 0.36,
                          ),
                        ),
                      ).columnInPadding(5),
                    ),
                  ),
                ].rowInPadding(5),
              ),
            ).padSymmetric(vertical: 5),
          ],
        ),
      ).animate().slideInFromBottom(delay: 2700.ms, animationDuration: 1200.ms),
    );
  }
}