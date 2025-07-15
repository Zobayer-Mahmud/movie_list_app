import 'package:flutter/material.dart';

class WatchStatusToggle extends StatelessWidget {
  final bool isWatched;
  final ValueChanged<bool>? onChanged;
  final String? label;
  final WatchStatusStyle style;

  const WatchStatusToggle({
    super.key,
    required this.isWatched,
    this.onChanged,
    this.label,
    this.style = WatchStatusStyle.chip,
  });

  @override
  Widget build(BuildContext context) {
    switch (style) {
      case WatchStatusStyle.chip:
        return _buildChipStyle(context);
      case WatchStatusStyle.button:
        return _buildButtonStyle(context);
      case WatchStatusStyle.switch_:
        return _buildSwitchStyle(context);
      case WatchStatusStyle.checkbox:
        return _buildCheckboxStyle(context);
    }
  }

  Widget _buildChipStyle(BuildContext context) {
    final theme = Theme.of(context);

    return FilterChip(
      label: Text(isWatched ? 'Watched' : 'Not Watched'),
      selected: isWatched,
      onSelected: onChanged,
      avatar: Icon(
        isWatched ? Icons.check_circle : Icons.visibility_off,
        size: 18,
        color: isWatched
            ? theme.colorScheme.onPrimaryContainer
            : theme.colorScheme.onSurfaceVariant,
      ),
      selectedColor: theme.colorScheme.primaryContainer,
      checkmarkColor: theme.colorScheme.onPrimaryContainer,
      backgroundColor: theme.colorScheme.surfaceContainerHighest,
      side: BorderSide(
        color: isWatched
            ? theme.colorScheme.primary
            : theme.colorScheme.outline.withOpacity(0.5),
      ),
    );
  }

  Widget _buildButtonStyle(BuildContext context) {
    final theme = Theme.of(context);

    return OutlinedButton.icon(
      onPressed: onChanged != null ? () => onChanged!(!isWatched) : null,
      icon: Icon(
        isWatched ? Icons.check_circle : Icons.visibility_off,
        size: 18,
      ),
      label: Text(isWatched ? 'Watched' : 'Mark as Watched'),
      style: OutlinedButton.styleFrom(
        foregroundColor: isWatched
            ? theme.colorScheme.primary
            : theme.colorScheme.onSurface,
        side: BorderSide(
          color: isWatched
              ? theme.colorScheme.primary
              : theme.colorScheme.outline,
        ),
      ),
    );
  }

  Widget _buildSwitchStyle(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(label!, style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
        ],
        Row(
          children: [
            Icon(
              isWatched ? Icons.visibility : Icons.visibility_off,
              size: 20,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 8),
            Text(
              isWatched ? 'Watched' : 'Not Watched',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(width: 12),
            Switch(value: isWatched, onChanged: onChanged),
          ],
        ),
      ],
    );
  }

  Widget _buildCheckboxStyle(BuildContext context) {
    final theme = Theme.of(context);

    return CheckboxListTile(
      value: isWatched,
      onChanged: onChanged != null
          ? (value) => onChanged!(value ?? false)
          : null,
      title: Text(
        label ?? (isWatched ? 'Watched' : 'Mark as Watched'),
        style: theme.textTheme.bodyMedium,
      ),
      secondary: Icon(
        isWatched ? Icons.visibility : Icons.visibility_off,
        color: theme.colorScheme.onSurfaceVariant,
      ),
      contentPadding: EdgeInsets.zero,
      dense: true,
    );
  }
}

enum WatchStatusStyle { chip, button, switch_, checkbox }

class CompactWatchStatus extends StatelessWidget {
  final bool isWatched;
  final VoidCallback? onTap;
  final double? size;

  const CompactWatchStatus({
    super.key,
    required this.isWatched,
    this.onTap,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveSize = size ?? 32;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: effectiveSize,
        height: effectiveSize,
        decoration: BoxDecoration(
          color: isWatched
              ? theme.colorScheme.primaryContainer
              : theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(effectiveSize / 2),
          border: Border.all(
            color: isWatched
                ? theme.colorScheme.primary
                : theme.colorScheme.outline.withOpacity(0.5),
            width: 1.5,
          ),
        ),
        child: Icon(
          isWatched ? Icons.check : Icons.visibility_off,
          size: effectiveSize * 0.6,
          color: isWatched
              ? theme.colorScheme.onPrimaryContainer
              : theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class WatchStatusBadge extends StatelessWidget {
  final bool isWatched;
  final bool showText;
  final double? iconSize;

  const WatchStatusBadge({
    super.key,
    required this.isWatched,
    this.showText = true,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (!isWatched) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: showText ? 8 : 4, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.check_circle,
            size: iconSize ?? 14,
            color: theme.colorScheme.onPrimaryContainer,
          ),
          if (showText) ...[
            const SizedBox(width: 4),
            Text(
              'Watched',
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onPrimaryContainer,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
