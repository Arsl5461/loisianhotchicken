import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import '../../utils/media_query.dart';

import 'package:OApp/core/constants/app_colors.dart';

/// An expandable prompt widget that grows with text content
class ExpandablePromptWidget extends StatefulWidget {
  /// The title/placeholder text for the prompt
  final String title;

  /// The current answer text
  final String answer;

  /// Callback when the answer text changes
  final ValueChanged<String>? onAnswerChanged;

  /// Callback when the plus icon is tapped
  final VoidCallback? onPlusTap;

  /// Whether this prompt is expanded/active
  final bool isExpanded;

  /// Callback when the prompt is tapped to expand/collapse
  final VoidCallback? onTap;

  const ExpandablePromptWidget({
    super.key,
    required this.title,
    this.answer = '',
    this.onAnswerChanged,
    this.onPlusTap,
    this.isExpanded = false,
    this.onTap,
  });

  @override
  _ExpandablePromptWidgetState createState() => _ExpandablePromptWidgetState();
}

class _ExpandablePromptWidgetState extends State<ExpandablePromptWidget> {
  late TextEditingController _answerController;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _answerController = TextEditingController(text: widget.answer);
    _focusNode = FocusNode();
  }

  @override
  void didUpdateWidget(ExpandablePromptWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.answer != widget.answer) {
      _answerController.text = widget.answer;
    }
  }

  @override
  void dispose() {
    _answerController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryUtil.init(context);

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(MediaQueryUtil.spacing(16)),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(MediaQueryUtil.spacing(12)),
          border: Border.all(color: AppColors.grey[300]!, width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        widget.title,
                        style: TextStyle(
                          fontSize: MediaQueryUtil.fontSize(16),
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),

                      // Answer field (only show if expanded)
                      if (widget.isExpanded) ...[
                        SizedBox(height: MediaQueryUtil.spacing(8)),
                        TextField(
                          controller: _answerController,
                          focusNode: _focusNode,
                          onChanged: widget.onAnswerChanged,
                          maxLines: null,
                          style: TextStyle(
                            fontSize: MediaQueryUtil.fontSize(14),
                            color: AppColors.black,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Answer goes here',
                            hintStyle: TextStyle(
                              fontSize: MediaQueryUtil.fontSize(14),
                              color: AppColors.grey[500],
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                SizedBox(width: MediaQueryUtil.spacing(8)),

                // Plus icon
                GestureDetector(
                  onTap: widget.onPlusTap,
                  child: Container(
                    width: MediaQueryUtil.spacing(32),
                    height: MediaQueryUtil.spacing(32),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.black, width: 1),
                    ),
                    child: Icon(
                      LucideIcons.plus,
                      size: MediaQueryUtil.spacing(16),
                      color: AppColors.black,
                      weight: 5.0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
