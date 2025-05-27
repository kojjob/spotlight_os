# Spotlight OS Design System
## AI Revenue Assistant Suite - Complete Design Guide

> **Vision Statement**  
> Create a calm, confidence-inspiring workspace that empowers sales teams to harness AI-powered revenue generation. Prioritize clarity, white space, and an information-first hierarchy that scales seamlessly from mobile to ultrawide displays without visual clutter.

---

## 📋 Table of Contents

1. [Brand Identity](#-brand-identity)
2. [Color System](#-color-system)
3. [Typography](#-typography)
4. [Layout & Grid System](#-layout--grid-system)
5. [Component Library](#-component-library)
6. [Interactive States](#-interactive-states)
7. [Motion & Animation](#-motion--animation)
8. [Accessibility Guidelines](#-accessibility-guidelines)
9. [Responsive Design](#-responsive-design)
10. [Implementation Guidelines](#-implementation-guidelines)

---

## 🎨 Brand Identity

### Core Principles
- **Confident & Professional**: Instill trust in AI-powered sales automation
- **Human-Centered**: Balance cutting-edge technology with human warmth
- **Data-Driven**: Present complex information with clarity and purpose
- **Scalable Intelligence**: Design that grows with business complexity

### Visual Language
- **Neo-minimal aesthetic**: Clean surfaces with subtle depth and soft shadows
- **Conversation-centric**: Voice waveform motifs and chat-inspired elements
- **Revenue-focused**: Visual hierarchy that emphasizes metrics and outcomes
- **AI-enhanced**: Subtle glow effects and intelligent micro-interactions

---

## 🎨 Color System

### Primary Palette

| Color | Hex | Usage | Application |
|-------|-----|--------|-------------|
| **Deep Indigo** | `#1E1B4B` | Primary brand, headers, CTAs | 70% usage |
| **Sky Blue** | `#3C8AFF` | Accents, active states, highlights | 15% usage |
| **Warm Gray 90** | `#F6F5F4` | Primary background | - |
| **Warm Gray 60** | `#BFBDBA` | Dividers, secondary text | - |

### Secondary Palette

| Color | Hex | Usage |
|-------|-----|--------|
| **Emerald** | `#24C38A` | Success states, positive metrics |
| **Coral** | `#FF6B6B` | Alerts, warnings, critical actions |
| **Teal** | `#00B2A9` | AI recommendations, smart features |
| **Navy** | `#1A2337` | Alternative primary for dark themes |

### Semantic Colors

```css
/* CSS Custom Properties */
:root {
  /* Primary */
  --color-primary: #1E1B4B;
  --color-primary-light: #2D2A5B;
  --color-primary-dark: #0F0D2B;
  
  /* Accent */
  --color-accent: #3C8AFF;
  --color-accent-light: #4C9AFF;
  --color-accent-dark: #2C7AEF;
  
  /* Neutral */
  --color-gray-50: #F9FAFB;
  --color-gray-100: #F3F4F6;
  --color-gray-200: #E5E7EB;
  --color-gray-300: #D1D5DB;
  --color-gray-400: #9CA3AF;
  --color-gray-500: #6B7280;
  --color-gray-600: #4B5563;
  --color-gray-700: #374151;
  --color-gray-800: #1F2937;
  --color-gray-900: #111827;
  
  /* Semantic */
  --color-success: #24C38A;
  --color-warning: #F59E0B;
  --color-error: #FF6B6B;
  --color-info: #00B2A9;
}
```

---

## ✍️ Typography

### Font Stack
**Primary**: Inter (Google Fonts)  
**Fallback**: -apple-system, BlinkMacSystemFont, "Segoe UI", system-ui, sans-serif

### Type Scale

| Style | Size/Line Height | Weight | Usage |
|-------|------------------|---------|-------|
| **Display-1** | 36px/44px | 700 (Bold) | Page titles, hero headlines |
| **Heading-1** | 32px/40px | 600 (SemiBold) | Section headers |
| **Heading-2** | 24px/32px | 600 (SemiBold) | Card titles, subsections |
| **Heading-3** | 20px/28px | 600 (SemiBold) | Component headers |
| **Body-Large** | 18px/28px | 400 (Regular) | Important body text |
| **Body** | 16px/24px | 400 (Regular) | Default body text |
| **Body-Small** | 14px/20px | 400 (Regular) | Secondary text |
| **Caption** | 12px/16px | 500 (Medium) | Labels, helper text |

### CSS Implementation

```css
/* Typography Classes */
.text-display-1 {
  font-size: 2.25rem;
  line-height: 2.75rem;
  font-weight: 700;
  letter-spacing: -0.025em;
}

.text-heading-1 {
  font-size: 2rem;
  line-height: 2.5rem;
  font-weight: 600;
  letter-spacing: -0.025em;
}

.text-heading-2 {
  font-size: 1.5rem;
  line-height: 2rem;
  font-weight: 600;
  letter-spacing: -0.025em;
}

.text-body {
  font-size: 1rem;
  line-height: 1.5rem;
  font-weight: 400;
  letter-spacing: 0;
}

.text-caption {
  font-size: 0.75rem;
  line-height: 1rem;
  font-weight: 500;
  letter-spacing: 0.025em;
  text-transform: uppercase;
}
```

---

## 📐 Layout & Grid System

### Grid Specifications
- **Desktop**: 12-column fluid grid with 24px gutters
- **Tablet**: 6-column grid with 20px gutters  
- **Mobile**: Single-column with 16px margins

### Layout Structure

```
┌─────────────────────────────────────────────────────────────┐
│ Top Bar (64px height)                                       │
│ ┌─ Search ─┬─ Notifications ─┬─ Avatar ─┬─ Schedule Demo ─┐ │
├─────────────────────────────────────────────────────────────┤
│ Breadcrumb Navigation (40px height)                        │
├─────┬───────────────────────────────────────────────────────┤
│     │ Main Content Area                                   │
│ S   │ ┌─────────────────────────────────────────────────┐ │
│ i   │ │ Primary Content Cards                           │ │
│ d   │ │ (12-column responsive grid)                     │ │
│ e   │ └─────────────────────────────────────────────────┘ │
│ b   │                                                     │
│ a   │ ┌─────────────────────────────────────────────────┐ │
│ r   │ │ Secondary Content / Side Panels                 │ │
│     │ └─────────────────────────────────────────────────┘ │
│(72px│                                                     │
│     │                                                     │
└─────┴───────────────────────────────────────────────────────┘
```

### Navigation Structure
- **Fixed Sidebar (72px width)**: Icon-led primary navigation
  - 🤖 AI Assistants
  - 🎯 Leads
  - 💬 Conversations  
  - 📅 Appointments
  - 💳 Billing
- **Top Bar (64px height)**: Global search, notifications, user controls
- **Breadcrumb Trail**: Contextual navigation for multi-step flows

### Breakpoints

```css
/* Responsive Breakpoints */
:root {
  --breakpoint-sm: 640px;   /* Mobile landscape */
  --breakpoint-md: 768px;   /* Tablet */
  --breakpoint-lg: 1024px;  /* Desktop */
  --breakpoint-xl: 1280px;  /* Large desktop */
  --breakpoint-2xl: 1536px; /* Ultra-wide */
}

@media (max-width: 768px) {
  /* Sidebar collapses to bottom navigation */
  /* Cards stack vertically */
  /* Touch-optimized interactions */
}
```

---

## 🧩 Component Library

### Primary Components

#### 1. AI Assistant Configurator
**Layout**: Two-pane interface with list and details view

- **Left Panel**: Assistant list with search and filters
- **Right Panel**: Configurable cards (Persona, Script, Voice, Scheduling)
- **Features**: Inline validation chips, progress indicators, training status
- **Interaction**: Click to select, auto-save on changes

#### 2. Conversation Transcript Viewer
**Layout**: Timeline with sentiment analysis

- **Main Area**: Alternating speech bubbles (AI: Sky Blue, Human: Warm Gray)
- **Right Rail**: Sentiment chart, key moments, action buttons
- **Features**: Waveform scrubbing, sentiment heat-map, AI insights
- **Actions**: Generate follow-up email, bookmark moments, export

#### 3. Lead Qualification Flow
**Layout**: Kanban board with smart cards

- **Swim Lanes**: New → Qualified → Proposal → Closed
- **Card Elements**: Lead score badge, interaction timestamp, quick actions
- **Interactions**: Drag-and-drop, bulk operations, predictive suggestions
- **Features**: Real-time updates, filtering, search

#### 4. Real-time Chat Panel
**Layout**: Dockable side panel

- **Features**: WebSocket live updates, typing indicators, canned responses
- **Interactions**: Expandable/collapsible, emoji reactions, file sharing
- **Status**: Online presence, message delivery confirmation

#### 5. Onboarding Wizard
**Layout**: Multi-step modal overlay

- **Progress**: 4-step flow with visual progress dots
- **Features**: Micro-animations, Lottie illustrations, auto-save
- **Navigation**: Back/Next buttons, skip options, contextual help

### Advanced Components

#### 6. Conversational Timeline + Sentiment Heat-Map
**Purpose**: Visual analysis of conversation quality and emotional flow

- **Element**: Horizontal waveform with color-coded sentiment overlay
- **Interaction**: Hover to scrub audio and view exact sentences
- **Placement**: Full-width under call player, collapsible
- **Colors**: Green (positive) → Yellow (neutral) → Red (negative)

#### 7. AI Next-Best-Action Panel
**Purpose**: Contextual sales assistance during conversations

- **Element**: Sliding drawer with AI-generated recommendations
- **Contents**: Talking points, collateral suggestions, email templates
- **Visual Cues**: Pulsing glow on new recommendations
- **Control**: Pin/unpin to manage workspace clutter

#### 8. Script Builder with A/B Testing
**Purpose**: Visual conversation flow design and optimization

- **Element**: Flowchart canvas with draggable dialogue nodes
- **Features**: A/B variant labeling, performance metrics overlay
- **Collaboration**: Comment threads on individual blocks
- **Testing**: Auto-rotate percentage settings, real-time results

#### 9. Live Call Control Bar
**Purpose**: Real-time call management and intervention

- **Element**: Floating bottom bar during active calls
- **Controls**: Whisper, barge-in, mute bot, note-taking
- **Accessibility**: Hotkey support, voice commands
- **Safety**: Confirmation prompts for disruptive actions

#### 10. Integration Health Monitor
**Purpose**: System status and connectivity overview

- **Element**: Grid of integration tiles (CRMs, dialers, calendars)
- **Status**: Live API heartbeat indicators (green/amber/red)
- **Actions**: One-click re-authentication, quick troubleshooting

---

## 🎭 Interactive States

### Button States

| State | Background | Border | Text | Shadow | Transition |
|-------|------------|---------|------|---------|------------|
| **Default** | Primary | None | White | 0 2px 4px rgba(0,0,0,0.1) | - |
| **Hover** | Primary +8% lighter | None | White | 0 4px 8px rgba(0,0,0,0.15) | 200ms ease-out |
| **Active** | Primary +12% darker | 2px Primary +20% darker | White | 0 1px 2px rgba(0,0,0,0.2) | 120ms ease-out |
| **Focus** | Primary | 2px Sky Blue | White | 0 0 0 2px Sky Blue | Instant |
| **Disabled** | Gray-300 | None | Gray-500 | None | 200ms ease-out |

### Card States

```css
/* Card Component States */
.card {
  background: white;
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
  transition: all 200ms ease-out;
}

.card:hover {
  transform: translateY(-2px);
  box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12);
}

.card:active {
  transform: translateY(0);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
}
```

### Form States

- **Default**: Neutral border, subtle background
- **Focus**: Sky Blue border, white background
- **Valid**: Emerald border, success icon
- **Error**: Coral border, error icon, helper text
- **Disabled**: Gray background, reduced opacity

---

## 🎬 Motion & Animation

### Animation Principles
- **Purposeful**: Every animation serves a functional purpose
- **Responsive**: Respect user's motion preferences
- **Performant**: Use transform and opacity for smooth 60fps
- **Contextual**: Animations reinforce spatial relationships

### Timing Functions

```css
/* Custom Easing Curves */
:root {
  --ease-out-smooth: cubic-bezier(0.25, 0.46, 0.45, 0.94);
  --ease-out-back: cubic-bezier(0.34, 1.56, 0.64, 1);
  --ease-in-out: cubic-bezier(0.4, 0, 0.2, 1);
  --ease-bounce: cubic-bezier(0.68, -0.55, 0.265, 1.55);
}
```

### Duration Scale

| Duration | Usage | CSS Variable |
|----------|-------|--------------|
| **120ms** | Button presses, micro-interactions | `--duration-fast` |
| **200ms** | Panel transitions, hover states | `--duration-base` |
| **300ms** | Modal overlays, page transitions | `--duration-slow` |
| **500ms** | Loading states, success animations | `--duration-slower` |

### Key Animations

#### Page Transitions
```css
.page-enter {
  opacity: 0;
  transform: translateX(20px);
}

.page-enter-active {
  opacity: 1;
  transform: translateX(0);
  transition: all 300ms var(--ease-out-smooth);
}
```

#### Loading States
```css
@keyframes pulse {
  0%, 100% { opacity: 1; }
  50% { opacity: 0.5; }
}

.loading-pulse {
  animation: pulse 2s infinite;
}
```

#### Success Feedback
```css
@keyframes checkmark {
  0% { 
    stroke-dashoffset: 100;
    opacity: 0;
  }
  50% {
    opacity: 1;
  }
  100% { 
    stroke-dashoffset: 0;
    opacity: 1;
  }
}
```

---

## ♿ Accessibility Guidelines

### Color Contrast
- **AA Compliance**: Minimum 4.5:1 contrast ratio for normal text
- **AAA Preferred**: 7:1 contrast ratio for enhanced readability
- **Large Text**: Minimum 3:1 contrast ratio for 18px+ text

### Focus Management
```css
/* Focus Ring Standards */
.focus-ring {
  outline: 2px solid var(--color-accent);
  outline-offset: 2px;
  border-radius: 4px;
}

/* Skip to content link */
.skip-to-content {
  position: absolute;
  top: -100px;
  left: 0;
  background: var(--color-primary);
  color: white;
  padding: 8px 16px;
  text-decoration: none;
  z-index: 1000;
}

.skip-to-content:focus {
  top: 0;
}
```

### ARIA Implementation
- **Dynamic Content**: Use `aria-live` regions for real-time updates
- **Complex Widgets**: Implement proper `role`, `aria-expanded`, `aria-selected`
- **Form Validation**: Associate errors with `aria-describedby`
- **Loading States**: Use `aria-busy` and descriptive labels

### Keyboard Navigation
- **Tab Order**: Logical flow through interface elements
- **Shortcuts**: Alt+1-9 for main navigation sections
- **Escape**: Close modals and overlays
- **Enter/Space**: Activate buttons and links
- **Arrow Keys**: Navigate within components (dropdowns, tabs)

### Motion Sensitivity
```css
@media (prefers-reduced-motion: reduce) {
  * {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
  }
}
```

---

## 📱 Responsive Design

### Mobile-First Approach

#### Navigation Adaptation
- **Desktop**: Fixed 72px sidebar with icons and labels
- **Tablet**: Collapsible sidebar, icon-only when collapsed
- **Mobile**: Bottom navigation bar with 5 primary sections

#### Content Adaptation
- **Desktop**: Multi-column layouts, side panels
- **Tablet**: Stacked columns, expandable panels
- **Mobile**: Single column, full-width cards, swipe gestures

#### Interaction Patterns
- **Desktop**: Hover states, right-click menus, keyboard shortcuts
- **Tablet**: Touch-friendly targets (44px minimum), long-press menus
- **Mobile**: Swipe gestures, pull-to-refresh, thumb-friendly navigation

### Touch Targets
```css
/* Minimum touch target sizes */
.touch-target {
  min-height: 44px;
  min-width: 44px;
  padding: 12px;
}

/* Mobile-specific spacing */
@media (max-width: 768px) {
  .card {
    margin: 8px;
    padding: 16px;
  }
  
  .button {
    width: 100%;
    height: 48px;
  }
}
```

---

## 🛠 Implementation Guidelines

### CSS Architecture

#### Utility-First with TailwindCSS
```css
/* Component composition approach */
.btn-primary {
  @apply px-6 py-3 bg-primary-600 text-white rounded-lg;
  @apply font-semibold transition-all duration-200;
  @apply hover:bg-primary-700 hover:shadow-lg;
  @apply focus:outline-none focus:ring-2 focus:ring-primary-500;
  @apply disabled:opacity-50 disabled:cursor-not-allowed;
}
```

#### Custom Properties for Theming
```css
/* Light theme (default) */
:root {
  --color-background: #ffffff;
  --color-surface: #f9fafb;
  --color-text-primary: #1f2937;
  --color-text-secondary: #6b7280;
}

/* Dark theme */
[data-theme="dark"] {
  --color-background: #111827;
  --color-surface: #1f2937;
  --color-text-primary: #f9fafb;
  --color-text-secondary: #d1d5db;
}
```

### Component Development

#### React/Stimulus Integration
```javascript
// Stimulus controller example
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["panel", "trigger"]
  static classes = ["expanded", "collapsed"]
  
  toggle() {
    this.panelTarget.classList.toggle(this.expandedClass)
    this.updateAria()
  }
  
  updateAria() {
    const expanded = this.panelTarget.classList.contains(this.expandedClass)
    this.triggerTarget.setAttribute("aria-expanded", expanded)
  }
}
```

### Performance Considerations
- **Critical CSS**: Inline above-the-fold styles
- **Font Loading**: Use `font-display: swap` for web fonts
- **Image Optimization**: Responsive images with `srcset`
- **Animation**: Use `transform` and `opacity` for smooth animations

### Testing Checklist
- [ ] Color contrast meets WCAG AA standards
- [ ] All interactive elements are keyboard accessible
- [ ] Focus indicators are visible and consistent
- [ ] Motion respects user preferences
- [ ] Touch targets meet minimum 44px requirement
- [ ] Text remains legible at 200% zoom
- [ ] Components work with screen readers

---

## 🎨 Image Generation Prompts

### Main Dashboard (1536×1024)
```
Ultra-high-fidelity SaaS dashboard UI, modern responsive design for AI Revenue Assistant Suite—clean minimal layout, Deep Indigo (#1E1B4B) sidebar with icons (Assistants, Leads, Conversations, Appointments, Billing), top bar with global search and user avatar, 12-column grid main area. Visible modules: AI Assistant Configurator card stack, real-time conversation transcript timeline (speech bubbles Sky Blue vs Warm Gray), lead qualification Kanban board cards with soft shadows and rounded corners, interactive charts (Indigo bars, Sky Blue highlights), large Sky Blue CTA button. Soft ambient shadows, ample white space, Inter font typography, crisp vector icons, subtle depth effects, vibrant yet professional mood. Render in 1536×1024, slight 3D perspective, depth-of-field blur on background, photorealistic screen reflections.
```

### Conversation Analysis (1536×1024)
```
1536x1024, ultra-sharp SaaS dashboard for Voice AI Sales Platform, wide desktop canvas, clean neo-minimal style, navy #1A2337 top nav, modular cards on cool grey #F5F7FA background, central conversational timeline with color-gradient sentiment heat-map beneath waveform (green to red), right side AI next-best-action drawer glowing teal #00B2A9, floating live-call control bar at bottom, top-right user avatar dropdown, subtle glass-morphism overlays, soft drop shadows, Inter font labels, implied micro-animations with motion blur streaks, cinematic yet professional lighting, 1:1.2 perspective, slight depth-of-field, high fidelity UI design reference.
```

### Mobile Interface (375×812)
```
Mobile-first Voice AI Sales app interface, iPhone 14 Pro dimensions 375x812, Deep Indigo bottom navigation with 5 icons, Sky Blue active state, card-based layout stacked vertically, conversation bubbles adapted for mobile, swipe-enabled Kanban cards, large touch targets 44px minimum, Inter font optimized for mobile reading, thumb-friendly interaction zones, minimal shadows optimized for small screen, clean iOS-inspired aesthetics, portrait orientation, high pixel density rendering.
```

---

## 📝 Design Tokens

### Spacing Scale
```css
:root {
  --space-0: 0;
  --space-1: 0.25rem;   /* 4px */
  --space-2: 0.5rem;    /* 8px */
  --space-3: 0.75rem;   /* 12px */
  --space-4: 1rem;      /* 16px */
  --space-5: 1.25rem;   /* 20px */
  --space-6: 1.5rem;    /* 24px */
  --space-8: 2rem;      /* 32px */
  --space-10: 2.5rem;   /* 40px */
  --space-12: 3rem;     /* 48px */
  --space-16: 4rem;     /* 64px */
  --space-20: 5rem;     /* 80px */
}
```

### Border Radius
```css
:root {
  --radius-sm: 0.25rem;   /* 4px */
  --radius-base: 0.5rem;  /* 8px */
  --radius-lg: 0.75rem;   /* 12px */
  --radius-xl: 1rem;      /* 16px */
  --radius-full: 9999px;  /* Full circle */
}
```

### Shadow Scale
```css
:root {
  --shadow-sm: 0 1px 2px rgba(0, 0, 0, 0.05);
  --shadow-base: 0 2px 4px rgba(0, 0, 0, 0.08);
  --shadow-md: 0 4px 8px rgba(0, 0, 0, 0.12);
  --shadow-lg: 0 8px 16px rgba(0, 0, 0, 0.15);
  --shadow-xl: 0 16px 32px rgba(0, 0, 0, 0.18);
}
```

---

## 🚀 Additional UI/UX Patterns

### Gamification & Coaching Hub
**Purpose**: Drive sales performance through friendly competition

- **Leaderboard Cards**: Weekly/monthly rankings with progress rings
- **Achievement Badges**: Milestone celebrations with confetti animations
- **Goal Tracking**: Visual progress bars with completion celebrations
- **Coaching Insights**: AI-powered improvement suggestions

### Compliance & Risk Management
**Purpose**: Ensure regulatory compliance and data protection

- **Recording Consent Tracking**: Real-time status indicators
- **PII Detection**: Automatic flagging and redaction
- **Audit Trail**: Complete interaction logging
- **Risk Alerts**: Escalation paths for compliance issues

### Smart Integrations
**Purpose**: Seamless workflow connectivity

- **CRM Synchronization**: Bi-directional data flow
- **Calendar Integration**: Smart scheduling optimization
- **Payment Processing**: In-conversation deal closure
- **Communication Tools**: Multi-channel orchestration

---

This comprehensive design system provides the foundation for building a cohesive, accessible, and scalable AI Revenue Assistant Suite that empowers sales teams while maintaining visual consistency and user-centered design principles.
