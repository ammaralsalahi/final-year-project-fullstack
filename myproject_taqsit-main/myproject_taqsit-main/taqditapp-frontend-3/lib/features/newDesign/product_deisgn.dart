// import 'package:flutter/material.dart';

// class ProductDeisgn extends StatefulWidget {
//   const ProductDeisgn({super.key});

//   @override
//   State<ProductDeisgn> createState() => _ProductDeisgnState();
// }

// class _ProductDeisgnState extends State<ProductDeisgn>
//     with SingleTickerProviderStateMixin {
//   late final AnimationController _controller;
//   late final Animation<double> _heroFade;
//   late final Animation<double> _heroScale;
//   late final Animation<double> _infoFade;
//   late final Animation<Offset> _planSlide;
//   late final Animation<double> _bottomFade;

//   final bool isInstallmentAvailable = true;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1200),
//     );

//     _heroFade = CurvedAnimation(
//       parent: _controller,
//       curve: const Interval(0.0, 0.35, curve: Curves.easeOut),
//     );

//     _heroScale = Tween<double>(begin: 0.92, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _controller,
//         curve: const Interval(0.0, 0.45, curve: Curves.easeOutBack),
//       ),
//     );

//     _infoFade = CurvedAnimation(
//       parent: _controller,
//       curve: const Interval(0.25, 0.65, curve: Curves.easeOut),
//     );

//     _planSlide = Tween<Offset>(begin: const Offset(0, 0.24), end: Offset.zero)
//         .animate(
//           CurvedAnimation(
//             parent: _controller,
//             curve: const Interval(0.55, 0.9, curve: Curves.easeOut),
//           ),
//         );

//     _bottomFade = CurvedAnimation(
//       parent: _controller,
//       curve: const Interval(0.7, 1.0, curve: Curves.easeOut),
//     );

//     _controller.forward();
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF4F1EE),
//       bottomNavigationBar: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//           child: ConstrainedBox(
//             constraints: const BoxConstraints(maxWidth: 430),
//             child: FadeTransition(
//               opacity: _bottomFade,
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: OutlinedButton(
//                       style: OutlinedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(vertical: 16),
//                         side: const BorderSide(color: Color(0xFF8B7E76)),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(18),
//                         ),
//                         foregroundColor: const Color(0xFF5F534D),
//                       ),
//                       onPressed: () {},
//                       child: const Text(
//                         'اشترِ مباشرة',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 12),
//                   Expanded(
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF2E1D13),
//                         padding: const EdgeInsets.symmetric(vertical: 16),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(18),
//                         ),
//                         elevation: 8,
//                         shadowColor: Colors.black26,
//                       ),
//                       onPressed: () {},
//                       child: const Text(
//                         'تقسيط',
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontSize: 16,
//                           fontWeight: FontWeight.w700,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//       body: SafeArea(
//         child: Center(
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.symmetric(vertical: 16),
//             child: ConstrainedBox(
//               constraints: const BoxConstraints(maxWidth: 430),
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16),
//                 child: Column(
//                   children: [
//                     Container(
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(34),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.08),
//                             blurRadius: 32,
//                             offset: const Offset(0, 18),
//                           ),
//                         ],
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.stretch,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 FadeTransition(
//                                   opacity: _heroFade,
//                                   child: Container(
//                                     padding: const EdgeInsets.symmetric(
//                                       horizontal: 16,
//                                       vertical: 14,
//                                     ),
//                                     decoration: BoxDecoration(
//                                       color: const Color(0xFFF6F0E7),
//                                       borderRadius: BorderRadius.circular(32),
//                                       border: Border.all(
//                                         color: const Color(0xFFE5DACD),
//                                         width: 1,
//                                       ),
//                                     ),
//                                     child: Row(
//                                       children: [
//                                         Container(
//                                           width: 35,
//                                           height: 35,
//                                           decoration: BoxDecoration(
//                                             color: Colors.white,
//                                             borderRadius: BorderRadius.circular(
//                                               16,
//                                             ),
//                                             boxShadow: [
//                                               BoxShadow(
//                                                 color: Colors.black.withOpacity(
//                                                   0.08,
//                                                 ),
//                                                 blurRadius: 12,
//                                                 offset: const Offset(0, 6),
//                                               ),
//                                             ],
//                                           ),
//                                           child: const Icon(
//                                             Icons.arrow_back_ios_new,
//                                             size: 15,
//                                             color: Color(0xFF3E332B),
//                                           ),
//                                         ),
//                                         const SizedBox(width: 12),
//                                         Expanded(
//                                           child: Center(
//                                             child: const Text(
//                                               'MAISON HORLOGÈRE',
//                                               maxLines: 1,
//                                               overflow: TextOverflow.ellipsis,
//                                               style: TextStyle(
//                                                 color: Color(0xFF3E332B),
//                                                 fontSize: 12,
//                                                 fontWeight: FontWeight.w600,
//                                                 letterSpacing: 2,
//                                               ),
//                                             ),
//                                           ),
//                                         ),
//                                         const SizedBox(width: 12),
//                                         Container(
//                                           width: 35,
//                                           height: 35,
//                                           decoration: BoxDecoration(
//                                             color: Colors.white,
//                                             borderRadius: BorderRadius.circular(
//                                               16,
//                                             ),
//                                             boxShadow: [
//                                               BoxShadow(
//                                                 color: Colors.black.withOpacity(
//                                                   0.08,
//                                                 ),
//                                                 blurRadius: 12,
//                                                 offset: const Offset(0, 6),
//                                               ),
//                                             ],
//                                           ),
//                                           child: const Icon(
//                                             Icons.share,
//                                             size: 15,
//                                             color: Color(0xFF3E332B),
//                                           ),
//                                         ),
//                                         const SizedBox(width: 10),
//                                         Container(
//                                           width: 35,
//                                           height: 35,
//                                           decoration: BoxDecoration(
//                                             color: Colors.white,
//                                             borderRadius: BorderRadius.circular(
//                                               16,
//                                             ),
//                                             boxShadow: [
//                                               BoxShadow(
//                                                 color: Colors.black.withOpacity(
//                                                   0.08,
//                                                 ),
//                                                 blurRadius: 12,
//                                                 offset: const Offset(0, 6),
//                                               ),
//                                             ],
//                                           ),
//                                           child: const Icon(
//                                             Icons.favorite_border,
//                                             size: 15,
//                                             color: Color(0xFF3E332B),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(height: 16),
//                                 ScaleTransition(
//                                   scale: _heroScale,
//                                   child: Container(
//                                     decoration: BoxDecoration(
//                                       color: const Color(0xFFF7F1E6),
//                                       borderRadius: BorderRadius.circular(34),
//                                       boxShadow: [
//                                         BoxShadow(
//                                           color: Colors.black.withOpacity(0.08),
//                                           blurRadius: 24,
//                                           offset: const Offset(0, 18),
//                                         ),
//                                       ],
//                                     ),
//                                     padding: const EdgeInsets.all(18),
//                                     child: ClipRRect(
//                                       borderRadius: BorderRadius.circular(30),
//                                       child: Stack(
//                                         children: [
//                                           Container(
//                                             height: 270,
//                                             decoration: BoxDecoration(
//                                               color: const Color(0xFFE5D8C8),
//                                               borderRadius:
//                                                   BorderRadius.circular(30),
//                                             ),
//                                             child: Image.asset(
//                                               'assets/images/products/watch.jpg',
//                                               fit: BoxFit.cover,
//                                             ),
//                                           ),
//                                           Positioned(
//                                             left: 18,
//                                             top: 18,
//                                             child: Container(
//                                               padding:
//                                                   const EdgeInsets.symmetric(
//                                                     horizontal: 12,
//                                                     vertical: 8,
//                                                   ),
//                                               decoration: BoxDecoration(
//                                                 color: Colors.white.withOpacity(
//                                                   0.92,
//                                                 ),
//                                                 borderRadius:
//                                                     BorderRadius.circular(20),
//                                               ),
//                                               child: const Text(
//                                                 'NEW ARRIVAL',
//                                                 style: TextStyle(
//                                                   fontSize: 11,
//                                                   fontWeight: FontWeight.w700,
//                                                   color: Color(0xFF3E332B),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                           Positioned(
//                                             right: 18,
//                                             top: 18,
//                                             child: Container(
//                                               padding:
//                                                   const EdgeInsets.symmetric(
//                                                     horizontal: 12,
//                                                     vertical: 8,
//                                                   ),
//                                               decoration: BoxDecoration(
//                                                 color: Colors.white.withOpacity(
//                                                   0.86,
//                                                 ),
//                                                 borderRadius:
//                                                     BorderRadius.circular(20),
//                                               ),
//                                               child: const Text(
//                                                 'Best Seller',
//                                                 style: TextStyle(
//                                                   fontSize: 12,
//                                                   fontWeight: FontWeight.w600,
//                                                   color: Color(0xFF4B3A2F),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(height: 24),
//                                 FadeTransition(
//                                   opacity: _infoFade,
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: const [
//                                       Text(
//                                         'Heritage Chronograph 41mm',
//                                         style: TextStyle(
//                                           color: Color(0xFF221B17),
//                                           fontSize: 26,
//                                           fontWeight: FontWeight.w700,
//                                           height: 1.1,
//                                         ),
//                                       ),
//                                       SizedBox(height: 10),
//                                       Row(
//                                         children: [
//                                           Icon(
//                                             Icons.money_off,
//                                             size: 35,
//                                             color: Color.fromARGB(
//                                               255,
//                                               5,
//                                               228,
//                                               35,
//                                             ),
//                                           ),
//                                           SizedBox(width: 1),
//                                           ///////////
//                                           Text(
//                                             '4,250',
//                                             style: TextStyle(
//                                               color: Color(0xFF2E1D13),
//                                               fontSize: 28,
//                                               fontWeight: FontWeight.w800,
//                                             ),
//                                           ),

//                                           /////////////
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 const SizedBox(height: 20),
//                                 FadeTransition(
//                                   opacity: _infoFade,
//                                   child: const Text(
//                                     'Classic heritage design meets modern luxury. The Héritage Chronograph blends premium materials with a statement dial and elegant matte finish. Perfect for daily wear and special occasions.',
//                                     style: TextStyle(
//                                       color: Color(0xFF6B5F53),
//                                       fontSize: 15,
//                                       height: 1.7,
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(height: 26),
//                                 FadeTransition(
//                                   opacity: _infoFade,
//                                   child: Container(
//                                     padding: const EdgeInsets.all(18),
//                                     decoration: BoxDecoration(
//                                       color: const Color(0xFFF8F3EE),
//                                       borderRadius: BorderRadius.circular(24),
//                                       border: Border.all(
//                                         color: const Color(0xFFE1D7CC),
//                                       ),
//                                     ),
//                                     child: Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: const [
//                                             Text(
//                                               'Case Size',
//                                               style: TextStyle(
//                                                 fontSize: 12,
//                                                 fontWeight: FontWeight.w500,
//                                                 color: Color(0xFF8B7E76),
//                                               ),
//                                             ),
//                                             SizedBox(height: 8),
//                                             Text(
//                                               '41 mm',
//                                               style: TextStyle(
//                                                 fontSize: 16,
//                                                 fontWeight: FontWeight.w700,
//                                                 color: Color(0xFF2E1D13),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                         Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: const [
//                                             Text(
//                                               'Strap',
//                                               style: TextStyle(
//                                                 fontSize: 12,
//                                                 fontWeight: FontWeight.w500,
//                                                 color: Color(0xFF8B7E76),
//                                               ),
//                                             ),
//                                             SizedBox(height: 8),
//                                             Text(
//                                               'Espresso Leather',
//                                               style: TextStyle(
//                                                 fontSize: 16,
//                                                 fontWeight: FontWeight.w700,
//                                                 color: Color(0xFF2E1D13),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                                 const SizedBox(height: 20),
//                               ],
//                             ),
//                           ),
//                           if (isInstallmentAvailable)
//                             SlideTransition(
//                               position: _planSlide,
//                               child: Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 24,
//                                 ),
//                                 child: Container(
//                                   margin: const EdgeInsets.only(bottom: 24),
//                                   padding: const EdgeInsets.all(22),
//                                   decoration: BoxDecoration(
//                                     color: const Color(0xFF2E1D13),
//                                     borderRadius: BorderRadius.circular(28),
//                                     boxShadow: [
//                                       BoxShadow(
//                                         color: const Color(
//                                           0xFF2E1D13,
//                                         ).withOpacity(0.18),
//                                         blurRadius: 26,
//                                         offset: const Offset(0, 16),
//                                       ),
//                                     ],
//                                   ),
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.stretch,
//                                     children: [
//                                       const Text(
//                                         'Installment Plan',
//                                         style: TextStyle(
//                                           color: Colors.white,
//                                           fontSize: 16,
//                                           fontWeight: FontWeight.w700,
//                                         ),
//                                       ),
//                                       const SizedBox(height: 10),
//                                       const Text(
//                                         'Available now • Limited offer',
//                                         style: TextStyle(
//                                           color: Color(0xFFB9A997),
//                                           fontSize: 13,
//                                           height: 1.5,
//                                         ),
//                                       ),
//                                       const SizedBox(height: 22),
//                                       Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           Column(
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: const [
//                                               Text(
//                                                 'Down Payment',
//                                                 style: TextStyle(
//                                                   color: Color(0xFFB9A997),
//                                                   fontSize: 12,
//                                                 ),
//                                               ),
//                                               SizedBox(height: 8),
//                                               Text(
//                                                 '\$1,240',
//                                                 style: TextStyle(
//                                                   color: Colors.white,
//                                                   fontSize: 24,
//                                                   fontWeight: FontWeight.w800,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                           Container(
//                                             padding: const EdgeInsets.symmetric(
//                                               horizontal: 16,
//                                               vertical: 12,
//                                             ),
//                                             decoration: BoxDecoration(
//                                               color: const Color(0xFF443226),
//                                               borderRadius:
//                                                   BorderRadius.circular(20),
//                                             ),
//                                             child: const Text(
//                                               '6 months plan',
//                                               style: TextStyle(
//                                                 color: Colors.white,
//                                                 fontSize: 13,
//                                                 fontWeight: FontWeight.w600,
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       const SizedBox(height: 18),
//                                       Container(
//                                         padding: const EdgeInsets.all(16),
//                                         decoration: BoxDecoration(
//                                           color: const Color(0xFF3D2B20),
//                                           borderRadius: BorderRadius.circular(
//                                             22,
//                                           ),
//                                         ),
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: const [
//                                             Text(
//                                               '\$450 / month',
//                                               style: TextStyle(
//                                                 color: Colors.white,
//                                                 fontSize: 20,
//                                                 fontWeight: FontWeight.w700,
//                                               ),
//                                             ),
//                                             SizedBox(height: 6),
//                                             Text(
//                                               'for 6 months with flexible approval',
//                                               style: TextStyle(
//                                                 color: Color(0xFFB9A997),
//                                                 fontSize: 13,
//                                                 height: 1.6,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(height: 51),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
