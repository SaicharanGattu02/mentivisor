// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// class Walletscreen extends StatefulWidget {
//   const Walletscreen({Key? key}) : super(key: key);
//
//   @override
//   State<Walletscreen> createState() => _WalletscreenState();
// }
//
// class _WalletscreenState extends State<Walletscreen> {
//   @override
//   void initState() {
//     context.read<WalletmoneyCubit>().getwalletmoney();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xffFFF8EC), // Light yellow background
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         title: Center(
//           child: Text(
//             'Book Session',
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: Colors.black, // Blue
//               fontFamily: 'Segoe',
//             ),
//           ),
//         ),
//
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(4),
//           child: const Text(
//             'Manage your coins and track your earnings',
//             style: TextStyle(
//               fontSize: 14,
//               color: Color(0xFF666666), // Grey
//               fontFamily: 'Segoe',
//             ),
//           ),
//         ),
//       ),
//       body: Column(
//         children: [
//           // Balance Section
//           BlocBuilder<WalletmoneyCubit, WalletmoneyState>(
//             builder: (context, state) {
//               if (state is WalletmoneyStateLoading) {
//                 return Center(child: CircularProgressIndicator());
//               } else if (state is WalletmoneyStateLoaded) {
//                 final coins = state.walletResponseModel.data?.wallet;
//                 return Container(
//                   width: double.infinity,
//                   padding: const EdgeInsets.all(16),
//                   decoration: const BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [
//                         Color(0xFFFFA726), // Orange start
//                         Color(0xFFFF9800), // Orange end
//                       ],
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                     ),
//                   ),
//                   child: Column(
//                     children: [
//                       const Icon(
//                         Icons.monetization_on,
//                         size: 40,
//                         color: Colors.white,
//                       ),
//                       const SizedBox(height: 16),
//                       const Text(
//                         'Current Balance',
//                         style: TextStyle(
//                           fontSize: 16,
//                           color: Colors.white,
//                           fontFamily: 'Segoe',
//                         ),
//                       ),
//                       Text(
//                         coins?.currentBalance ?? "0",
//                         style: TextStyle(
//                           fontSize: 36,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.white,
//                           fontFamily: 'Segoe',
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Column(
//                             children: [
//                               Text(
//                                 'Total Earned',
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   color: Colors.white,
//                                   fontFamily: 'Segoe',
//                                 ),
//                               ),
//                               Text(
//                                 coins?.totalEarned ?? "",
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                   fontFamily: 'Segoe',
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(width: 32),
//                           Column(
//                             children: [
//                               Text(
//                                 'Total Spent',
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   color: Colors.white,
//                                   fontFamily: 'Segoe',
//                                 ),
//                               ),
//                               Text(
//                                 coins?.totalSpent ?? "",
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.white,
//                                   fontFamily: 'Segoe',
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
//                       ElevatedButton.icon(
//                         onPressed: () {},
//                         icon: const Icon(
//                           Icons.add,
//                           size: 18,
//                           color: Color(0xFF8A56AC),
//                         ),
//                         label: const Text(
//                           'Buy Coins',
//                           style: TextStyle(
//                             fontFamily: 'Segoe',
//                             fontSize: 16,
//                             color: Color(0xFF8A56AC),
//                           ),
//                         ),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.white,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                           padding: const EdgeInsets.symmetric(
//                             vertical: 10,
//                             horizontal: 16,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               } else if (state is WalletmoneyStateFailure) {
//                 return Text(state.msg);
//               }
//               return SizedBox.shrink();
//             },
//           ),
//           const SizedBox(height: 16),
//           // Coin History & Achievements
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 const Text(
//                   'Coin History',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF121212),
//                     fontFamily: 'Segoe',
//                   ),
//                 ),
//                 const Text(
//                   'Achievements',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.bold,
//                     color: Color(0xFF121212),
//                     fontFamily: 'Segoe',
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 8),
//         ],
//       ),
//     );
//   }
// }
//
