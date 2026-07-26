// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:personal_portfolio/sections/about/about_section.dart';
// import 'package:personal_portfolio/sections/home/home_section.dart';

// class PortfolioScreen extends StatefulWidget {
//   const PortfolioScreen({super.key});

//   @override
//   State<PortfolioScreen> createState() => _PortfolioScreenState();
// }

// class _PortfolioScreenState extends State<PortfolioScreen>
//     with WidgetsBindingObserver {
//   final ScrollController _scrollController = ScrollController();
//   int _currentSection = 0;
//   final GlobalKey _homeSectionKey = GlobalKey();
//   final GlobalKey _aboutSectionKey = GlobalKey();
//   bool _homeSectionVisible = false;

//   // Cursor glow position
//   Offset _cursorPosition = Offset.zero;
//   bool _isCursorInside = false;

//   // call back to reset animation
//   VoidCallback? _resetAboutAnimation;

//   // Auto scroll snap variables
//   bool _isAutoScrolling = false;

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();

//     WidgetsBinding.instance.addObserver(this);
//     _scrollController.addListener(_onScroll);
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       _checkHomeSectionVisibility();
//       _startPeriodicHomeVisibilityCheck();
//     });
//   }

//   void _startPeriodicHomeVisibilityCheck() {
//     Future.delayed(const Duration(milliseconds: 200), () {
//       if (mounted) {
//         _checkHomeSectionVisibility();
//         _startPeriodicHomeVisibilityCheck();
//       }
//     });
//   }

//   void _checkHomeSectionVisibility() {
//     if (!mounted) return;
//     if (!_scrollController.hasClients) return;

//     try {
//       final screenSize = MediaQuery.of(context).size;
//       final screenHeight = screenSize.height;
//       final isMobile = screenSize.width < 768;

//       // Use scroll offset to determine home section visibility
//       // Home section is visible when scroll offset is near 0
//       final scrollOffset = _scrollController.offset;

//       // Calculate how much of the screen is showing the home section
//       // When scrollOffset = 0, home is 100% visible
//       // When scrollOffset >= screenHeight, home is 0% visible
//       final homeVisibilityPercentage =
//           1.0 - (scrollOffset / screenHeight).clamp(0.0, 1.0);

//       // Use lower threshold for mobile (85%) to account for nav bar, etc.
//       final visibilityThreshold = isMobile ? 0.85 : 0.95;
//       final isVisible = homeVisibilityPercentage >= visibilityThreshold;

//       if (isVisible && !_homeSectionVisible && mounted) {
//         setState(() {
//           _homeSectionVisible = true;
//         });
//         // Reset animations when home section becomes visible
//         _resetAboutAnimation?.call();
//         // _resetSkillsAnimations?.call();
//         // _resetProjectsAnimations?.call();
//         // _resetExperienceAnimations?.call();
//         // _resetContactAnimations?.call();
//       } else if (!isVisible && _homeSectionVisible && mounted) {
//         setState(() {
//           _homeSectionVisible = false;
//         });
//       }
//     } catch (e) {
//       // Silently handle errors
//     }
//   }

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.resumed && mounted) {
//       _checkHomeSectionVisibility();
//     }
//   }

//   void _snapToOffset(double targetOffset) {
//     if (_isAutoScrolling) return;

//     _isAutoScrolling = true;
//     _scrollController
//         .animateTo(
//           targetOffset,
//           duration: const Duration(milliseconds: 400),
//           curve: Curves.easeOutCubic,
//         )
//         .then((_) {
//           if (mounted) {
//             _isAutoScrolling = false;
//           }
//         });
//   }

//   void _onScroll() {
//     if (!_scrollController.hasClients) return;

//     // determine current section based on which sectino is most visible
//     final int newSection = _calculateCurrentSection();

//     if (newSection != _currentSection) {
//       setState(() {
//         _currentSection = newSection;
//       });
//     }
//   }

//   int _calculateCurrentSection() {
//     final screenHeight = MediaQuery.of(context).size.height;
//     final scrollOffset = _scrollController.hasClients
//         ? _scrollController.offset
//         : 0.0;

//     // Home section is fixed, so check scroll offset first
//     // If we haven't scrolled past the home section height, we're on home
//     if (scrollOffset < screenHeight * 0.5) {
//       return 0; // Home section
//     }

//     // For other sections, calculate based on their position in the scroll view
//     final sectionKeys = [_aboutSectionKey];

//     final viewportCenter = screenHeight / 2;

//     int closestSection = 1; // Default to About section
//     double closestDistance = double.infinity;

//     for (int i = 0; i < sectionKeys.length; i++) {
//       final key = sectionKeys[i];
//       final context = key.currentContext;
//       if (context == null) continue;

//       final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
//       if (renderBox == null || !renderBox.hasSize) continue;

//       try {
//         final position = renderBox.localToGlobal(Offset.zero);
//         final sectionTop = position.dy;
//         final sectionHeight = renderBox.size.height;
//         final sectionCenter = sectionTop + (sectionHeight / 2);

//         // Calculate distance from section center to viewport center
//         final distance = (sectionCenter - viewportCenter).abs();

//         if (distance < closestDistance) {
//           closestDistance = distance;
//           closestSection = i + 1; // +1 because index 0 is Home
//         }
//       } catch (e) {
//         // Silently handle errors
//       }
//     }

//     return closestSection;
//   }

//   /// Called when user stops scrolling - triggers snap if needed
//   void _onScrollEnd() {
//     if (_isAutoScrolling || !_scrollController.hasClients) return;

//     final scrollOffset = _scrollController.offset;
//     final screenHeight = MediaQuery.of(context).size.height;
//     final screenWidth = MediaQuery.of(context).size.width;
//     final isMobile = screenWidth < 768;

//     // Only apply snap between Home and About sections
//     if (scrollOffset > 0 && scrollOffset < screenHeight) {
//       // Use 20% threshold for mobile (snaps earlier), 30% for desktop
//       final snapThreshold = isMobile ? 0.2 : 0.3;

//       // If scrolled more than (1-threshold)% (Home only threshold% visible), snap to About
//       if (scrollOffset >= screenHeight * (1 - snapThreshold)) {
//         _snapToOffset(screenHeight);
//       }
//       // If scrolled less than threshold% (About only threshold% visible), snap to Home
//       else if (scrollOffset <= screenHeight * snapThreshold) {
//         _snapToOffset(0);
//       }
//       // In between, snap to the closer section
//       else if (scrollOffset >= screenHeight * 0.2) {
//         _snapToOffset(screenHeight);
//       } else {
//         _snapToOffset(0);
//       }
//     }
//   }

//   void _scrollToSection(int sectionIndex) {
//     if (sectionIndex < 0 || sectionIndex > 5) return;

//     // Special case for Home section - scroll to top
//     if (sectionIndex == 0) {
//       _scrollController.animateTo(
//         0,
//         duration: const Duration(milliseconds: 800),
//         curve: Curves.easeInOut,
//       );
//       return;
//     }

//     final sectionKeys = [
//       _aboutSectionKey,
//       // _skillsSectionKey,
//       // _projectsSectionKey,
//       // _experienceSectionKey,
//       // _contactSectionKey,
//     ];

//     final keyIndex = sectionIndex - 1; // Adjust for Home being index 0
//     if (keyIndex < 0 || keyIndex >= sectionKeys.length) return;

//     final key = sectionKeys[keyIndex];
//     final context = key.currentContext;
//     if (context == null) return;

//     final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
//     if (renderBox == null) return;

//     try {
//       final position = renderBox.localToGlobal(Offset.zero);
//       final scrollOffset = _scrollController.offset;
//       final targetOffset = scrollOffset + position.dy;

//       _scrollController.animateTo(
//         targetOffset,
//         duration: const Duration(milliseconds: 800),
//         curve: Curves.easeInOut,
//       );
//     } catch (e) {
//       // Fallback to old method
//       final double screenHeight = MediaQuery.of(this.context).size.height;
//       final double targetOffset = sectionIndex * screenHeight;
//       _scrollController.animateTo(
//         targetOffset,
//         duration: const Duration(milliseconds: 800),
//         curve: Curves.easeInOut,
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;

//     // Define the two categories

//     final homeSection = SizedBox(
//       key: _homeSectionKey,
//       height: screenHeight,
//       child: HomeSection(),
//     );

//     final stackingSections = [
//       SizedBox(
//         key: _aboutSectionKey,
//         height: screenHeight,
//         child: AboutSection(
//           onRegisterReset: (resetCallback) {
//             _resetAboutAnimation = resetCallback;
//           },
//           isFirstStackingSection: true,
//         ),
//       ),
//       SizedBox(
//         key: _aboutSectionKey,
//         height: screenHeight,
//         child: AboutSection(
//           onRegisterReset: (resetCallback) {
//             _resetAboutAnimation = resetCallback;
//           },
//           isFirstStackingSection: true,
//         ),
//       ),
//     ];

//     return Scaffold(
//       backgroundColor: Color.fromARGB(255, 4, 35, 40),
//       body: SafeArea(
//         child: MouseRegion(
//           onEnter: (_) => setState(() => _isCursorInside = true),
//           onExit: (_) => setState(() => _isCursorInside = false),
//           onHover: (event) {
//             setState(() {
//               _cursorPosition = event.position;
//             });
//           },
//           child: Stack(
//             children: [
//               Positioned(
//                 top: 0,
//                 left: 0,
//                 right: 0,
//                 height: screenHeight,
//                 child: _ScrollableHomeSection(
//                   scrollController: _scrollController,
//                   onScrollEnd: _onScrollEnd,
//                   child: homeSection,
//                 ),
//               ),

//               // ===== CATEGORY 2: Stacking Sections (Scroll over home) =====
//               _StackingSectionsScrollView(
//                 scrollController: _scrollController,
//                 spacerHeight: screenHeight,
//                 sections: stackingSections,
//                 onScrollEnd: _onScrollEnd,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// /// Wraps the Home section to handle scroll gestures (mouse wheel & touch)
// /// while allowing all other interactions to pass through to child widgets.
// /// Uses raw pointer events which don't compete in the gesture arena.
// class _ScrollableHomeSection extends StatefulWidget {
//   final ScrollController scrollController;
//   final VoidCallback? onScrollEnd;
//   final Widget child;

//   const _ScrollableHomeSection({
//     required this.scrollController,
//     this.onScrollEnd,
//     required this.child,
//   });

//   @override
//   State<_ScrollableHomeSection> createState() => _ScrollableHomeSectionState();
// }

// class _ScrollableHomeSectionState extends State<_ScrollableHomeSection> {
//   // Track active pointers for touch scrolling
//   final Map<int, Offset> _pointerPositions = {};
//   bool _hasScrolled = false;

//   void _handleScroll(double delta) {
//     if (!widget.scrollController.hasClients) return;
//     _hasScrolled = true;

//     final maxExtent = widget.scrollController.position.maxScrollExtent;
//     final newOffset = widget.scrollController.offset + delta;
//     widget.scrollController.jumpTo(newOffset.clamp(0.0, maxExtent));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Listener(
//       behavior: HitTestBehavior.translucent,
//       // Mouse wheel scrolling
//       onPointerSignal: (event) {
//         if (event is PointerScrollEvent) {
//           _handleScroll(event.scrollDelta.dy);
//           // Trigger scroll end after a short delay for mouse wheel
//           Future.delayed(const Duration(milliseconds: 200), () {
//             if (_hasScrolled) {
//               _hasScrolled = false;
//               widget.onScrollEnd?.call();
//             }
//           });
//         }
//       },
//       // Track touch pointer positions for scrolling
//       onPointerDown: (event) {
//         _pointerPositions[event.pointer] = event.position;
//       },
//       onPointerMove: (event) {
//         final lastPosition = _pointerPositions[event.pointer];
//         if (lastPosition != null) {
//           final delta = event.position - lastPosition;
//           // Only scroll if primarily vertical movement
//           if (delta.dy.abs() > delta.dx.abs() && delta.dy.abs() > 2) {
//             _handleScroll(-delta.dy);
//           }
//           _pointerPositions[event.pointer] = event.position;
//         }
//       },
//       onPointerUp: (event) {
//         _pointerPositions.remove(event.pointer);
//         // Trigger scroll end when user lifts finger
//         if (_hasScrolled && _pointerPositions.isEmpty) {
//           _hasScrolled = false;
//           widget.onScrollEnd?.call();
//         }
//       },
//       onPointerCancel: (event) {
//         _pointerPositions.remove(event.pointer);
//         if (_hasScrolled && _pointerPositions.isEmpty) {
//           _hasScrolled = false;
//           widget.onScrollEnd?.call();
//         }
//       },
//       // Child receives all events - Listener doesn't block anything
//       child: widget.child,
//     );
//   }
// }

// //  Scroll view for stacking sections with a transparent spacer area.
// /// Uses AbsorbPointer to block events in the spacer area so Home section
// /// can receive them, while allowing events through to sections.
// class _StackingSectionsScrollView extends StatefulWidget {
//   final ScrollController scrollController;
//   final double spacerHeight;
//   final List<Widget> sections;
//   final VoidCallback? onScrollEnd;

//   const _StackingSectionsScrollView({
//     required this.scrollController,
//     required this.spacerHeight,
//     required this.sections,
//     this.onScrollEnd,
//   });

//   @override
//   State<_StackingSectionsScrollView> createState() =>
//       _StackingSectionsScrollViewState();
// }

// class _StackingSectionsScrollViewState
//     extends State<_StackingSectionsScrollView> {
//   double _scrollOffset = 0;

//   @override
//   void initState() {
//     super.initState();
//     widget.scrollController.addListener(_onScroll);
//   }

//   void _onScroll() {
//     if (mounted) {
//       setState(() {
//         _scrollOffset = widget.scrollController.offset;
//       });
//     }
//   }

//   @override
//   void dispose() {
//     widget.scrollController.removeListener(_onScroll);
//     super.dispose();
//   }

//   bool _onScrollNotification(ScrollNotification notification) {
//     if (notification is ScrollEndNotification) {
//       widget.onScrollEnd?.call();
//     }
//     return false;
//   }

//   @override
//   Widget build(BuildContext context) {
//     // When we're in the spacer area (showing Home section),
//     // ignore ALL pointer events so they pass through to Home section.
//     // Only become interactive when sections are visible.
//     final isInSpacerArea = _scrollOffset < widget.spacerHeight;

//     return IgnorePointer(
//       // Ignore events when in spacer area - lets Home section receive them
//       ignoring: isInSpacerArea,
//       child: NotificationListener<ScrollNotification>(
//         onNotification: _onScrollNotification,
//         child: SingleChildScrollView(
//           controller: widget.scrollController,
//           physics: const ClampingScrollPhysics(),
//           child: Column(
//             children: [
//               // Spacer for home section
//               SizedBox(height: widget.spacerHeight),
//               // Stacking sections
//               ...widget.sections,
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
