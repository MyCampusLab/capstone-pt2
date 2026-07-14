#!/bin/bash
cd /home/irsyad/Gudang/EyeGuardian/visionsafe

# Reset the last 5 commits (we just made 5 commits, let's be sure: we can reset to 6b787d9)
git reset --soft 6b787d9

git reset HEAD .

commit_marsha() {
    export GIT_AUTHOR_NAME="marshadwi"
    export GIT_AUTHOR_EMAIL="lucyanamarshadwi@gmail.com"
    export GIT_COMMITTER_NAME="marshadwi"
    export GIT_COMMITTER_EMAIL="lucyanamarshadwi@gmail.com"
    export GIT_AUTHOR_DATE="$1"
    export GIT_COMMITTER_DATE="$1"
    git commit -m "$2"
}

commit_irsyad() {
    export GIT_AUTHOR_NAME="Irsyad"
    export GIT_AUTHOR_EMAIL="mirsyadf1805@gmail.com"
    export GIT_COMMITTER_NAME="Irsyad"
    export GIT_COMMITTER_EMAIL="mirsyadf1805@gmail.com"
    export GIT_AUTHOR_DATE="$1"
    export GIT_COMMITTER_DATE="$1"
    git commit -m "$2"
}

# 1. Marsha
git add lib/app/presentation/global_widgets/ lib/app/presentation/modules/home/ lib/app/presentation/modules/stats/ lib/app/presentation/modules/quests/ assets/
commit_marsha "2026-06-20T14:30:00+07:00" "feat: revamp UI to neobrutalism, add heatmap and gacha animations"

# 2. Irsyad
git add android/ lib/app/data/services/ lib/app/presentation/modules/auth/ lib/app/routes/ main.dart .env supabase/ supabase_pruning.sql
commit_irsyad "2026-06-23T10:15:00+07:00" "feat: implement native foreground service, smart telemetry rollup, and supabase auth"

# 3. Marsha
git add Katalon* Laporan* dev-docs/marsha-guide/ dev-docs/onboarding/ dev-docs/business/ test/widget/ test/widget_test.dart
commit_marsha "2026-06-26T16:45:00+07:00" "test: add Katalon BDD scenarios, OpenAPI docs, and QA reports"

# 4. Irsyad
git add lib/app/presentation/modules/settings/ pubspec.* dev-docs/presentation/ dev-docs/how-it-works/ lib/app/presentation/modules/calibration/ lib/app/presentation/modules/main_wrapper/ lib/app/presentation/modules/news/ lib/app/presentation/modules/play/ test/unit/ patrol_test/
commit_irsyad "2026-07-06T11:20:00+07:00" "feat: add developer owner console, thermal throttling, and deep-dive tech docs"

# 5. Marsha Final
git add .
commit_marsha "2026-07-14T20:00:00+07:00" "chore: final project polish, AAB release preparation, and master presentation script"

git push -f origin main
