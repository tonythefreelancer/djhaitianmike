# DJ Haitian Mike - Booking System

A complete DJ booking solution with WordPress plugin, static HTML export, and email verification system.

## 🎯 Overview

This project contains:
- **WordPress Plugin** (`wordpress-plugin/dj-booking-plugin/`) — Full booking form with admin dashboard, search, pagination, and CSV export
- **Static HTML Export** (`export/`) — Standalone HTML/CSS/JS for static hosting (Netlify, GitHub Pages, etc.)
- **Original PHP Site** — Vanilla PHP implementation with SendGrid integration

## ✨ Features

### WordPress Plugin
- Custom booking form with validation
- Email verification tokens
- Admin dashboard with search & pagination
- CSV export of submissions
- Custom page template with logo, video, and form
- Responsive design
- Database storage (`wp_dj_booking_requests`)

### Static HTML Export
- Standalone HTML/CSS/JS (no PHP backend)
- Mobile-responsive
- Form validation
- Can integrate with backend PHP if deployed on same server

### Original PHP Implementation
- Direct form submission to `process.php`
- Email verification via `confirm.php`
- JSON-based storage or database
- SendGrid integration ready

## 📦 Installation

### WordPress Plugin (Recommended)
1. Go to WordPress Admin → Plugins → Add New → Upload Plugin
2. Choose `wordpress-plugin/dj-booking-plugin.zip`
3. Click Install Now → Activate
4. Create a Page with shortcode `[dj_booking_form]` or use "DJ Booking Page" template
5. Upload logos/video via Media → Add New
6. Test the form and check Admin → DJ Bookings

### Static HTML (Netlify, GitHub Pages, etc.)
1. Use files in `export/` folder
2. Deploy to Netlify: drag & drop folder on app.netlify.com/drop
3. Deploy to GitHub Pages: push `export/` to `username.github.io` repo
4. Deploy to traditional hosting: upload via FTP/SFTP to public_html

### Original PHP (Self-hosted)
1. Upload `index.html`, `process.php`, `confirm.php` to server
2. Configure SendGrid API key in `process.php`
3. Update email settings in both files
4. Test form submission

## 📋 File Structure

```
e:\DJHM/
├── wordpress-plugin/
│   ├── dj-booking-plugin/
│   │   ├── dj-booking-plugin.php       (main plugin file)
│   │   ├── README.txt                  (plugin readme)
│   │   ├── assets/
│   │   │   ├── style.css
│   │   │   └── script.js
│   │   └── templates/
│   │       ├── booking-form.php
│   │       ├── page-dj-booking.php     (page template)
│   │       ├── dj-booking.css
│   │       └── script.js
│   └── dj-booking-plugin.zip           (ready to upload)
├── export/
│   ├── index.html
│   ├── style.css
│   ├── script.js
│   └── README.md
├── index.html                          (original)
├── process.php                         (form processor)
├── confirm.php                         (email verification)
├── data/
│   └── requests.json
├── Images/
└── Video/
```

## 🚀 Deployment

### WordPress.com / Self-hosted WordPress
```bash
# Upload plugin zip via WP Admin
# Or via SFTP: upload dj-booking-plugin folder to /wp-content/plugins/
# Activate in Plugins menu
```

### Netlify
```bash
# Drag & drop export/ folder on app.netlify.com/drop
# Or connect GitHub repo and select export/ folder
```

### GitHub Pages
```bash
# Create repo: username.github.io
# Push export/ folder contents to main branch
# Site will be live at https://username.github.io
```

### Traditional Hosting (cPanel, etc.)
```bash
# FTP/SFTP: upload to /public_html/ or /wp-content/plugins/ (for WordPress)
# Or use File Manager in cPanel
```

## ⚙️ Configuration

### SendGrid (for email)
1. Get API key from SendGrid dashboard
2. Add to WordPress via WP Mail SMTP plugin, or
3. Set in `process.php` / `confirm.php`:
   ```php
   $SENDGRID_API_KEY = "your-api-key-here";
   ```

### Email Settings
- Update `$FROM_EMAIL` and `$to_email` in PHP files
- Configure WordPress email in Settings → General

## 🧪 Testing

### WordPress Plugin
1. Activate plugin
2. Create/edit a page with shortcode `[dj_booking_form]`
3. Submit test booking
4. Check Admin → DJ Bookings for entry
5. Verify email was sent (check spam folder)

### Static HTML
1. Open `export/index.html` locally
2. Submit form (will validate client-side)
3. If `process.php` is on same server, will save/email

### Original PHP
1. Open `index.html` in browser
2. Fill form and submit
3. Check email verification link in inbox
4. Click link to verify and trigger admin notification

## 🛠️ Development

### Local Testing
```bash
# Start PHP server (included in .vscode/tasks.json)
cd e:\DJHM
php -S localhost:8080

# Visit http://localhost:8080
```

### Making Changes
- WordPress plugin code: edit `wordpress-plugin/dj-booking-plugin/*.php` and CSS/JS
- Static HTML: edit `export/` files
- Original PHP: edit `.php` files in root and `process.php`/`confirm.php`

### Rebuild Plugin ZIP
```bash
# On Windows (PowerShell):
Compress-Archive -Path "wordpress-plugin\dj-booking-plugin\*" -DestinationPath "wordpress-plugin\dj-booking-plugin.zip" -Force
```

## 📊 Admin Features (WordPress)

### Dashboard
- WP Admin → DJ Bookings: view all submissions
- Search by name or email
- Pagination: 20 rows per page
- Sort by created date

### Export
- Click "Export CSV" to download matching results
- CSV includes: ID, Token, Name, Email, Phone, Event Date/Time, Verified, Created

## 🔒 Security

- All form inputs sanitized and validated
- Nonces used for AJAX requests
- Email verification prevents spam
- SQL queries use prepared statements
- CSV export requires admin permissions

## ⚡ Performance

- Lightweight plugin (~50KB unpacked)
- Static HTML optimized for fast loading
- Responsive images and lazy-loaded video
- Minimal JavaScript dependencies

## 📞 Support

For issues:
1. Check `wp-content/debug.log` (enable WP_DEBUG in wp-config.php)
2. Verify email settings (WP Mail SMTP or SMTP config)
3. Check database: `wp_dj_booking_requests` table exists and readable
4. Test form submission locally first

## 📝 License

All code in this repository is proprietary and created for DJ Haitian Mike.

## 🤝 Contributing

For updates, make changes locally and push to GitHub:
```bash
git add .
git commit -m "Your message here"
git push origin main
```

---

**Last updated:** December 25, 2025  
**Version:** 1.0.0
