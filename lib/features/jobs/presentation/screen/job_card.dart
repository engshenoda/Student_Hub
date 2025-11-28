import 'package:flutter/material.dart';
import 'package:linkedin/core/theme/app_colors.dart';

class JobCard extends StatefulWidget {
  final String title;
  final String company;
  final String? jobType;
  final double? salary;
  final String? location;
  final int? applicants;
  final String? description;
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
    this.location,
    this.applicants,
    this.description,
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
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
                    child: Icon(
                      widget.icon,
                      color: AppColors.tealDark,
                      size: 30,
                    ),
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
                        const SizedBox(height: 6),
                        Text(
                          widget.company,
                          style: const TextStyle(color: Colors.black54),
                        ),
                        const SizedBox(height: 8),

                        if (widget.description != null &&
                            widget.description!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              widget.description!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Colors.black87,
                                height: 1.2,
                              ),
                            ),
                          ),

                        // small info row
                        Row(
                          children: [
                            if (widget.jobType != null)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 6,
                                ),
                                margin: const EdgeInsets.only(right: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Text(
                                  widget.jobType!,
                                  style: const TextStyle(color: Colors.black87),
                                ),
                              ),
                            if (widget.location != null)
                              if (widget.applicants != null)
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.group,
                                        size: 14,
                                        color: AppColors.tealDark,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        '${widget.applicants}',
                                        style: const TextStyle(
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Constrain trailing widget so it cannot push content and cause overflow
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: 32,
                      maxWidth: 56,
                    ),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child:
                          widget.trailing ??
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: AppColors.tealDark,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
