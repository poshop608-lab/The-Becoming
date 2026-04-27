# Branded confirmation email — setup

The repo includes `email-confirm-template.html` — a dark glassmorphic confirmation email that matches the app's look (gradient wordmark, bismillah, Ar-Ra'd ayah, glowing CTA button).

You have two paths to use it. Path A is free and takes 2 minutes. Path B is what you want long-term if you have your own domain.

---

## Path A — Use Supabase's built-in email (fastest, free)

1. Open https://supabase.com/dashboard → your project (`ggszthbqteiehsmdwcmq`).
2. Left sidebar → **Authentication** → **Email Templates**.
3. Pick the **"Confirm signup"** template from the dropdown.
4. Open `email-confirm-template.html` from this repo, copy **everything** (the whole file).
5. Paste it into the Supabase template editor, replacing the default content.
6. **Important:** Supabase uses `{{ .ConfirmationURL }}` as the placeholder for the confirm link. The template already has it — leave it as-is.
7. Optional: change the **Subject** to something like `Bismillah · Confirm your email to begin` — defaults to "Confirm your signup" otherwise.
8. Click **Save**.

That's it. Next signup gets the branded email from `noreply@mail.app.supabase.io`.

**Limits on the free path:** Supabase's built-in mailer is rate-limited to ~3 emails per hour for free projects. For a personal app this is fine. If you start sharing the app and signups spike, switch to Path B.

---

## Path B — Custom SMTP (your own domain · scales)

Pick an email provider. **Resend** is the easiest:

### Step 1 — Create the email account

1. Go to https://resend.com → sign up (free tier: 3,000 emails/month, 100/day).
2. **Domains** → **Add Domain** → enter your domain (e.g. `thebecoming.app` or whatever you own).
3. Resend shows you DNS records (TXT, MX, DKIM). Add them at your DNS provider (Vercel, Cloudflare, GoDaddy, wherever).
4. Wait ~5 minutes for verification.
5. **API Keys** → **Create API Key** → name it `supabase-smtp` → copy the key.

### Step 2 — Plug Resend into Supabase

1. Supabase Dashboard → your project → **Project Settings** (gear icon, bottom-left) → **Authentication** → scroll to **SMTP Settings**.
2. Toggle **Enable Custom SMTP** ON.
3. Fill in:
   - **Sender email:** `noreply@yourdomain.com` (must be on a verified Resend domain)
   - **Sender name:** `The Becoming`
   - **Host:** `smtp.resend.com`
   - **Port:** `465`
   - **Username:** `resend`
   - **Password:** *(paste the API key from Step 1)*
4. Click **Save**.
5. Click **Send test email** to confirm it works.

### Step 3 — Paste the template (same as Path A)

Same as above: Authentication → Email Templates → Confirm signup → paste `email-confirm-template.html` → Save.

Now signup emails come from `noreply@yourdomain.com` with your branding, and you can send up to 100/day on Resend's free tier.

---

## Other Supabase email templates

The same template structure works for the other emails Supabase sends. The placeholders differ:

| Template | Placeholder for the action link |
|---|---|
| Confirm signup | `{{ .ConfirmationURL }}` |
| Magic link | `{{ .ConfirmationURL }}` |
| Reset password | `{{ .ConfirmationURL }}` |
| Email change | `{{ .ConfirmationURL }}` |
| Invite user | `{{ .ConfirmationURL }}` |

To brand them all, copy `email-confirm-template.html` for each, then change:
- The **headline** ("Confirm my email →" → "Reset my password →" etc.)
- The **body copy**
- Keep the bismillah, ayah, and color theme identical.

---

## Alternative providers (if Resend doesn't suit you)

- **SendGrid** — host: `smtp.sendgrid.net`, port: `587`, username: `apikey`, password: API key. Free tier: 100/day.
- **Mailgun** — host: `smtp.mailgun.org`, port: `587`. Free trial: 5,000 emails for 30 days.
- **AWS SES** — cheapest at scale ($0.10 per 1,000 emails). Slightly more setup.
- **Postmark** — $15/month entry, but the best deliverability for transactional email.

The template is identical for all of them — only the SMTP credentials in Supabase change.
