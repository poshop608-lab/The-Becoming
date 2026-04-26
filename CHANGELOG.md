# Changelog

## v3.0 — 2026-04-26

### Added
- **Email/password auth** replacing magic link. Sign in / Create account tabs + forgot password.
- **Gym tab** between Trading and Reflection with three sub-panels:
  - **Today's Workout** — auto-detects day-of-week, shows exercises with weight/reps/RPE inputs per set, "last session" hints, debounced auto-save (400ms), Mark workout complete button (saves duration + overall RPE)
  - **Personal Records** — best weight × reps per exercise, Epley e1RM, grouped by category (Push/Pull/Legs/Shoulders), gold pulse animation on new PR
  - **Progress Charts** — volume over time, exercise progression (per-exercise dropdown), 12-week GitHub-style frequency heatmap
- **Workout Split customization** in Customize tab — 7 day cards, editable labels, add/remove exercises, rest day toggle, reset to default
- **Mobile bottom nav** — fixed icon nav on screens ≤640px (replaces overflow tabs)
- **2 new stat cards** — Workouts logged, Total volume lifted
- **PDF report extension** — new "Gym progress" section with PR table

### Changed
- Tab order now: Today, Physical, Trading, **Gym**, Reflection, Duas, Stats, History, Customize
- Body font weight 400 → 500 for AMOLED legibility
- Arabic text size +10–15% across `.arabic-small`, `.quote-arabic`, `.dua-arabic`, `.section-arabic`, `.hero .ayah-arabic`
- Arabic line-height ≥ 2 everywhere
- Gold text now has subtle text-shadow for contrast
- Spacing standardized to 4px multiples; border-radius limited to 4/6/8px
- Focus states use gold outline (a11y)
- Checkbox tick now animates in (200ms scale draw)
- Toast position raised to clear bottom nav

### Database
- New `becoming_workouts` table (id, user_id, workout_date, day_label, exercises jsonb, duration_minutes, overall_rpe, timestamps, UNIQUE(user_id, workout_date))
- 4 RLS policies (select/insert/update/delete)
- `updated_at` trigger
- Added to `supabase_realtime` publication
- New `workout_structure jsonb` column on `becoming_settings`

### Realtime
- New `workouts_<user_id>` channel; echo prevention via `lastWorkoutWrite`
- Settings channel now also syncs `workout_structure`

## Deployment

1. Run `schema_update_v3.sql` in Supabase SQL editor
2. **Configure SMTP** in Supabase Dashboard → Authentication → Email Templates → SMTP Settings (use Resend: host `smtp.resend.com`, port 465, user `resend`, password = your Resend API key)
3. Push `index.html` to GitHub — Pages/Vercel will redeploy automatically
