import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_enums.dart';
import '../controllers/search_controller.dart' as search_controller;

class FilterChips extends StatelessWidget {
  const FilterChips({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<search_controller.SearchController>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter Options
          Row(
            children: [
              Text(
                'Filter:',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: FilterOption.values.map((option) {
                      return Obx(() {
                        final isSelected =
                            controller.selectedFilter.value == option;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            child: FilterChip(
                              label: Text(option.displayName),
                              selected: isSelected,
                              onSelected: (_) =>
                                  controller.updateFilterOption(option),
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.surface,
                              selectedColor: Theme.of(
                                context,
                              ).colorScheme.primaryContainer,
                              checkmarkColor: Theme.of(
                                context,
                              ).colorScheme.onPrimaryContainer,
                              labelStyle: TextStyle(
                                color: isSelected
                                    ? Theme.of(
                                        context,
                                      ).colorScheme.onPrimaryContainer
                                    : Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ),
                        );
                      });
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Sort Options
          Row(
            children: [
              Text(
                'Sort:',
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: SortOption.values.map((option) {
                      return Obx(() {
                        final isSelected =
                            controller.selectedSort.value == option;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            child: FilterChip(
                              label: Text(option.displayName),
                              selected: isSelected,
                              onSelected: (_) =>
                                  controller.updateSortOption(option),
                              backgroundColor: Theme.of(
                                context,
                              ).colorScheme.surface,
                              selectedColor: Theme.of(
                                context,
                              ).colorScheme.secondaryContainer,
                              checkmarkColor: Theme.of(
                                context,
                              ).colorScheme.onSecondaryContainer,
                              labelStyle: TextStyle(
                                color: isSelected
                                    ? Theme.of(
                                        context,
                                      ).colorScheme.onSecondaryContainer
                                    : Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                          ),
                        );
                      });
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),

          // Reset Button
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: controller.resetFilters,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Reset Filters'),
            ),
          ),
        ],
      ),
    );
  }
}
