# Shared UI Components

This directory contains reusable UI components extracted from the HypeTrainFF Flutter frontend codebase to ensure consistency and reduce code duplication.

## Directory Structure

```
shared/widgets/
├── cards/           # Card wrapper components
├── chips/           # Badge and chip components
└── layout/          # Layout and spacing components
```

## Components

### Cards (`cards/`)

Standardized card components for consistent container styling.

#### `AppCard`
Base card wrapper with consistent padding and elevation.

```dart
import 'package:hypetrain_ff/shared/widgets/cards/app_card.dart';

AppCard(
  child: Text('Content'),
  padding: EdgeInsets.all(20), // optional, defaults to 20px
  elevation: 2, // optional
)
```

#### `SectionCard`
Card with a title header and content section.

```dart
import 'package:hypetrain_ff/shared/widgets/cards/section_card.dart';

SectionCard(
  title: 'Draft',
  child: Text('Draft information'),
  action: IconButton(...), // optional action widget
)
```

#### `ExpandableCard`
Collapsible card with an expandable header.

```dart
import 'package:hypetrain_ff/shared/widgets/cards/expandable_card.dart';

ExpandableCard(
  header: Text('Click to expand'),
  child: Text('Expanded content'),
  initiallyExpanded: false,
  onToggle: (expanded) => print('Toggled: $expanded'),
)
```

#### `ExpandableSection`
Section within a card with collapsible content.

```dart
ExpandableSection(
  title: 'Draft Order',
  badge: Chip(label: Text('Derby')),
  isExpanded: true,
  onToggle: () => toggleSection(),
  child: Text('Section content'),
)
```

### Chips (`chips/`)

Badge and chip components for displaying status and metadata.

#### `StatusBadge`
Colored badge for displaying status information.

```dart
import 'package:hypetrain_ff/shared/widgets/chips/status_badge.dart';

StatusBadge(
  label: 'In Season',
  color: Colors.green,
  icon: Icons.play_circle,
)
```

#### `LeagueStatusBadge`
Pre-configured status badge for league statuses.

```dart
LeagueStatusBadge(
  status: 'in_season', // pre_draft, drafting, in_season, complete
)
```

#### `PaymentStatusBadge`
Pre-configured badge for payment status.

```dart
PaymentStatusBadge(
  isPaid: true,
)
```

#### `InfoChip`
Chip for displaying metadata with icon and label.

```dart
import 'package:hypetrain_ff/shared/widgets/chips/info_chip.dart';

InfoChip(
  icon: Icons.people,
  label: '12 Teams',
)
```

#### `CompactInfoChip`
Smaller, more compact version of InfoChip.

```dart
CompactInfoChip(
  icon: Icons.calendar_today,
  label: '2024',
)
```

#### `InfoRow`
Row displaying a label and value pair.

```dart
import 'package:hypetrain_ff/shared/widgets/chips/info_row.dart';

InfoRow(
  label: 'Season',
  value: '2024',
)
```

#### `InfoColumn`
Column displaying a label above a value (for statistics).

```dart
InfoColumn(
  label: 'Managers',
  value: '10/12',
)
```

### Layout (`layout/`)

Components for consistent spacing and section headers.

#### `SectionHeader`
Consistent header for sections.

```dart
import 'package:hypetrain_ff/shared/widgets/layout/section_header.dart';

SectionHeader(
  title: 'Settings',
  action: IconButton(icon: Icon(Icons.edit), onPressed: () {}),
)
```

#### `SubsectionHeader`
Lighter weight header for subsections.

```dart
SubsectionHeader(
  title: 'Draft Order',
)
```

#### `ContentPadding`
Standard padding wrapper with predefined values.

```dart
import 'package:hypetrain_ff/shared/widgets/layout/content_padding.dart';

// Standard padding (20px all around)
ContentPadding(
  child: Text('Content'),
)

// Or use named constructors
ContentPadding.compact(child: Text('Content'))  // 16px
ContentPadding.small(child: Text('Content'))    // 12px
ContentPadding.horizontal(child: Text('Content')) // 20px horizontal
ContentPadding.vertical(child: Text('Content'))   // 20px vertical
```

#### `AppSpacing`
Standard spacing constants.

```dart
import 'package:hypetrain_ff/shared/widgets/layout/content_padding.dart';

SizedBox(height: AppSpacing.xs)   // 4px
SizedBox(height: AppSpacing.sm)   // 8px
SizedBox(height: AppSpacing.md)   // 12px
SizedBox(height: AppSpacing.lg)   // 16px
SizedBox(height: AppSpacing.xl)   // 20px
SizedBox(height: AppSpacing.xxl)  // 24px
SizedBox(height: AppSpacing.xxxl) // 32px
```

## Barrel Files

For convenience, you can import all components from a category using barrel files:

```dart
// Import all card components
import 'package:hypetrain_ff/shared/widgets/cards/cards.dart';

// Import all chip components
import 'package:hypetrain_ff/shared/widgets/chips/chips.dart';

// Import all layout components
import 'package:hypetrain_ff/shared/widgets/layout/layout.dart';
```

## Migration Examples

### Before: LeagueHeaderCard

```dart
return Card(
  child: Padding(
    padding: const EdgeInsets.all(20),
    child: Column(
      children: [
        Chip(
          avatar: Icon(Icons.schedule),
          label: Text('Pre-Draft'),
          backgroundColor: Colors.blue,
        ),
      ],
    ),
  ),
);
```

### After: LeagueHeaderCard

```dart
return AppCard(
  child: Wrap(
    spacing: 8,
    children: [
      LeagueStatusBadge(status: 'pre_draft'),
      InfoChip(icon: Icons.people, label: '12 Teams'),
    ],
  ),
);
```

### Before: DuesOverviewCard

```dart
return Card(
  child: Padding(
    padding: const EdgeInsets.all(20),
    child: Column(
      children: [
        Text('Dues', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 16),
        // content
      ],
    ),
  ),
);
```

### After: DuesOverviewCard

```dart
return SectionCard(
  title: 'Dues',
  child: // content
);
```

## Design Guidelines

1. **Consistency**: Always use shared components instead of creating one-off cards or chips
2. **Theming**: Components use `Theme.of(context)` for colors and spacing when possible
3. **Reusability**: Keep components generic and parameterized for different use cases
4. **Documentation**: All components include doc comments with usage examples
5. **Accessibility**: Use semantic widgets and provide proper labels

## Contributing

When adding new shared components:

1. Place them in the appropriate directory (`cards/`, `chips/`, or `layout/`)
2. Add comprehensive doc comments with examples
3. Export them from the appropriate barrel file
4. Update this README with usage examples
5. Look for opportunities to refactor existing code to use the new component
