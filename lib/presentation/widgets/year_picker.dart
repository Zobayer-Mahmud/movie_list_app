import 'package:flutter/material.dart';

class YearPicker extends StatelessWidget {
  final int? selectedYear;
  final ValueChanged<int?>? onYearChanged;
  final String? label;
  final String? hintText;

  const YearPicker({
    super.key,
    this.selectedYear,
    this.onYearChanged,
    this.label,
    this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentYear = DateTime.now().year;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(label!, style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
        ],
        InkWell(
          onTap: () => _showYearPickerDialog(context, currentYear),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(
                color: theme.colorScheme.outline.withOpacity(0.5),
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 20,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    selectedYear?.toString() ?? hintText ?? 'Select year',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: selectedYear != null
                          ? theme.colorScheme.onSurface
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                if (selectedYear != null) ...[
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => onYearChanged?.call(null),
                    child: Icon(
                      Icons.clear,
                      size: 18,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showYearPickerDialog(BuildContext context, int currentYear) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return YearPickerDialog(
          selectedYear: selectedYear,
          currentYear: currentYear,
          onYearSelected: (year) {
            onYearChanged?.call(year);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}

class YearPickerDialog extends StatefulWidget {
  final int? selectedYear;
  final int currentYear;
  final ValueChanged<int> onYearSelected;

  const YearPickerDialog({
    super.key,
    required this.selectedYear,
    required this.currentYear,
    required this.onYearSelected,
  });

  @override
  State<YearPickerDialog> createState() => _YearPickerDialogState();
}

class _YearPickerDialogState extends State<YearPickerDialog> {
  late final ScrollController _scrollController;
  static const int startYear = 1900;
  late final int endYear;

  @override
  void initState() {
    super.initState();
    endYear = widget.currentYear + 5; // Allow future releases
    _scrollController = ScrollController();

    // Scroll to selected year or current year
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final targetYear = widget.selectedYear ?? widget.currentYear;
      final index = endYear - targetYear;
      final offset = index * 56.0; // Approximate height of each item

      if (_scrollController.hasClients && offset > 0) {
        _scrollController.animateTo(
          offset,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final years = List.generate(
      endYear - startYear + 1,
      (index) => endYear - index,
    );

    return AlertDialog(
      title: const Text('Select Release Year'),
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      content: SizedBox(
        width: double.minPositive,
        height: 300,
        child: ListView.builder(
          controller: _scrollController,
          itemCount: years.length,
          itemBuilder: (context, index) {
            final year = years[index];
            final isSelected = year == widget.selectedYear;
            final isCurrent = year == widget.currentYear;

            return ListTile(
              dense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              title: Text(
                year.toString(),
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: isSelected
                      ? FontWeight.bold
                      : isCurrent
                      ? FontWeight.w600
                      : FontWeight.normal,
                  color: isSelected
                      ? theme.colorScheme.primary
                      : isCurrent
                      ? theme.colorScheme.secondary
                      : theme.colorScheme.onSurface,
                ),
              ),
              selected: isSelected,
              selectedTileColor: theme.colorScheme.primaryContainer.withOpacity(
                0.3,
              ),
              onTap: () => widget.onYearSelected(year),
              trailing: isSelected
                  ? Icon(
                      Icons.check,
                      color: theme.colorScheme.primary,
                      size: 20,
                    )
                  : isCurrent
                  ? Icon(
                      Icons.today,
                      color: theme.colorScheme.secondary,
                      size: 18,
                    )
                  : null,
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}

class CompactYearPicker extends StatelessWidget {
  final int? selectedYear;
  final ValueChanged<int?>? onYearChanged;
  final double? width;

  const CompactYearPicker({
    super.key,
    this.selectedYear,
    this.onYearChanged,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: width ?? 100,
      child: InkWell(
        onTap: () => _showYearPickerDialog(context),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Text(
                  selectedYear?.toString() ?? 'Year',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: selectedYear != null
                        ? theme.colorScheme.onSurface
                        : theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.arrow_drop_down,
                size: 16,
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showYearPickerDialog(BuildContext context) {
    final currentYear = DateTime.now().year;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return YearPickerDialog(
          selectedYear: selectedYear,
          currentYear: currentYear,
          onYearSelected: (year) {
            onYearChanged?.call(year);
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}
