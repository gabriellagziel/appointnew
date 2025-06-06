#!/bin/bash
set -euo pipefail

# 1. Path מקומי ל-Flutter ול-Dart שהועלו מראש לריפו, למשל בתוך תמונת Docker או בתיקייה נסתרת:
#    הנחנו שבפנים קיים תיקייה בשם "flutter_sdk" שמכילה את Flutter ו-Dart.
#    אם תיקייה זו לא קיימת – בדוק שביצעת Upload של התיקייה הזו לריפו.
if [ -d "/workspace/flutter_sdk" ]; then
  echo "נמצא Flutter SDK מקומי בתיקיית /workspace/flutter_sdk."
else
  echo "ERROR: לא נמצא Flutter SDK בתיקיית /workspace/flutter_sdk. יש לוודא שהועלה מראש."
  exit 1
fi

# 2. הוספת Flutter (ושאפשרות Dart המובנה) ל-PATH
export PATH="/workspace/flutter_sdk/bin:$PATH"

# 3. וידוא שהפקודות קיימות ועובדות
echo "מיקום flutter:"
which flutter || { echo "flutter לא נמצא ב-PATH"; exit 1; }
echo "מיקום dart:"
which dart || { echo "dart לא נמצא ב-PATH"; exit 1; }

# 4. הדפסת גרסאות לבדיקת תפקוד
echo "גרסת flutter:"
flutter --version || { echo "שגיאה בהרצת flutter --version"; exit 1; }
echo "גרסת dart:"
dart --version || { echo "שגיאה בהרצת dart --version"; exit 1; }

# 5. פקודות נוספות לבדיקת סביבת העבודה הנוכחית (במידת הצורך)
echo "שינוי לספריית העבודה הראשית:"
cd /workspace
echo "בדיקות נוספות:"
which flutter
which dart
flutter --version
dart --version

echo "סקריפט ההתקנה של Flutter ו-Dart הושלם בהצלחה."
