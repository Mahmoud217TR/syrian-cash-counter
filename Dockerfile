FROM nginx:alpine

# Remove default nginx config (CRITICAL)
RUN rm -f /etc/nginx/conf.d/default.conf

# Copy Vue build
COPY dist /usr/share/nginx/html

# Copy our nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
