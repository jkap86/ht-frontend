# Shared Components Quick Reference

## Quick Import

```dart
// Import all at once
import 'package:hypetrain_ff/shared/widgets/cards/cards.dart';
import 'package:hypetrain_ff/shared/widgets/chips/chips.dart';
import 'package:hypetrain_ff/shared/widgets/layout/layout.dart';
```

## Common Patterns

### Simple Card
```dart
AppCard(child: Text('Content'))
```

### Card with Title
```dart
SectionCard(
  title: 'Section Name',
  child: Text('Content'),
)
```

### Expandable Card
```dart
ExpandableCard(
  header: Text('Header'),
  child: Text('Content'),
)
```

### Status Badge
```dart
LeagueStatusBadge(status: 'in_season')
// or
StatusBadge(label: 'Active', color: Colors.green, icon: Icons.check)
```

### Info Chips
```dart
InfoChip(icon: Icons.people, label: '12 Teams')
```

### Statistics Display
```dart
InfoColumn(label: 'Managers', value: '10/12')
```

### Label-Value Pairs
```dart
InfoRow(label: 'Season', value: '2024')
```

### Standard Spacing
```dart
SizedBox(height: AppSpacing.md)  // 12px
SizedBox(height: AppSpacing.xl)  // 20px
```

### Standard Padding
```dart
ContentPadding(child: Widget())
ContentPadding.compact(child: Widget())
```

## Component Tree

```
shared/widgets/
├── cards/
│   ├── AppCard              → Base card wrapper
│   ├── SectionCard          → Card with title
│   ├── ExpandableCard       → Collapsible card
│   └── ExpandableSection    → Collapsible section
├── chips/
│   ├── StatusBadge          → Generic status badge
│   ├── LeagueStatusBadge    → League-specific badge
│   ├── PaymentStatusBadge   → Payment status badge
│   ├── InfoChip             → Icon + label chip
│   ├── CompactInfoChip      → Smaller chip
│   ├── InfoRow              → Label/value row
│   └── InfoColumn           → Label/value column
└── layout/
    ├── SectionHeader        → Section title
    ├── SubsectionHeader     → Subsection title
    ├── ContentPadding       → Standard padding
    └── AppSpacing           → Spacing constants
```

## When to Use What

| Need | Use |
|------|-----|
| Simple container | `AppCard` |
| Container with title | `SectionCard` |
| Collapsible container | `ExpandableCard` |
| Status indicator | `LeagueStatusBadge` or `StatusBadge` |
| Metadata display | `InfoChip` |
| Statistics | `InfoColumn` |
| Settings display | `InfoRow` |
| Section title | `SectionHeader` |
| Consistent spacing | `AppSpacing.xl`, `AppSpacing.md`, etc. |
| Consistent padding | `ContentPadding` |

## Migration Checklist

- [ ] Replace `Card` + `Padding(all: 20)` with `AppCard`
- [ ] Replace card with title pattern with `SectionCard`
- [ ] Replace manual expandable sections with `ExpandableCard`/`ExpandableSection`
- [ ] Replace custom status chips with `StatusBadge` variants
- [ ] Replace icon+label patterns with `InfoChip`
- [ ] Replace label/value pairs with `InfoRow` or `InfoColumn`
- [ ] Use `AppSpacing` constants instead of hardcoded values
- [ ] Add imports from barrel files (`cards.dart`, `chips.dart`, `layout.dart`)
