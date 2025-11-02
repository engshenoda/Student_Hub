// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:linkedin/features/questions/Logic/cubit/career_preference_cubit.dart';
// import 'career_next_screen.dart'; // adjust path if needed

// const Color kPrimary = Color(0xFF00B894);

// class CareerPreferenceScreen extends StatefulWidget {
//   const CareerPreferenceScreen({Key? key}) : super(key: key);

//   @override
//   State<CareerPreferenceScreen> createState() => _CareerPreferenceScreenState();
// }

// class _CareerPreferenceScreenState extends State<CareerPreferenceScreen> {
//   int selectedOption = -1;
//   final options = [
//     "Yes, actively looking",
//     "I'm open",
//     "Not open"
//   ];

//   double responsive(BuildContext context, double value) {
//     final size = MediaQuery.of(context).size;
//     final shortestSide = size.shortestSide;
//     final longestSide = size.longestSide;
//     final scaleFactor = (shortestSide / 390 + longestSide / 844) / 2;
//     return value * scaleFactor.clamp(0.7, 1.4);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final s = (double px) => responsive(context, px);
//     final userId = FirebaseAuth.instance.currentUser?.uid ?? "demoUser";

//     return BlocProvider(
//       create: (_) => CareerPreferenceCubit()..fetchCareerPreference(userId),
//       child: BlocConsumer<CareerPreferenceCubit, CareerPreferenceState>(
//         listener: (context, state) {
//           if (state is CareerPreferenceLoaded && state.selectedOption.isNotEmpty) {
//             final idx = options.indexOf(state.selectedOption);
//             if (idx >= 0 && idx != selectedOption) {
//               setState(() {
//                 selectedOption = idx;
//               });
//             }
//           }
//         },
//         builder: (context, state) {
//           return Scaffold(
//             backgroundColor: const Color(0xFFF7F7F9),
//             body: SafeArea(
//               child: Center(
//                 child: ConstrainedBox(
//                   constraints: const BoxConstraints(maxWidth: 600),
//                   child: Column(
//                     children: [
//                       Container(height: 8, color: kPrimary, width: double.infinity),
//                       Expanded(
//                         child: SingleChildScrollView(
//                           padding: EdgeInsets.symmetric(horizontal: s(18), vertical: s(10)),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               _CareerHeader(scale: s),
//                               SizedBox(height: s(12)),
//                               Text(
//                                 'Are you currently looking for new opportunities?',
//                                 style: TextStyle(
//                                   fontSize: s(20),
//                                   fontWeight: FontWeight.w700,
//                                 ),
//                               ),
//                               SizedBox(height: s(12)),
//                               ...List.generate(options.length, (index) => Padding(
//                                 padding: EdgeInsets.only(bottom: s(12)),
//                                 child: _optionCard(
//                                   s: s,
//                                   index: index,
//                                   icon: [
//                                     Icons.search_rounded,
//                                     Icons.work_outline_rounded,
//                                     Icons.close_rounded
//                                   ][index],
//                                   title: options[index],
//                                   subtitle: [
//                                     "Receive exclusive job invites and get contacted by employers.",
//                                     "Choose this to occasionally receive exclusive job invites.",
//                                     "You can change this later by the time you need to find new jobs.",
//                                   ][index],
//                                 ),
//                               )),
//                               SizedBox(height: s(100)),
//                               Row(
//                                 children: [
//                                   Expanded(
//                                     child: OutlinedButton(
//                                       onPressed: () => Navigator.of(context).maybePop(),
//                                       style: OutlinedButton.styleFrom(
//                                         padding: EdgeInsets.symmetric(vertical: s(16)),
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.circular(s(28)),
//                                         ),
//                                         side: BorderSide(color: Colors.grey.shade300),
//                                         backgroundColor: Colors.white,
//                                       ),
//                                       child: Text(
//                                         'Back',
//                                         style: TextStyle(fontSize: s(16), color: Colors.grey[800]),
//                                       ),
//                                     ),
//                                   ),
//                                   SizedBox(width: s(12)),
//                                   Expanded(
//                                     child: ElevatedButton(
//                                       onPressed: selectedOption != -1
//                                           ? () async {
//                                               await context.read<CareerPreferenceCubit>().updateCareerPreference(
//                                                 userId,
//                                                 options[selectedOption]
//                                               );
//                                               if (context.mounted) {
//                                                 Navigator.push(
//                                                   context,
//                                                   MaterialPageRoute(builder: (_) => const CareerNextScreen()),
//                                                 );
//                                               }
//                                             }
//                                           : null,
//                                       style: ElevatedButton.styleFrom(
//                                         padding: EdgeInsets.symmetric(vertical: s(16)),
//                                         backgroundColor: kPrimary,
//                                         shape: RoundedRectangleBorder(
//                                           borderRadius: BorderRadius.circular(s(28)),
//                                         ),
//                                         elevation: 4,
//                                       ),
//                                       child: Text(
//                                         'Next',
//                                         style: TextStyle(fontSize: s(16), fontWeight: FontWeight.w600),
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               SizedBox(height: s(26)),
//                               if (state is CareerPreferenceError)
//                                 Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Text(state.message, style: const TextStyle(color: Colors.red)),
//                                 ),
//                               if (state is CareerPreferenceUploading)
//                                 Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: Center(child: CircularProgressIndicator()),
//                                 ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _optionCard({
//     required double Function(double) s,
//     required int index,
//     required IconData icon,
//     required String title,
//     required String subtitle,
//   }) {
//     final bool isSelected = selectedOption == index;
//     return GestureDetector(
//       onTap: () => setState(() => selectedOption = index),
//       child: Container(
//         width: double.infinity,
//         padding: EdgeInsets.all(s(12)),
//         decoration: BoxDecoration(
//           color: isSelected ? kPrimary.withOpacity(0.08) : Colors.white,
//           borderRadius: BorderRadius.circular(s(12)),
//           border: Border.all(color: isSelected ? kPrimary : Colors.grey.shade300, width: 1.5),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.04),
//               blurRadius: 12,
//               offset: const Offset(0, 6),
//             )
//           ],
//         ),
//         child: Row(
//           children: [
//             CircleAvatar(
//               backgroundColor: kPrimary.withOpacity(0.12),
//               radius: s(18),
//               child: Icon(icon, color: kPrimary, size: s(18)),
//             ),
//             SizedBox(width: s(12)),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(title, style: TextStyle(fontSize: s(15), fontWeight: FontWeight.w600, color: Colors.black)),
//                   SizedBox(height: s(6)),
//                   Text(subtitle, style: TextStyle(fontSize: s(13), height: 1.3, color: Colors.grey[700])),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class _CareerHeader extends StatelessWidget {
//   final double Function(double) scale;
//   const _CareerHeader({required this.scale});
//   @override
//   Widget build(BuildContext context) {
//     final s = scale;
//     return Row(
//       children: [
//         Column(
//           children: [
//             _StepCircleProgress(fillPercent: 1.0, size: s(28), hasCheck: true),
//             SizedBox(height: s(6)),
//             Text('Profile', style: TextStyle(fontSize: s(12), color: Colors.grey[700])),
//           ],
//         ),
//         Expanded(
//           child: Container(height: s(1), margin: EdgeInsets.symmetric(horizontal: s(10)), color: Colors.grey.shade300),
//         ),
//         Column(
//           children: [
//             _StepCircleProgress(fillPercent: 0.50, size: s(28)),
//             SizedBox(height: s(6)),
//             Text('Career Preference', style: TextStyle(fontSize: s(12), color: Colors.grey[700])),
//           ],
//         ),
//         Expanded(
//           child: Container(height: s(1), margin: EdgeInsets.symmetric(horizontal: s(10)), color: Colors.grey.shade300),
//         ),
//         Column(
//           children: [
//             _StepCircleProgress(fillPercent: 0.0, size: s(28)),
//             SizedBox(height: s(6)),
//             Text('Docs', style: TextStyle(fontSize: s(12), color: Colors.grey[700])),
//           ],
//         ),
//       ],
//     );
//   }
// }

// class _StepCircleProgress extends StatelessWidget {
//   final double fillPercent;
//   final double size;
//   final bool hasCheck;
//   const _StepCircleProgress({
//     required this.fillPercent,
//     required this.size,
//     this.hasCheck = false,
//   });
//   @override
//   Widget build(BuildContext context) {
//     return Stack(
//       alignment: Alignment.center,
//       children: [
//         Container(
//           width: size,
//           height: size,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             border: Border.all(color: kPrimary, width: 2),
//           ),
//         ),
//         ClipOval(
//           child: Align(
//             alignment: Alignment.bottomCenter,
//             heightFactor: fillPercent.clamp(0.0, 1.0),
//             child: Container(width: size, height: size, color: kPrimary),
//           ),
//         ),
//         if (hasCheck)
//           Icon(Icons.check, size: size * 0.6, color: Colors.white),
//       ],
//     );
//   }
// }
