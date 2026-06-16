# VisionSafe API Documentation

This project uses **Supabase** as its backend. All communication is secured via JWT and Row Level Security (RLS).

## Tables

### 1. `telemetry`
Stores real-time eye distance data and violations.
- `id` (uuid, PK)
- `user_id` (uuid, FK to auth.users)
- `distance` (float8): Estimated distance in cm.
- `is_violation` (boolean): True if distance < threshold.
- `is_blinking` (boolean): True if the user is blinking.
- `created_at` (timestamptz)

**Policies:**
- SELECT: Only owner (`auth.uid() = user_id`)
- INSERT: Only owner

### 2. `user_settings`
Stores user-specific app configuration.
- `user_id` (uuid, PK, FK to auth.users)
- `safe_distance` (float8): User-defined threshold (default 35.0).
- `updated_at` (timestamptz)

**Policies:**
- ALL: Only owner

### 3. `news`
Stores educational content for users.
- `id` (uuid, PK)
- `title` (text)
- `content` (text)
- `category` (text): e.g., 'Edukasi', 'Tips Sehat'.
- `image_url` (text)
- `source_url` (text)
- `created_at` (timestamptz)

**Policies:**
- SELECT: Everyone (public)

## Auth Flow
1. **Sign Up / Sign In**: Handled via `supabase_flutter`.
2. **Google Auth**: Uses Native Google Sign-In with Supabase Handshake.
3. **Session Management**: Persistent sessions managed by Supabase and stored in `FlutterSecureStorage`.

## Native AI Pipeline
- **Engine**: MediaPipe Face Landmarker (3D Face Mesh).
- **Sampling**: 500ms intervals (2 FPS).
- **Communication**: Flutter EventChannel (`com.hn.visionsafe/telemetry`).
