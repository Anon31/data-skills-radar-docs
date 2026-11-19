FROM nginx:stable-alpine

# Nettoyage de la page par défaut de Nginx
RUN rm -rf /usr/share/nginx/html/*

# Copie de la documentation Docsify (index.html, _sidebar.md, README.md, docs/, assets/img/...)
COPY . /usr/share/nginx/html

# Configuration Nginx optimisée pour Docsify (Gzip sur Markdown + vraie 404 pour le fallback _sidebar.md)
RUN echo 'server { \
    listen 80; \
    gzip on; \
    gzip_types text/plain text/css text/markdown application/json application/javascript text/xml application/xml text/javascript image/svg+xml; \
    location / { \
        root /usr/share/nginx/html; \
        index index.html; \
        try_files $uri $uri/ =404; \
    } \
}' > /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]