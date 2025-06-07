# AppointNew Setup

This repository currently contains a simple setup script for installing the
Flutter SDK along with Dart. The tasks are outlined below.

## Tasks

1. **Setting up Flutter**  
   Run `setup.sh` to install Flutter and its dependencies. The script performs
   the following steps:
   - Updates package lists and installs prerequisites.
   - Clones the Flutter repository into `/opt/flutter`.
   - Adds Flutter (and its bundled Dart) to `PATH`.
   - Optionally verifies the installation by printing version information.

2. **Verifying Installation**  
   After running the setup script, you can verify that Flutter and Dart are on
   the `PATH`:

   ```bash
   which flutter
   which dart
   flutter --version
   dart --version
   ```

## Files Added

- `setup.sh` – Bash script used to install Flutter and verify that the SDK is
  correctly installed.

The repository originally contained only `.gitignore` and `LICENSE` files.
This README and `setup.sh` have been added to document and automate the
initial setup process.

## Personal Scheduler UI

The `PersonalHomeScreen` under `lib/features/personal_scheduler` presents a simple
calendar header with a list of sample appointments. A floating action button
navigates to a placeholder screen for adding new appointments. Basic widget
tests for this feature live in `test/features/personal_scheduler`.
