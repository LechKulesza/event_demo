# Demo Server Deployment Checklist

## 🚨 CRITICAL ISSUES TO FIX BEFORE DEPLOYMENT

### 1. **Security: Admin Routes Unprotected**
**Problem**: Anyone can access `/participants/admin` and `/participants/scanner`
**Solution**: Add authentication or IP restriction

### 2. **URL Generation Issues**
**Problem**: Hardcoded localhost URLs in QR codes
**Solution**: Use proper host configuration

## 🔧 REQUIRED FIXES

### Fix 1: Add Basic Authentication for Admin Routes
```ruby
# In app/controllers/participants_controller.rb
class ParticipantsController < ApplicationController
  http_basic_authenticate_with name: ENV['ADMIN_USER'], password: ENV['ADMIN_PASSWORD'], 
    only: [:admin, :scanner, :process_scan]
```

### Fix 2: Fix QR Code URL Generation
```ruby
# In app/models/participant.rb
def qr_code_data
  Rails.application.routes.url_helpers.scan_participant_url(self, host: Rails.application.config.action_mailer.default_url_options[:host])
end
```

### Fix 3: Update Production Configuration
```ruby
# In config/environments/production.rb
config.action_mailer.default_url_options = { host: ENV['APP_HOST'] || "your-demo-server.com" }
config.hosts = [ENV['APP_HOST'] || "your-demo-server.com"]
```

## 📋 ENVIRONMENT VARIABLES NEEDED

```bash
# Database
EVENT_DEMO_DATABASE_PASSWORD=your_db_password

# Admin Authentication
ADMIN_USER=admin
ADMIN_PASSWORD=secure_password_here

# App Configuration
APP_HOST=your-demo-server.com
RAILS_MASTER_KEY=your_master_key

# Email (if using SMTP)
SMTP_USERNAME=your_email@domain.com
SMTP_PASSWORD=your_email_password
```

## ⚙️ DEPLOYMENT COMMANDS

```bash
# 1. Setup environment variables
export EVENT_DEMO_DATABASE_PASSWORD="your_password"
export ADMIN_USER="admin"
export ADMIN_PASSWORD="secure_password"
export APP_HOST="your-demo-server.com"

# 2. Setup database
rails db:create RAILS_ENV=production
rails db:migrate RAILS_ENV=production

# 3. Precompile assets
rails assets:precompile RAILS_ENV=production

# 4. Start server
rails server -e production
```

## 🛡️ SECURITY NOTES

- Admin panel is protected with HTTP Basic Auth
- QR codes contain proper server URLs
- SSL is forced in production
- No sensitive data in source code

## 🚀 CURRENT STATUS

- ✅ Database configuration ready
- ✅ Asset pipeline working
- ✅ Email templates created
- ❌ **Admin authentication missing**
- ❌ **URLs hardcoded to localhost**
- ❌ **Production host not configured**

## 📝 POST-DEPLOYMENT TODO

1. Test registration flow
2. Test email confirmation 
3. Test QR code generation
4. Test QR code scanning
5. Test admin panel access
6. Verify statistics accuracy

---

**⚠️ DO NOT DEPLOY WITHOUT FIXING THE CRITICAL ISSUES ABOVE**