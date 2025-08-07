// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:mentivisor/Mentee/Models/ECCModel.dart';
//
// class ProfileScreen1 extends StatelessWidget {
//   const ProfileScreen1({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         backgroundColor: const Color(0xFFF5F5FA),
//         appBar: AppBar(
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           leading: const BackButton(color: Colors.black87),
//           centerTitle: true,
//           title: const Text(
//             'Profile',
//             style: TextStyle(
//               color: Color(0xff121212),
//               fontSize: 18,
//               fontFamily: 'segeo',
//               fontWeight: FontWeight.w700,
//             ),
//           ),
//         ),
//         body: Column(
//           children: [
//             const SizedBox(height: 16),
//             // Profile Avatar
//             const CircleAvatar(
//               radius: 48,
//               backgroundImage: AssetImage('images/profileimg.png'),
//             ),
//             const SizedBox(height: 12),
//             // Name
//             const Text(
//               'Rahul',
//               style: TextStyle(
//                 color: Color(0xff121212),
//                 fontSize: 18,
//                 fontFamily: 'segeo',
//                 fontWeight: FontWeight.w700,
//               ),
//             ),
//
//             const SizedBox(height: 4),
//             // Subtitle
//             const Text(
//               'SVR College NZB 2nd year',
//               style: TextStyle(
//                 color: Color(0xff666666),
//                 fontSize: 14,
//                 fontFamily: 'segeo',
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//
//             const SizedBox(height: 12),
//             // Bio / Description
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 32),
//               child: Text(
//                 '"Future biologist, passionate about specific area of biology, e.g., marine ecosystems and always eager to learn more. Currently studying at University Name, and excited to see where my studies take me"',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   color: Color(0xff666666),
//                   fontSize: 12,
//                   fontFamily: 'segeo',
//                   fontWeight: FontWeight.w400,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 16),
//             // Action buttons
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 ElevatedButton.icon(
//                   onPressed: () {},
//                   icon: const Icon(Icons.edit, size: 16),
//                   label: const Text('Edit'),
//                   style: ElevatedButton.styleFrom(
//                     foregroundColor: Colors.blue,
//                     backgroundColor: Colors.white,
//                     side: const BorderSide(color: Colors.blue),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 20,
//                       vertical: 8,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 OutlinedButton.icon(
//                   onPressed: () {},
//                   icon: const Icon(Icons.share, size: 16),
//                   label: const Text('Share'),
//                   style: OutlinedButton.styleFrom(
//                     side: const BorderSide(color: Colors.blue),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(20),
//                     ),
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 20,
//                       vertical: 8,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             // Tab Bar
//             const TabBar(
//               indicatorColor: Colors.blue,
//               labelColor: Colors.blue,
//               unselectedLabelColor: Colors.grey,
//               tabs: [
//                 Tab(text: 'Posts'),
//                 Tab(text: 'Resources'),
//               ],
//             ),
//             // Tab Views
//             Expanded(
//               child: TabBarView(
//                 children: [const PostsTab(), const ResourcesTab()],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class PostsTab extends StatelessWidget {
//   const PostsTab({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       padding: const EdgeInsets.all(16),
//       children: [
//         Card(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           clipBehavior: Clip.antiAlias,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Container(
//                 decoration: BoxDecoration(
//                   // border: Border.all(color: primaryColor, width: 2),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 clipBehavior: Clip.hardEdge,
//                 child: Image.asset(
//                   'images/eventimg.png', // your illustration
//                   fit: BoxFit.cover,
//                   width: double.infinity,
//                   height: 203,
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(12),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Author & Title
//                     Row(
//                       children: const [
//                         CircleAvatar(
//                           radius: 16,
//                           backgroundImage: AssetImage('images/eventimg.png'),
//                         ),
//                         SizedBox(width: 8),
//                         Text(
//                           'Suraj',
//                           style: TextStyle(fontWeight: FontWeight.bold),
//                         ),
//                       ],
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       'A Complete Guide for the Data Science Road Map',
//
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(
//                         color: Color(0xff222222),
//                         fontSize: 14,
//                         fontFamily: 'segeo',
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//
//                     // Description
//                     const Text(
//                       'Seen many students struggle to for clear road map for the data science! made it simple and clear simple and clear simple and clear...',
//                       style: TextStyle(
//                         color: Color(0xff222222),
//                         fontSize: 12,
//                         fontFamily: 'segeo',
//                         fontWeight: FontWeight.w400,
//                       ),
//                     ),
//
//                     const SizedBox(height: 12),
//                     // Likes & Comments
//                     Row(
//                       children: const [
//                         Icon(Icons.favorite_border, size: 16),
//                         SizedBox(width: 4),
//                         Text('100'),
//                         SizedBox(width: 16),
//                         Icon(Icons.comment_outlined, size: 16),
//                         SizedBox(width: 4),
//                         Text('100'),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         // Add more cards if needed
//       ],
//     );
//   }
// }
//
// class ResourcesTab extends StatelessWidget {
//   const ResourcesTab({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView(padding: const EdgeInsets.all(16), children: [EventCard()]);
//   }
// }
