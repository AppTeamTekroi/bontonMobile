import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_erp/features/orders/controller/OrderListController.dart';
import 'package:mobile_erp/ui/Buttons/buttonBS.dart';
import 'package:mobile_erp/ui/color/appColor.dart';
class CustomerCard extends StatelessWidget {
  final String companyName;
  final String id;

  final String Name;
  final int credit;
  final String number;
  final int orderCount;
  final String totalAmount;
  final VoidCallback onPressed;
  final VoidCallback onLongPressed;

  const CustomerCard({
    super.key,
    required this.companyName,
    required this.Name,
   required this.credit,
    required this.number,
    required this.orderCount,
    required this.totalAmount,
    required this.onPressed,
    required this.onLongPressed,
    required this.id,
  });

  String getDp(String inputString) {
    if (inputString.isEmpty) return 'NA';
    List<String> words = inputString.split(' ');
    if (words.length > 1 && words[1].isNotEmpty) {
      return words[0][0] + words[1][0];
    } else {
      return words[0][0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.black.withOpacity(0.2),
      onTap: onPressed,
      onLongPress: onLongPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 0.6, color: Color.fromARGB(255, 213, 213, 213)),
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: const Color.fromARGB(255, 211, 211, 211),
              radius: 22,
              child: Text(
                getDp(companyName),
                style: const TextStyle(
                  color: AppColors.main,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment : MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        // width : 40,
                        child: Text(
                          Name,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,

                          ),
                        ),
                      ),

                      if(credit == 1)
                      Text(
                        'Credit',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  // Text(
                  //   "CardCode : $cardCode",
                  //   style: const TextStyle(
                  //     fontSize: 12,
                  //     color: Colors.black,
                  //     fontWeight: FontWeight.w500,
                  //   ),
                  // ),
                  Text(
                    "Company : $companyName",
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        number,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color.fromARGB(255, 68, 68, 68),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      if (orderCount != 0)
                        Text(
                          "Orders $orderCount",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.normal,
                            color: Colors.black38,
                          ),
                        ),
                    ],
                  ),
//OpenOrdersBalance
                //CurrentAccountBalance
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Last Invoice: $totalAmount'),

                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}




// import 'dart:math';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:mobile_erp/features/orders/controller/OrderListController.dart';
// import 'package:mobile_erp/ui/Buttons/buttonBS.dart';
// import 'package:mobile_erp/ui/color/appColor.dart';
//
// class CustomerCard extends StatelessWidget {
//   final String companyName;
//   final String number;
//   final int orderCount;
//   final String totalAmount;
//
//   final VoidCallback onPressed;
//   final VoidCallback onLongPressed;
//
//   const CustomerCard({
//     super.key,
//     required this.companyName,
//     required this.number,
//     required this.orderCount,
//     required this.totalAmount,
//
//     required this.onPressed,
//     required this.onLongPressed,
//   });
//   String getDp(String inputString) {
//     // Split the input string by spaces
//     if (inputString == '') {
//       return 'NA';
//     }
//     List<String> words = inputString!.split(' ');
//
//     // Check if there is at least one word with more than one character
//     if (words.length > 1 && words[1].isNotEmpty) {
//       // Get the first character of the second word (first letter after a space)
//       String firstLetterAfterSpace = words[1][0];
//       return words[0][0] + firstLetterAfterSpace;
//     } else {
//       return words[0][0];
//       print("No space or word after space found");
//     }
//   }
//
//   @override
//   Future<Widget> build(BuildContext context) async {
//     // final Random random = Random();
//     // print('comapany name = ${companyName}');
//     return InkWell(
//       splashColor: Colors.black.withOpacity(0.2),
//       onTap: onPressed,
//       onLongPress: onLongPressed,
//       child: Container(
//         child: Column(
//           children: [
//             Container(
//               decoration: const BoxDecoration(
//                 border: Border(
//                   bottom: BorderSide(
//                     width: 0.6,
//                     color: Color.fromARGB(255, 213, 213, 213),
//                   ),
//                 ),
//               ),
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//               child: Row(
//                 children: [
//                   Padding(
//                     padding: EdgeInsets.all(4.0),
//                     child: CircleAvatar(
//                         backgroundColor: Color.fromARGB(255, 211, 211, 211),
//                         radius: 22,
//                         child: Text(
//                           // companyName==null?'N':
//                           getDp(companyName),
//
//                           style: TextStyle(
//                               color: AppColors.main,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16),
//                         )),
//                   ),
//                   const SizedBox(
//                     width: 10,
//                   ),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//
//                           children: [
//                             Text(
//                               companyName ?? 'No Name',
//                               // '',
//                               style: const TextStyle(
//                                   fontSize: 14,
//                                   color: Colors.black,
//                                   fontWeight: FontWeight.w500),
//                             ),
//                             Spacer(),
//                             if(orderCount != 0)
//                               Text(
//                                 "🛒 - $orderCount",
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.grey.shade400,
//                                 ),
//                               ),
//                           ],
//                         ),
//                         Text(
//                           number,
//                           style: const TextStyle(
//                               fontSize: 12,
//                               color: Color.fromARGB(255, 68, 68, 68),
//                               fontWeight: FontWeight.bold),
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text('Last Invoice :$totalAmount'),
//                             ButtonBS(title:'Place Order',onPressed: ()=> Get.to(()=>OrderPlacedController()), )
//                           ],
//                         )
//
//                       ],
//                     ),
//                   ),
//
//                   // Text(
//                   //   "Orders - $orderCount",
//                   //   style: TextStyle(
//                   //     fontSize: 14,
//                   //     fontWeight: FontWeight.bold,
//                   //     color: Colors.grey.shade400,
//                   //   ),
//                   // ),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
