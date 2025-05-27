# SpotlightOS Design System

## Table of Contents
1. [Design Principles](#design-principles)
2. [Brand Identity](#brand-identity)
3. [Color System](#color-system)
4. [Typography](#typography)
5. [Layout & Grid System](#layout--grid-system)
6. [Component Library](#component-library)
7. [Interactive States](#interactive-states)
8. [Motion & Animation](#motion--animation)
9. [Accessibility Guidelines](#accessibility-guidelines)
10. [Responsive Design](#responsive-design)
11. [Implementation Guidelines](#implementation-guidelines)
12. [Maintenance & Updates](#maintenance--updates)

## Design Principles

### Core Values
- **Clarity**: Clear, intuitive interfaces that reduce cognitive load
- **Consistency**: Unified experience across all touchpoints
- **Performance**: Fast, responsive interactions
- **Accessibility**: Inclusive design for all users
- **Scalability**: Components that grow with the platform

### Design Philosophy
SpotlightOS embraces a modern, professional aesthetic that balances sophistication with approachability. Our design language emphasizes:

- **Purposeful Simplicity**: Every element serves a function
- **Data-Driven Beauty**: Making complex data comprehensible and actionable
- **Human-Centered**: Technology that feels natural and intuitive
- **AI-Enhanced UX**: Intelligent interfaces that anticipate user needs

## Brand Identity

### Logo Usage
- Minimum size: 32px height for digital, 0.5 inches for print
- Clear space: Minimum 2x the height of the logo
- Use on white, dark, or brand-appropriate backgrounds only

### Voice & Tone
- **Professional yet approachable**
- **Confident but not arrogant**
- **Technical accuracy with human empathy**
- **Clear, concise communication**

## Color System

### Primary Colors
```css
:root {
  /* Primary Brand Colors */
  --color-primary-50: #EFF6FF;
  --color-primary-100: #DBEAFE;
  --color-primary-200: #BFDBFE;
  --color-primary-300: #93C5FD;
  --color-primary-400: #60A5FA;
  --color-primary-500: #3B82F6;
  --color-primary-600: #2563EB;  /* Primary Brand */
  --color-primary-700: #1D4ED8;
  --color-primary-800: #1E40AF;
  --color-primary-900: #1E3A8A;
  --color-primary-950: #172554;
}
```

### Secondary Colors
```css
:root {
  /* Secondary Purple */
  --color-secondary-50: #FAF5FF;
  --color-secondary-100: #F3E8FF;
  --color-secondary-200: #E9D5FF;
  --color-secondary-300: #D8B4FE;
  --color-secondary-400: #C084FC;
  --color-secondary-500: #A855F7;
  --color-secondary-600: #9333EA;
  --color-secondary-700: #7C3AED;  /* Secondary Brand */
  --color-secondary-800: #6B21A8;
  --color-secondary-900: #581C87;
  --color-secondary-950: #3B0764;
}
```

### Semantic Colors
```css
:root {
  /* Success */
  --color-success-50: #ECFDF5;
  --color-success-500: #10B981;
  --color-success-600: #059669;
  --color-success-700: #047857;
  
  /* Warning */
  --color-warning-50: #FFFBEB;
  --color-warning-500: #F59E0B;
  --color-warning-600: #D97706;
  --color-warning-700: #B45309;
  
  /* Error */
  --color-error-50: #FEF2F2;
  --color-error-500: #EF4444;
  --color-error-600: #DC2626;
  --color-error-700: #B91C1C;
  
  /* Info */
  --color-info-50: #EFF6FF;
  --color-info-500: #3B82F6;
  --color-info-600: #2563EB;
  --color-info-700: #1D4ED8;
}
```

### Neutral Palette
```css
:root {
  /* Neutral Grays */
  --color-neutral-0: #FFFFFF;
  --color-neutral-50: #F9FAFB;
  --color-neutral-100: #F3F4F6;
  --color-neutral-200: #E5E7EB;
  --color-neutral-300: #D1D5DB;
  --color-neutral-400: #9CA3AF;
  --color-neutral-500: #6B7280;
  --color-neutral-600: #4B5563;
  --color-neutral-700: #374151;
  --color-neutral-800: #1F2937;
  --color-neutral-900: #111827;
  --color-neutral-950: #030712;
}
```

### Color Usage Guidelines
- **Primary**: Main CTAs, navigation, key interactive elements
- **Secondary**: Supporting actions, highlights, creative elements
- **Neutral**: Text, backgrounds, borders, subtle UI elements
- **Semantic**: Status indicators, alerts, feedback messages

## Typography

### Font Families
```css
:root {
  --font-primary: 'Inter', system-ui, -apple-system, sans-serif;
  --font-mono: 'JetBrains Mono', 'Fira Code', monospace;
  --font-display: 'Inter', system-ui, -apple-system, sans-serif;
}
```

### Type Scale
```css
:root {
  /* Font Sizes */
  --text-xs: 0.75rem;     /* 12px */
  --text-sm: 0.875rem;    /* 14px */
  --text-base: 1rem;      /* 16px */
  --text-lg: 1.125rem;    /* 18px */
  --text-xl: 1.25rem;     /* 20px */
  --text-2xl: 1.5rem;     /* 24px */
  --text-3xl: 1.875rem;   /* 30px */
  --text-4xl: 2.25rem;    /* 36px */
  --text-5xl: 3rem;       /* 48px */
  --text-6xl: 3.75rem;    /* 60px */
  
  /* Line Heights */
  --leading-tight: 1.25;
  --leading-normal: 1.5;
  --leading-relaxed: 1.625;
  
  /* Font Weights */
  --font-light: 300;
  --font-regular: 400;
  --font-medium: 500;
  --font-semibold: 600;
  --font-bold: 700;
}
```

### Typography Classes
```css
.text-display-large {
  font-family: var(--font-display);
  font-size: var(--text-6xl);
  font-weight: var(--font-bold);
  line-height: var(--leading-tight);
  letter-spacing: -0.025em;
}

.text-display-medium {
  font-family: var(--font-display);
  font-size: var(--text-5xl);
  font-weight: var(--font-bold);
  line-height: var(--leading-tight);
  letter-spacing: -0.025em;
}

.text-heading-1 {
  font-family: var(--font-primary);
  font-size: var(--text-4xl);
  font-weight: var(--font-bold);
  line-height: var(--leading-tight);
}

.text-heading-2 {
  font-family: var(--font-primary);
  font-size: var(--text-3xl);
  font-weight: var(--font-semibold);
  line-height: var(--leading-tight);
}

.text-body-large {
  font-family: var(--font-primary);
  font-size: var(--text-lg);
  font-weight: var(--font-regular);
  line-height: var(--leading-relaxed);
}

.text-body {
  font-family: var(--font-primary);
  font-size: var(--text-base);
  font-weight: var(--font-regular);
  line-height: var(--leading-normal);
}

.text-body-small {
  font-family: var(--font-primary);
  font-size: var(--text-sm);
  font-weight: var(--font-regular);
  line-height: var(--leading-normal);
}

.text-caption {
  font-family: var(--font-primary);
  font-size: var(--text-xs);
  font-weight: var(--font-medium);
  line-height: var(--leading-normal);
  text-transform: uppercase;
  letter-spacing: 0.05em;
}
```

## Layout & Grid System

### Container System
```css
.container {
  width: 100%;
  margin: 0 auto;
  padding: 0 1rem;
}

.container-sm { max-width: 640px; }
.container-md { max-width: 768px; }
.container-lg { max-width: 1024px; }
.container-xl { max-width: 1280px; }
.container-2xl { max-width: 1536px; }

@media (min-width: 640px) {
  .container { padding: 0 1.5rem; }
}

@media (min-width: 1024px) {
  .container { padding: 0 2rem; }
}
```

### Grid System
```css
.grid {
  display: grid;
  gap: 1rem;
}

.grid-cols-1 { grid-template-columns: repeat(1, minmax(0, 1fr)); }
.grid-cols-2 { grid-template-columns: repeat(2, minmax(0, 1fr)); }
.grid-cols-3 { grid-template-columns: repeat(3, minmax(0, 1fr)); }
.grid-cols-4 { grid-template-columns: repeat(4, minmax(0, 1fr)); }
.grid-cols-6 { grid-template-columns: repeat(6, minmax(0, 1fr)); }
.grid-cols-12 { grid-template-columns: repeat(12, minmax(0, 1fr)); }

/* Responsive Grid */
@media (min-width: 640px) {
  .sm\:grid-cols-2 { grid-template-columns: repeat(2, minmax(0, 1fr)); }
  .sm\:grid-cols-3 { grid-template-columns: repeat(3, minmax(0, 1fr)); }
}

@media (min-width: 768px) {
  .md\:grid-cols-3 { grid-template-columns: repeat(3, minmax(0, 1fr)); }
  .md\:grid-cols-4 { grid-template-columns: repeat(4, minmax(0, 1fr)); }
}

@media (min-width: 1024px) {
  .lg\:grid-cols-4 { grid-template-columns: repeat(4, minmax(0, 1fr)); }
  .lg\:grid-cols-6 { grid-template-columns: repeat(6, minmax(0, 1fr)); }
}
```

### Layout Patterns
```
┌─────────────────────────────────────────────────────────────┐
│                        Header (Fixed)                       │
├─────────────────────────────────────────────────────────────┤
│ Sidebar │                Main Content Area                  │
│  (240px)│                                                   │
│         │  ┌─────────────────────────────────────────────┐  │
│         │  │              Content Cards              │  │
│         │  └─────────────────────────────────────────────┘  │
│         │                                                   │
└─────────┴───────────────────────────────────────────────────┘
```

### Spacing System
```css
:root {
  --space-0: 0;
  --space-px: 1px;
  --space-0-5: 0.125rem;  /* 2px */
  --space-1: 0.25rem;     /* 4px */
  --space-1-5: 0.375rem;  /* 6px */
  --space-2: 0.5rem;      /* 8px */
  --space-2-5: 0.625rem;  /* 10px */
  --space-3: 0.75rem;     /* 12px */
  --space-3-5: 0.875rem;  /* 14px */
  --space-4: 1rem;        /* 16px */
  --space-5: 1.25rem;     /* 20px */
  --space-6: 1.5rem;      /* 24px */
  --space-7: 1.75rem;     /* 28px */
  --space-8: 2rem;        /* 32px */
  --space-9: 2.25rem;     /* 36px */
  --space-10: 2.5rem;     /* 40px */
  --space-12: 3rem;       /* 48px */
  --space-14: 3.5rem;     /* 56px */
  --space-16: 4rem;       /* 64px */
  --space-20: 5rem;       /* 80px */
  --space-24: 6rem;       /* 96px */
  --space-28: 7rem;       /* 112px */
  --space-32: 8rem;       /* 128px */
}
```

## Component Library

### Buttons
```css
/* Base Button */
.btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: var(--space-2) var(--space-4);
  border-radius: 0.375rem;
  font-family: var(--font-primary);
  font-size: var(--text-sm);
  font-weight: var(--font-medium);
  line-height: 1.25;
  text-decoration: none;
  border: 1px solid transparent;
  cursor: pointer;
  transition: all 0.15s ease-in-out;
  white-space: nowrap;
}

/* Primary Button */
.btn-primary {
  background-color: var(--color-primary-600);
  color: var(--color-neutral-0);
  border-color: var(--color-primary-600);
}

.btn-primary:hover {
  background-color: var(--color-primary-700);
  border-color: var(--color-primary-700);
}

.btn-primary:focus {
  outline: none;
  box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.2);
}

.btn-primary:active {
  background-color: var(--color-primary-800);
  transform: translateY(1px);
}

/* Secondary Button */
.btn-secondary {
  background-color: transparent;
  color: var(--color-primary-600);
  border-color: var(--color-primary-600);
}

.btn-secondary:hover {
  background-color: var(--color-primary-50);
  color: var(--color-primary-700);
}

/* Tertiary Button */
.btn-tertiary {
  background-color: transparent;
  color: var(--color-neutral-700);
  border-color: transparent;
}

.btn-tertiary:hover {
  background-color: var(--color-neutral-100);
  color: var(--color-neutral-900);
}

/* Button Sizes */
.btn-sm {
  padding: var(--space-1-5) var(--space-3);
  font-size: var(--text-xs);
}

.btn-lg {
  padding: var(--space-3) var(--space-6);
  font-size: var(--text-base);
}

.btn-xl {
  padding: var(--space-4) var(--space-8);
  font-size: var(--text-lg);
}
```

### Form Elements
```css
/* Input Base */
.input {
  width: 100%;
  padding: var(--space-2-5) var(--space-3-5);
  border: 1px solid var(--color-neutral-300);
  border-radius: 0.375rem;
  font-family: var(--font-primary);
  font-size: var(--text-sm);
  line-height: var(--leading-normal);
  color: var(--color-neutral-900);
  background-color: var(--color-neutral-0);
  transition: border-color 0.15s ease-in-out, box-shadow 0.15s ease-in-out;
}

.input:focus {
  outline: none;
  border-color: var(--color-primary-500);
  box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
}

.input:disabled {
  background-color: var(--color-neutral-50);
  color: var(--color-neutral-500);
  cursor: not-allowed;
}

/* Input States */
.input.error {
  border-color: var(--color-error-500);
}

.input.error:focus {
  border-color: var(--color-error-500);
  box-shadow: 0 0 0 3px rgba(239, 68, 68, 0.1);
}

.input.success {
  border-color: var(--color-success-500);
}

/* Select */
.select {
  appearance: none;
  background-image: url("data:image/svg+xml;charset=utf-8,%3Csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 20 20'%3E%3Cpath stroke='%236B7280' stroke-linecap='round' stroke-linejoin='round' stroke-width='1.5' d='M6 8l4 4 4-4'/%3E%3C/svg%3E");
  background-position: right 0.5rem center;
  background-repeat: no-repeat;
  background-size: 1.5em 1.5em;
  padding-right: var(--space-10);
}

/* Textarea */
.textarea {
  min-height: 6rem;
  resize: vertical;
}

/* Checkbox & Radio */
.checkbox,
.radio {
  width: 1rem;
  height: 1rem;
  color: var(--color-primary-600);
  background-color: var(--color-neutral-0);
  border: 1px solid var(--color-neutral-300);
  border-radius: 0.25rem;
}

.radio {
  border-radius: 50%;
}

.checkbox:checked,
.radio:checked {
  background-color: var(--color-primary-600);
  border-color: var(--color-primary-600);
}
```

### Cards
```css
.card {
  background-color: var(--color-neutral-0);
  border-radius: 0.5rem;
  box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px 0 rgba(0, 0, 0, 0.06);
  border: 1px solid var(--color-neutral-200);
  overflow: hidden;
}

.card-header {
  padding: var(--space-6);
  border-bottom: 1px solid var(--color-neutral-200);
}

.card-body {
  padding: var(--space-6);
}

.card-footer {
  padding: var(--space-6);
  border-top: 1px solid var(--color-neutral-200);
  background-color: var(--color-neutral-50);
}

/* Card Variants */
.card-elevated {
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
}

.card-interactive {
  cursor: pointer;
  transition: all 0.15s ease-in-out;
}

.card-interactive:hover {
  box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
  transform: translateY(-1px);
}
```

### Navigation
```css
/* Navigation Bar */
.navbar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: var(--space-4) var(--space-6);
  background-color: var(--color-neutral-0);
  border-bottom: 1px solid var(--color-neutral-200);
  box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1);
}

.navbar-brand {
  display: flex;
  align-items: center;
  gap: var(--space-3);
  font-weight: var(--font-bold);
  font-size: var(--text-lg);
  color: var(--color-neutral-900);
  text-decoration: none;
}

.navbar-nav {
  display: flex;
  align-items: center;
  gap: var(--space-6);
  list-style: none;
  margin: 0;
  padding: 0;
}

.navbar-link {
  color: var(--color-neutral-600);
  text-decoration: none;
  font-weight: var(--font-medium);
  transition: color 0.15s ease-in-out;
}

.navbar-link:hover,
.navbar-link.active {
  color: var(--color-primary-600);
}

/* Sidebar Navigation */
.sidebar {
  width: 240px;
  background-color: var(--color-neutral-0);
  border-right: 1px solid var(--color-neutral-200);
  height: 100vh;
  overflow-y: auto;
}

.sidebar-nav {
  padding: var(--space-4);
}

.sidebar-link {
  display: flex;
  align-items: center;
  gap: var(--space-3);
  padding: var(--space-3);
  border-radius: 0.375rem;
  color: var(--color-neutral-700);
  text-decoration: none;
  font-weight: var(--font-medium);
  transition: all 0.15s ease-in-out;
  margin-bottom: var(--space-1);
}

.sidebar-link:hover {
  background-color: var(--color-neutral-100);
  color: var(--color-neutral-900);
}

.sidebar-link.active {
  background-color: var(--color-primary-50);
  color: var(--color-primary-700);
}
```

### Modal & Dialog
```css
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 50;
}

.modal {
  background-color: var(--color-neutral-0);
  border-radius: 0.5rem;
  box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
  max-width: 32rem;
  width: 90%;
  max-height: 90vh;
  overflow-y: auto;
}

.modal-header {
  padding: var(--space-6);
  border-bottom: 1px solid var(--color-neutral-200);
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.modal-title {
  font-size: var(--text-lg);
  font-weight: var(--font-semibold);
  color: var(--color-neutral-900);
}

.modal-body {
  padding: var(--space-6);
}

.modal-footer {
  padding: var(--space-6);
  border-top: 1px solid var(--color-neutral-200);
  display: flex;
  gap: var(--space-3);
  justify-content: flex-end;
}
```

### Alerts & Notifications
```css
.alert {
  padding: var(--space-4);
  border-radius: 0.375rem;
  border: 1px solid;
  display: flex;
  align-items: flex-start;
  gap: var(--space-3);
}

.alert-success {
  background-color: var(--color-success-50);
  border-color: var(--color-success-200);
  color: var(--color-success-800);
}

.alert-warning {
  background-color: var(--color-warning-50);
  border-color: var(--color-warning-200);
  color: var(--color-warning-800);
}

.alert-error {
  background-color: var(--color-error-50);
  border-color: var(--color-error-200);
  color: var(--color-error-800);
}

.alert-info {
  background-color: var(--color-info-50);
  border-color: var(--color-info-200);
  color: var(--color-info-800);
}

/* Toast Notifications */
.toast {
  position: fixed;
  top: var(--space-4);
  right: var(--space-4);
  z-index: 50;
  min-width: 20rem;
  background-color: var(--color-neutral-0);
  border-radius: 0.5rem;
  box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -2px rgba(0, 0, 0, 0.05);
  border: 1px solid var(--color-neutral-200);
  padding: var(--space-4);
  animation: slideIn 0.3s ease-out;
}

@keyframes slideIn {
  from {
    transform: translateX(100%);
    opacity: 0;
  }
  to {
    transform: translateX(0);
    opacity: 1;
  }
}
```

## Interactive States

### Hover States
All interactive elements should have clear hover states:
- **Buttons**: Darker background, subtle transform
- **Links**: Color change, underline
- **Cards**: Elevation increase, subtle transform
- **Icons**: Color change, scale

### Focus States
Focus indicators for accessibility:
```css
.focus-visible {
  outline: 2px solid var(--color-primary-500);
  outline-offset: 2px;
}
```

### Active States
Immediate feedback for user actions:
```css
.active {
  transform: translateY(1px);
}
```

### Loading States
```css
.loading {
  position: relative;
  color: transparent;
}

.loading::after {
  content: '';
  position: absolute;
  top: 50%;
  left: 50%;
  width: 1rem;
  height: 1rem;
  margin: -0.5rem 0 0 -0.5rem;
  border: 2px solid var(--color-neutral-300);
  border-top-color: var(--color-primary-600);
  border-radius: 50%;
  animation: spin 0.8s linear infinite;
}

@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}
```

## Motion & Animation

### Animation Principles
- **Purposeful**: Every animation serves a functional purpose
- **Fast**: Keep animations under 300ms for UI feedback
- **Natural**: Use easing functions that feel organic
- **Respectful**: Honor user preferences for reduced motion

### Easing Functions
```css
:root {
  --ease-in: cubic-bezier(0.4, 0, 1, 1);
  --ease-out: cubic-bezier(0, 0, 0.2, 1);
  --ease-in-out: cubic-bezier(0.4, 0, 0.2, 1);
  --ease-bounce: cubic-bezier(0.68, -0.55, 0.265, 1.55);
}
```

### Animation Durations
```css
:root {
  --duration-fast: 150ms;
  --duration-normal: 250ms;
  --duration-slow: 350ms;
}
```

### Common Animations
```css
/* Fade In */
@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

/* Slide Up */
@keyframes slideUp {
  from {
    transform: translateY(1rem);
    opacity: 0;
  }
  to {
    transform: translateY(0);
    opacity: 1;
  }
}

/* Scale */
@keyframes scaleIn {
  from {
    transform: scale(0.95);
    opacity: 0;
  }
  to {
    transform: scale(1);
    opacity: 1;
  }
}
```

### Reduced Motion
```css
@media (prefers-reduced-motion: reduce) {
  *,
  *::before,
  *::after {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
    scroll-behavior: auto !important;
  }
}
```

## Accessibility Guidelines

### WCAG Compliance
SpotlightOS design system adheres to WCAG 2.1 AA standards:

#### Color Contrast
- **Normal text**: Minimum 4.5:1 contrast ratio
- **Large text**: Minimum 3:1 contrast ratio
- **UI components**: Minimum 3:1 contrast ratio

#### Focus Management
- All interactive elements must have visible focus indicators
- Focus should be logical and predictable
- Skip links for keyboard navigation

#### Screen Reader Support
```html
<!-- Proper semantic structure -->
<button aria-label="Close dialog" aria-expanded="false">
  <span aria-hidden="true">×</span>
</button>

<!-- Loading states -->
<button aria-busy="true" aria-describedby="loading-text">
  <span id="loading-text" class="sr-only">Loading...</span>
</button>
```

### Inclusive Design Checklist
- [ ] Color is not the only means of conveying information
- [ ] Text can be resized up to 200% without horizontal scrolling
- [ ] Interactive elements are at least 44px × 44px
- [ ] Forms have proper labels and error messages
- [ ] Images have descriptive alt text
- [ ] Videos have captions

## Responsive Design

### Breakpoint System
```css
:root {
  --breakpoint-sm: 640px;
  --breakpoint-md: 768px;
  --breakpoint-lg: 1024px;
  --breakpoint-xl: 1280px;
  --breakpoint-2xl: 1536px;
}

/* Mobile First Approach */
@media (min-width: 640px) { /* sm */ }
@media (min-width: 768px) { /* md */ }
@media (min-width: 1024px) { /* lg */ }
@media (min-width: 1280px) { /* xl */ }
@media (min-width: 1536px) { /* 2xl */ }
```

### Responsive Patterns
1. **Stacked to Horizontal**: Elements stack on mobile, align horizontally on desktop
2. **Hide/Show**: Certain elements hidden on mobile, visible on desktop
3. **Sidebar Collapse**: Full sidebar on desktop, collapsible on mobile
4. **Font Scaling**: Larger text on desktop, smaller on mobile

### Touch Targets
Minimum touch target size: 44px × 44px with adequate spacing between targets.

## Implementation Guidelines

### CSS Architecture
Follow BEM methodology with design tokens:
```css
/* Block */
.card { }

/* Element */
.card__header { }
.card__body { }

/* Modifier */
.card--elevated { }
.card--interactive { }
```

### Framework Integration

#### React/JSX
```jsx
// Component with design system classes
const Button = ({ variant = 'primary', size = 'base', children, ...props }) => {
  const baseClasses = 'btn';
  const variantClasses = `btn-${variant}`;
  const sizeClasses = size !== 'base' ? `btn-${size}` : '';
  
  return (
    <button 
      className={`${baseClasses} ${variantClasses} ${sizeClasses}`}
      {...props}
    >
      {children}
    </button>
  );
};
```

#### Rails/Stimulus
```javascript
// Stimulus controller for interactive components
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static classes = ["active", "loading", "disabled"]
  static targets = ["button", "spinner"]
  
  connect() {
    this.element.classList.add("btn", "btn-primary")
  }
  
  loading() {
    this.buttonTarget.classList.add(this.loadingClass)
    this.spinnerTarget.classList.remove("hidden")
  }
}
```

### Design Tokens
Use CSS custom properties for consistent theming:
```css
/* Dark mode implementation */
@media (prefers-color-scheme: dark) {
  :root {
    --color-neutral-0: #030712;
    --color-neutral-50: #111827;
    --color-neutral-900: #F9FAFB;
    /* ... other dark mode overrides */
  }
}
```

### Performance Optimization
- Use CSS containment for better rendering performance
- Implement critical CSS inlining
- Optimize font loading with font-display: swap
- Use efficient selectors and minimize specificity

## Maintenance & Updates

### Version Control
Design system follows semantic versioning:
- **Major**: Breaking changes to existing components
- **Minor**: New components or non-breaking enhancements
- **Patch**: Bug fixes and minor adjustments

### Component Lifecycle
1. **Proposal**: RFC process for new components
2. **Development**: Implementation with tests and documentation
3. **Review**: Design and code review process
4. **Release**: Version bump and changelog
5. **Deprecation**: Graceful deprecation of outdated components

### Documentation Standards
- All components must include code examples
- Accessibility notes for each component
- Usage guidelines and best practices
- Migration guides for breaking changes

### Testing Strategy
- Visual regression testing with Chromatic
- Accessibility testing with axe-core
- Cross-browser compatibility testing
- Performance monitoring

---

## Image Generation Prompts

For creating mockups and design assets, use these prompts with AI image generators:

### Desktop Application Mockup
"Modern desktop application interface with clean design, showing a dashboard with data visualizations, sidebar navigation, and SpotlightOS branding. Use blue (#2563EB) and purple (#7C3AED) accent colors, Inter font, professional layout with cards and charts."

### Mobile Interface
"Mobile app interface design for SpotlightOS, showing responsive layout with bottom navigation, card-based content, and modern UI elements. Clean, minimal design with proper touch targets and mobile-optimized typography."

### Component Library Showcase
"Design system component library showcase page displaying various UI elements like buttons, forms, cards, navigation, and modals. Organized in a grid layout with proper spacing and annotations. Professional documentation style."