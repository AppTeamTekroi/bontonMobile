



import 'package:flutter/material.dart';
import 'package:mobile_erp/constants/sized_box_utils.dart';

class OptionsButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Function() onTap;

  const OptionsButton(
      {super.key,
        required this.label,
        required this.onTap,
        required this.icon});

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        height: 40,
        decoration: BoxDecoration(
          // color: Colors.grey.shade300,
          border: Border.all(color: Colors.grey.shade500,),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.blueAccent,
              size: 17,
            ),
            SizedBoxUtils.width3,
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class OptionButtons extends StatelessWidget {
  final String label;
  // final IconData icon;
  final Function() onTap;
  final bool isSelected;

  OptionButtons(
      {super.key,
        required this.label,
        required this.onTap,
        required this.isSelected,
        // required this.icon
      });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: 45,
        decoration: BoxDecoration(
          border: Border.all(color: isSelected ? Colors.blue.shade50 : Colors.grey.shade300,),

        // color: isSelected ? Colors.blue.shade50 : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(20),
        ),

        child: Row(
          children: [
            // Icon(
            //   icon,
            //   color: Colors.blueAccent,
            //   size: 17,
            // ),
            SizedBoxUtils.width3,
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.blue : Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:mobile_erp/constants/sized_box_utils.dart';
//
// import 'color/appColor.dart';
//
// class OptionsButton extends StatelessWidget {
//   final String label;
//   final IconData icon;
//   final Function() onTap;
//
//   const OptionsButton(
//       {super.key,
//       required this.label,
//       required this.onTap,
//       required this.icon});
//
//   @override
//   Widget build(BuildContext context) {
//
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.all(10),
//         height: 40,
//         decoration: BoxDecoration(
//           color: Colors.blueAccent.withOpacity(0.16),
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Row(
//           children: [
//             Icon(
//               icon,
//               color: Colors.blueAccent,
//               size: 17,
//             ),
//             SizedBoxUtils.width3,
//             Text(
//               label,
//               style: const TextStyle(
//                 fontWeight: FontWeight.w600,
//                 fontSize: 12,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
// class OptionButtons extends StatelessWidget {
//   final String label;
//   // final IconData icon;
//   final Function() onTap;
//   Color? color;
//
//    OptionButtons(
//       {super.key,
//         required this.label,
//         required this.onTap,
//         // required this.icon
//         this.color,
//       });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 15),
//         height: 40,
//         decoration: BoxDecoration(
//           // color: Colors.grey.shade300,
//           border: Border.all(color: color ?? Colors.grey.shade500,),
//           borderRadius: BorderRadius.circular(20),
//         ),
//         child: Row(
//           children: [
//             // Icon(
//             //   icon,
//             //   color: Colors.blueAccent,
//             //   size: 17,
//             // ),
//             SizedBoxUtils.width3,
//             Text(
//               label,
//               style: const TextStyle(
//                 // color: AppColors.mainblue,
//                 fontWeight: FontWeight.w600,
//                 fontSize: 12,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
