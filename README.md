# Accenture Community Meeting '25 - Event Registration App

A Ruby on Rails web application for managing event registrations for the Accenture Community Meeting '25. This is a one-page application featuring a navy blue and pink color scheme, participant registration with QR code generation, and attendance tracking.

## Features

### 🎯 Core Requirements
- **One-page design** with modern, responsive layout
- **Color scheme**: Navy blue and pink theme
- **Accenture logo placeholder** in the upper left
- **Event agenda display** with detailed schedule
- **Registration system** with email confirmation
- **QR code generation** for each participant
- **Attendance tracking** via QR code scanning
- **Statistics dashboard** showing registration and attendance rates

### 📋 Event Agenda
- **18:00-19:00** - Registration
- **19:00-19:30** - Official speech
- **19:30-20:00** - Contest
- **20:00-21:00** - Dinner with music
- **21:00-21:10** - Contest settlement
- **21:10-3:00** - Music and art part

### 🛠 Technical Features
- **Ruby on Rails 8.0.2** monolith architecture
- **PostgreSQL** database
- **QR code generation** using rqrcode gem
- **Email notifications** with HTML and text templates
- **Bootstrap 5** for responsive design
- **Real-time statistics** for event organizers

## Requirements

- Ruby 3.4.2+
- Rails 8.0.2+
- PostgreSQL
- Node.js (for asset compilation)

## Installation

1. **Clone the repository**
   ```bash
   git clone [repository-url]
   cd event_demo
   ```

2. **Install dependencies**
   ```bash
   bundle install
   ```

3. **Setup database**
   ```bash
   rails db:create
   rails db:migrate
   ```

4. **Start the server**
   ```bash
   rails server
   ```

5. **Visit the application**
   Open http://localhost:3000 in your browser

## Usage

### For Participants

1. **Registration**
   - Visit the homepage
   - Click "Zarejestruj się teraz" (Register now)
   - Fill in your name and email
   - Accept terms and conditions
   - Submit the form

2. **Email Confirmation**
   - Check your email for confirmation message
   - Click the confirmation link
   - Your QR code will be generated automatically

3. **Event Attendance**
   - Bring your QR code (digital or printed)
   - Present it at event registration
   - Code will be scanned for attendance tracking

### For Administrators

1. **Access Admin Panel**
   - Visit `/participants/admin`
   - View registration statistics
   - See all participants and their status
   - Manually confirm registrations if needed

2. **Statistics Available**
   - Total registrations
   - Confirmed registrations
   - Attendees (scanned QR codes)
   - Attendance percentage

## Models

### Participant
- `first_name` - Participant's first name
- `last_name` - Participant's last name
- `email` - Email address (unique)
- `confirmed` - Email confirmation status
- `qr_code` - Generated QR code (SVG format)
- `scanned_at` - Timestamp when QR code was scanned

## Key Routes

- `/` - Homepage with event information and registration button
- `/participants/new` - Registration form
- `/participants/:id` - Participant details and QR code
- `/participants/:id/scan` - QR code scanning endpoint
- `/participants/:id/confirm` - Email confirmation endpoint
- `/participants/admin` - Admin dashboard

## Email Configuration

The application sends confirmation emails. For development, emails are displayed in the Rails log. For production, configure your SMTP settings in `config/environments/production.rb`.

## Customization

### Logo Replacement
Replace the logo placeholder in `app/views/layouts/application.html.erb` with the actual Accenture logo.

### Event Details
Update event details (date, location, etc.) in:
- `app/views/participants/show.html.erb`
- Email templates in `app/views/participant_mailer/`

### Color Scheme
Modify CSS variables in `app/views/layouts/application.html.erb`:
```css
:root {
  --navy-blue: #1e293b;
  --pink: #ec4899;
  --light-pink: #f8fafc;
}
```

## Security Notes

- Email validation and uniqueness enforced
- QR codes contain unique identifiers (not sensitive data)
- CSRF protection enabled
- Input sanitization via Rails built-in protections

## Deployment

### Environment Variables
Copy `.env.example` to `.env` and configure:

```bash
cp .env.example .env
# Edit .env with your actual values
```

Required variables:
- `EVENT_DEMO_DATABASE_PASSWORD` - PostgreSQL password
- `ADMIN_USER` - Admin panel username
- `ADMIN_PASSWORD` - Admin panel password  
- `APP_HOST` - Your server domain (e.g., demo.yoursite.com)

### Production Setup

1. **Environment Variables**
   ```bash
   export EVENT_DEMO_DATABASE_PASSWORD="secure_password"
   export ADMIN_USER="admin"
   export ADMIN_PASSWORD="secure_admin_password"
   export APP_HOST="your-demo-server.com"
   ```

2. **Database Setup**
   ```bash
   rails db:create RAILS_ENV=production
   rails db:migrate RAILS_ENV=production
   ```

3. **Asset Precompilation**
   ```bash
   rails assets:precompile RAILS_ENV=production
   ```

4. **Start Production Server**
   ```bash
   rails server -e production -p 3000
   ```

### Security Notes

- Admin panel (`/participants/admin`) is protected with HTTP Basic Authentication
- Scanner page (`/participants/scanner`) requires admin credentials
- All URLs are generated dynamically based on `APP_HOST` environment variable
- SSL is enforced in production environment

For detailed deployment instructions, see [DEPLOYMENT.md](DEPLOYMENT.md).

## License

This project is proprietary and intended for Accenture Community Meeting '25.

## Support

For technical support or questions about the application, contact the development team.

---

**Built with ❤️ using Ruby on Rails**
