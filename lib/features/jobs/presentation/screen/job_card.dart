import 'package:flutter/material.dart';
import 'package:linkedin/core/theme/app_colors.dart';

class JobCard extends StatefulWidget {
  final String title;
  final String company;
  final String? jobType;
  final double? salary;
  final IconData icon;
  final VoidCallback onTap;
  final Widget? trailing;

  const JobCard({
    super.key,
    required this.title,
    required this.company,
    required this.icon,
    required this.onTap,
    this.jobType,
    this.salary,
    this.trailing,
  });

  @override
  State<JobCard> createState() => _JobCardState();
}

class _JobCardState extends State<JobCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
   
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00B894).withOpacity(isHovered ? 0.2 : 0.1),
              blurRadius: isHovered ? 10 : 5,
              spreadRadius: isHovered ? 2 : 1,
              offset: const Offset(0, 0),
            ),
          ],
        ),
        child: Card(
          color: AppColors.background,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: widget.onTap,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.tealLight.withOpacity(0.3),
                    child: Icon(widget.icon, color: AppColors.tealDark, size: 30),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.tealDark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.company,
                          style: const TextStyle(color: Colors.black54),
                        ),
                        const SizedBox(height: 4),
                        if (widget.jobType != null || widget.salary != null)
                          Row(
                            children: [
                              if (widget.jobType != null)
                                Text(
                                  widget.jobType!,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              if (widget.jobType != null && widget.salary != null)
                                const SizedBox(width: 10),
                              if (widget.salary != null)
                                Text(
                                  '\$${widget.salary!.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  widget.trailing ?? const Icon(Icons.arrow_forward_ios, color: AppColors.tealDark),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
