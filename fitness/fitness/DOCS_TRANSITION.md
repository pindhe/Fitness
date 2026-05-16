# FitPulse Flutter Migration Guide

This project has been successfully migrated to a **Hybrid Architecture**.

## 1. Web Preview (React)
The active preview you see in AI Studio is the **React Web Front**. It serves as a visual and functional prototype of the mobile app's "Digital Twin". It uses:
- **React + Vite**
- **Tailwind CSS + Framer Motion** (for Flutter-like smooth animations)
- **Firebase Firestore** (real-time data sync)

## 2. Mobile Source (Flutter)
The production-ready Flutter codebase is located in the root of this project:
- `lib/`: Contains the Dart source code (Clean Architecture: features, core, shared).
- `pubspec.yaml`: Flutter project configuration and dependencies.
- `main.dart`: Standard Flutter entry point.

### Flutter Packagelist
We have integrated:
- **Riverpod**: Robust state management.
- **GoRouter**: Modern declarative routing.
- **Material 3**: Premium UI design system.
- **Firebase**: Native SDK integration for Auth & Firestore.
- **Flutter Animate**: High-performance UI motion.

## 3. How to Run Mobile
1. **Export code**: Use the "Export to ZIP" or "Push to GitHub" menu in AI Studio.
2. **Install Flutter**: Ensure you have the Flutter SDK installed on your local machine.
3. **Setup Firebase**: Create a project in the Firebase Console and add Android/iOS apps. 
4. **Run**:
   ```bash
   flutter pub get
   flutter run
   ```

## 4. Key Flutter Files
- Dashboard: `lib/features/home/presentation/pages/dashboard_page.dart`
- Workouts: `lib/features/workouts/presentation/pages/workout_plans_page.dart`
- Theme: `lib/config/theme/app_theme.dart`

---
*Created by Google AI Studio - FitPulse Professional Migration Protocol.*
