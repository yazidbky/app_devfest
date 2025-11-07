import 'package:app_devfest/api/plans/plans_api_service.dart';
import 'package:app_devfest/utils/mainColor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InsurancePlanCard extends StatelessWidget {
  final InsurancePlan plan;
  final VoidCallback onPurchase;

  const InsurancePlanCard({
    Key? key,
    required this.plan,
    required this.onPurchase,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Insurance type badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: mainColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              plan.insuranceType.toUpperCase(),
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: mainColor,
              ),
            ),
          ),

          // Plan title
          Text(
            plan.title,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),

          // Features list
          ...plan.description.split('\n').map((feature) {
            if (feature.trim().isEmpty) return const SizedBox();

            bool isPositive = feature.startsWith('✔️');
            bool isNegative = feature.startsWith('❌');

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    isPositive
                        ? Icons.check_circle
                        : isNegative
                            ? Icons.cancel
                            : Icons.circle,
                    size: 16,
                    color: isPositive
                        ? Colors.green
                        : isNegative
                            ? Colors.red
                            : Colors.grey,
                  ),
                  Expanded(
                    child: Text(
                      feature.replaceAll('✔️', '').replaceAll('❌', '').trim(),
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: isNegative ? Colors.red[600] : Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          Spacer(),

          // Price
          Text(
            '${plan.price} DZD',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: mainColor,
            ),
          ),

          // Purchase button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onPurchase,
              style: ElevatedButton.styleFrom(
                backgroundColor: mainColor,
                padding: const EdgeInsets.symmetric(vertical: 5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Purchase Plan',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
