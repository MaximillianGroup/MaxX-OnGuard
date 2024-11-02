# -htaccess
An .htaccess file that works



## Overview of domain.conf

This configuration file is designed to provide a secure and optimized Apache setup for a WordPress site.  It leverages SSL using Let's Encrypt certificates for secure HTTPS traffic and includes various security measures to protect the site from common vulnerabilities and attacks. 

## Contents

1. **Modules and Listeners**
2. **HTTP to HTTPS Redirection**
3. **HTTPS VirtualHost Configuration**
4. **SSL Certificates**
5. **SSL Security**
6. **WordPress Directory Permissions**
7. **Additional Security Settings**
8. **Optional Client Certificate Authentication**
9. **Logging**
10. **Deployment Notes**

## 1. Modules and Listeners

This section loads essential Apache modules and configures the server to listen on both HTTP (port 80) and HTTPS (port 443).

```apache
# Load necessary modules
LoadModule ssl_module modules/mod_ssl.so
LoadModule headers_module modules/mod_headers.so
LoadModule rewrite_module modules/mod_rewrite.so

# Listen on HTTP and HTTPS ports
Listen 80
Listen 443
```

## 2. HTTP to HTTPS Redirection
This section redirects all incoming HTTP traffic (port 80) to HTTPS, enforcing a secure connection for all users.

```apache
# HTTP VirtualHost to redirect all traffic to HTTPS
<VirtualHost *:80>
    ServerName sparxstar.com
    ServerAlias www.sparxstar.com

    # Redirect all HTTP requests to HTTPS
    RewriteEngine On
    RewriteRule ^/?(.*) https://%{SERVER_NAME}%{REQUEST_URI} [R=301,L]
</VirtualHost>
```
3. HTTPS VirtualHost Configuration
This is the primary VirtualHost, handling all HTTPS traffic on port 443. It includes the main website settings, SSL certificates, and security configurations.

```apache
# HTTPS VirtualHost with SSL configuration
<VirtualHost *:443>
    ServerName sparxstar.com
    ServerAlias www.sparxstar.com

    # Document root for the site
    DocumentRoot /var/www/html

    # Enable SSL engine
    SSLEngine on
```
## 4. SSL Certificates
This configuration uses Let's Encrypt certificates for secure HTTPS communication.

```apache
# SSL Certificates from Let's Encrypt
    SSLCertificateFile /etc/letsencrypt/live/sparxstar.com/fullchain.pem
    SSLCertificateKeyFile /etc/letsencrypt/live/sparxstar.com/privkey.pem
    SSLCertificateChainFile /etc/letsencrypt/live/sparxstar.com/chain.pem
```
## 5. SSL Security
This section enforces strong encryption, preferred cipher order, and enables OCSP stapling for enhanced SSL security.

```apache
# Strong Ciphers and Enforcing Cipher Order
    SSLCipherSuite HIGH:!aNULL:!MD5
    SSLHonorCipherOrder on

    # Enable OCSP Stapling
    SSLUseStapling On
    SSLStaplingCache "shmcb:/var/log/apache2/ssl_stapling(32768)"
```
## 6. WordPress Directory Permissions
This section defines the permissions for the WordPress directory (/var/www/html/wp-content) to enable .htaccess overrides and restrict access to certain files.

```apache
# Directory settings for WordPress root directory
    <Directory /var/www/html>
        # Allows .htaccess to handle Mod Rewrite and other rules
        AllowOverride All
        Require all granted
    </Directory>

    # Directory-level restrictions
    <Directory /var/www/html/wp-content>
        AllowOverride All
        Require all granted
    </Directory>
```
#3 7. Additional Security Settings
This section restricts script execution in the wp-content/uploads directory to prevent potential exploits.

```apache
# Restrict PHP, JS, and other script execution in uploads directory
    <Directory /var/www/html/wp-content/uploads>
        <FilesMatch "\.(php|js|cgi|as|pl|py|rb|sh)$">
           Require all denied
        </FilesMatch>
    </Directory>
```
## 8. Optional Client Certificate Authentication
Client certificate authentication can be enabled to add an additional security layer, ensuring only clients with valid certificates can access the site.

```
# Optional: Client Certificate Authentication
    # Uncomment the lines below to require a client certificate
    # SSLVerifyClient require
    # SSLVerifyDepth 1
    # SSLCACertificateFile /path/to/ca.crt
```
##  9. Logging
This section configures Apache to log SSL-related events and access logs, which are crucial for debugging and security monitoring.

```apache
# Logging for SSL
    ErrorLog ${APACHE_LOG_DIR}/error.log
    CustomLog ${APACHE_LOG_DIR}/access.log combined
</VirtualHost>
```
## 10. Deployment Notes
After configuring the Apache server, restart Apache to apply the changes:

```apache
sudo systemctl restart apache2
```
## Recommendations
- **CORS:** In production, configure Header add Access-Control-Allow-Origin to specific origins instead of using *.

- **wp-admin Authentication:** Uncomment and configure the wp-admin directory block if you want to use Basic Authentication for the WordPress admin area.

- **Test Thoroughly:** After making changes, test your website thoroughly to ensure everything is working as expected and no mixed content issues have been introduced.

*This configuration provides a robust foundation for a secure and optimized WordPress site. Remember to keep your SSL certificates up-to-date and monitor your Apache logs regularly for security incidents. Use Code with causion.*


