# hajir

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
# hajir
### To generate and update locale file and translations
All translation keys are maintained on this doc : https://docs.google.com/spreadsheets/d/1VPzo7hwFpdbA_5ftLqMB-lbMYOuBNim0/edit#gid=957720189
Export each sheet to tsv and put them inside gen/tsv_files
then run:
dart run gen/generate.dart
flutter gen-l10n
flutter pub get

flutter pub run flutter_launcher_icons# hajirv1
