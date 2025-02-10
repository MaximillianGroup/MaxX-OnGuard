<Directory /var/www/html/>
        # Set In Mime Types
        <IfModule mod_mime.c>
            AddType application/x-javascript .js
            AddType text/css .css
        </IfModule>
        # ----------------------------------------------------------------------
        # ENCODINGS - Brotli / GZip 
        # ----------------------------------------------------------------------
        # # # 
        <Files *.html.br>
            AddType "text/html" .gz
            AddEncoding br .br
        </Files>
        <Files *.js.br>
            AddType "text/javascript" .br
            AddEncoding br .br
        </Files>
        <Files *.css.br>
            AddType "text/css" .br
            AddEncoding br .br
        </Files>
        <Files *.svg.br>
            AddType "image/svg+xml" .br
            AddEncoding br .br
        </Files>
        # ----------------------------------------------------------------------
        # COMPRESSION - Brotli / GZip 
        # ----------------------------------------------------------------------
        # # # Enable Brotli Compression # # # 
        <IfModule mod.rewrite.c>
            RewriteEngine On
            RewriteCond %{HTTP:Accept-Encoding} br
            RewriteCond %{REQUEST_FILENAME}.br -f
            RewriteRule ^(.*)$ $1.br [L]
        </Ifmodule>


  
        <IfModule mod_brotli.c>
            AddOutputFilterByType BROTLI_COMPRESS text/html text/plain text/xml text/css text/javascript application/javascript application/x-javascript application/json application/xml
            BrotliCompressionQuality 4
        </IfModule>
        # # # Enable GZip Compression # # # 
        <IfModule mod_deflate.c>
            AddOutputFilterByType DEFLATE text/css application/x-javascript text/x-component text/html text/plain text/xml application/javascript
            <IfModule mod_setenvif.c>
                BrowserMatch ^Mozilla/4 gzip-only-text/html
                BrowserMatch ^Mozilla/4.0[678] no-gzip
                BrowserMatch bMSIE !no-gzip !gzip-only-text/html
            </IfModule>
        </IfModule>
        Header append Vary User-Agent env=!dont-vary
</Directory>
