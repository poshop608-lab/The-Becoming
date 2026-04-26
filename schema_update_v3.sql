-- ============================================================
-- schema_update_v3.sql
-- Run in Supabase SQL editor: https://supabase.com/dashboard/project/ggszthbqteiehsmdwcmq/sql
-- ============================================================

-- 1. Create becoming_workouts table
CREATE TABLE IF NOT EXISTS public.becoming_workouts (
  id                uuid             DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id           uuid             REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  workout_date      date             NOT NULL,
  day_label         text,
  exercises         jsonb            DEFAULT '[]'::jsonb,
  duration_minutes  int,
  overall_rpe       int,
  created_at        timestamptz      DEFAULT now() NOT NULL,
  updated_at        timestamptz      DEFAULT now() NOT NULL,
  UNIQUE(user_id, workout_date)
);

-- 2. Extend becoming_settings with workout_structure column
ALTER TABLE public.becoming_settings
  ADD COLUMN IF NOT EXISTS workout_structure jsonb DEFAULT '{}'::jsonb;

-- 3. Row Level Security on becoming_workouts
ALTER TABLE public.becoming_workouts ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view own workouts"
  ON public.becoming_workouts FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own workouts"
  ON public.becoming_workouts FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own workouts"
  ON public.becoming_workouts FOR UPDATE
  USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own workouts"
  ON public.becoming_workouts FOR DELETE
  USING (auth.uid() = user_id);

-- 4. updated_at auto-trigger
CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS becoming_workouts_updated_at ON public.becoming_workouts;
CREATE TRIGGER becoming_workouts_updated_at
  BEFORE UPDATE ON public.becoming_workouts
  FOR EACH ROW EXECUTE FUNCTION public.handle_updated_at();

-- 5. Add to realtime publication
ALTER PUBLICATION supabase_realtime ADD TABLE public.becoming_workouts;
