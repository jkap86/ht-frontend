# Theme Customization Guide

## Quick Start - Change Your Brand Colors

**Want to customize the app's colors? It's super simple!**

### Just edit 3 lines in `app_colors.dart`:

```dart
// Change these 3 colors to match your brand:
static const Color primaryBlue = Color(0xFF1976D2);    // ← Your main brand color
static const Color secondaryTeal = Color(0xFF00796B);  // ← Your accent color
static const Color tertiaryOrange = Color(0xFFFF6F00); // ← Your highlight color
```

**That's it!** All 50+ color variants are automatically generated for both light and dark modes.

---

## How It Works

### 1. Base Colors (`app_colors.dart`)
- Define your 3 main brand colors
- Define semantic colors (success, warning, error, info)
- Define surface colors for light/dark themes

### 2. Auto-Generated Variants (`color_schemes.dart`)
The system automatically creates:
- **Lighter shades** for containers in light mode
- **Darker shades** for text on containers
- **Vibrant versions** for dark mode
- **Proper contrast** for text colors (white or black)

### 3. Color Utilities (`color_utils.dart`)
Helper functions that:
- `lighten()` - Makes colors lighter
- `darken()` - Makes colors darker
- `lightenForDark()` - Creates vibrant versions for dark mode
- `getTextColor()` - Automatically picks white or black for contrast
- `getContrastRatio()` - Checks WCAG accessibility

---

## Color Roles Explained

### Material 3 Color Structure

Each of your 3 brand colors generates 4 variants:

1. **main** - The base color
2. **container** - Lighter background using that color
3. **onMain** - Text color on the main color (auto: white or black)
4. **onContainer** - Text color on the container (auto: darker shade)

### Example: Primary Color

```
primaryBlue (#1976D2) generates:
├── primary: #1976D2 (your color)
├── primaryContainer: #BBDEFB (auto: 40% lighter)
├── onPrimary: #FFFFFF (auto: white for contrast)
└── onPrimaryContainer: #01579B (auto: 40% darker)
```

---

## Customization Examples

### Example 1: Sports Team Colors
```dart
// Green Bay Packers colors
static const Color primaryBlue = Color(0xFF203731);    // Dark green
static const Color secondaryTeal = Color(0xFFFFB612);  // Gold
static const Color tertiaryOrange = Color(0xFFFFFFFF); // White
```

### Example 2: Corporate Branding
```dart
// Tech startup colors
static const Color primaryBlue = Color(0xFF6200EE);    // Purple
static const Color secondaryTeal = Color(0xFF03DAC6);  // Teal
static const Color tertiaryOrange = Color(0xFFCF6679); // Pink
```

### Example 3: Minimalist
```dart
// Black, white, accent
static const Color primaryBlue = Color(0xFF212121);    // Near black
static const Color secondaryTeal = Color(0xFF757575);  // Gray
static const Color tertiaryOrange = Color(0xFF00BCD4); // Cyan accent
```

---

## Advanced Customization

### Adjust Lightness Amount

Edit `color_schemes.dart` to change how light/dark variants are:

```dart
// Make containers more subtle (less light)
primaryContainer: ColorUtils.lighten(AppColors.primaryBlue, 0.2),  // was 0.4

// Make text colors stronger (more dark)
onPrimaryContainer: ColorUtils.darken(AppColors.primaryBlue, 0.5),  // was 0.4
```

### Custom Dark Mode Colors

Want different colors for dark mode? Edit `app_colors.dart`:

```dart
// Add separate dark mode variants
static const Color primaryBlueDark = Color(0xFF90CAF9);  // Custom light blue for dark mode
```

Then use it in `color_schemes.dart`:
```dart
// In dark theme
primary: AppColors.primaryBlueDark,  // Use your custom dark color
```

---

## Testing Your Colors

### Check Contrast Ratios

The system automatically picks text colors with good contrast, but you can verify:

```dart
// In your code or tests
final ratio = ColorUtils.getContrastRatio(
  AppColors.primaryBlue,
  Colors.white,
);
print('Contrast ratio: $ratio'); // Should be >= 4.5 for WCAG AA
```

### Preview in App

1. Change colors in `app_colors.dart`
2. Hot reload the app (press `r` in terminal)
3. See your new colors instantly!
4. Toggle light/dark mode to check both themes

---

## Color Palette Reference

### Current Colors

**Light Mode:**
- Primary: Blue (#1976D2)
- Secondary: Teal (#00796B)
- Tertiary: Orange (#FF6F00)
- Background: Light Gray (#F5F5F5)

**Dark Mode:**
- Primary: Light Blue (auto-generated)
- Secondary: Light Teal (auto-generated)
- Tertiary: Amber (auto-generated)
- Background: Dark Gray (#121212)

---

## Need Help?

- **Color picker**: Use [Material Color Tool](https://material.io/resources/color/)
- **Contrast checker**: Use [WebAIM Contrast Checker](https://webaim.org/resources/contrastchecker/)
- **Color inspiration**: Use [Coolors.co](https://coolors.co/)

**Pro tip**: Start with your primary brand color, then use complementary or analogous colors for secondary and tertiary!
