# Branded Supabase email templates

The `emails/` folder contains 5 dark glassmorphic email templates matching the dashboard's look (gradient wordmark, bismillah header, Quran/hadith ayah block, glowing CTA). Each one is tuned to its specific Supabase auth event.

| # | File | Supabase template name | Suggested subject |
|---|------|------------------------|-------------------|
| 1 | `emails/01-confirm-signup.html` | **Confirm signup** | `Bismillah · Confirm your email to begin` |
| 2 | `emails/02-magic-link.html` | **Magic Link** | `Your sign-in link · The Becoming` |
| 3 | `emails/03-reset-password.html` | **Reset Password** | `Reset your password · The Becoming` |
| 4 | `emails/04-change-email.html` | **Change Email Address** | `Confirm your new email · The Becoming` |
| 5 | `emails/05-invite.html` | **Invite User** | `You're invited to The Becoming` |

---

## Install (once you have Resend SMTP plugged in)

For **each** template above, do:

1. Open the `.html` file from the `emails/` folder in this repo. Click **Raw** on GitHub → Ctrl+A → Ctrl+C.
2. Open https://supabase.com/dashboard → your project → **Authentication** → **Email Templates**.
3. Pick the matching template name from the dropdown (see table above).
4. Clear the editor → paste the HTML → set the suggested **Subject**.
5. Click **Save**.

Repeat for all 5. Total time: ~5 minutes.

---

## Template placeholders

Supabase fills these in automatically when sending:

| Placeholder | Used in | Meaning |
|-------------|---------|---------|
| `{{ .ConfirmationURL }}` | All 5 | The action link (confirm / sign in / reset / accept) |
| `{{ .Email }}` | `04-change-email.html` | The user's current email address |
| `{{ .NewEmail }}` | `04-change-email.html` | The new email address being requested |
| `{{ .Token }}` | (not used here, but available) | The 6-digit OTP code, if you want token-based flows |
| `{{ .TokenHash }}` | (not used here) | Hashed token for verifying via redirect |
| `{{ .SiteURL }}` | (not used here) | Your project's site URL from Supabase config |

Don't change the `{{ .ConfirmationURL }}` placeholders — they're how Supabase wires the action button to the right URL with the right token.

---

## Already on Resend SMTP

If you've already toggled custom SMTP in Supabase (Project Settings → Authentication → SMTP Settings) with `smtp.resend.com`, then these templates will send through your verified Resend domain automatically. No further config needed — just paste the HTML.

If you want to verify it's wired correctly:

1. Project Settings → Authentication → SMTP Settings → confirm the sender email is on a domain marked **Verified** in your Resend dashboard.
2. Click **Send test email** in the SMTP panel — should arrive within seconds from your sender address.

---

## After install

Test each flow once:

- **Confirm signup** — sign up a throwaway account. You'll get template 1.
- **Magic link** — on the sign-in screen, request a magic link if you've enabled it.
- **Reset password** — click "Forgot password" on sign-in. You'll get template 3.
- **Change email** — from inside the app's account settings (when you build that flow). You'll get template 4.
- **Invite** — only sent if you call `supabase.auth.admin.inviteUserByEmail()` from a server function or the dashboard's user management UI. You'll get template 5.

Inbox preview a few of them in Gmail (web + iOS), Outlook, and Apple Mail. The templates use only inline-safe CSS (no flexbox, no CSS grid) and table-based layout for max compatibility.

---

## If something looks broken in a specific client

- **Gradient text not rendering** → some Outlook versions strip `background-clip: text`. The wordmark falls back to solid `#a78bfa` purple in that case (look for the `color:#a78bfa` fallback set inline on the `<span>`).
- **CTA button color flat** → Outlook strips the gradient `background:` on `<td>`. The button still works, just appears flat purple.
- **Arabic font** → falls back from Amiri → Times New Roman in clients without web font support. Renders correctly either way; just slightly less ornate.

If you see anything else, screenshot it and I'll patch.
