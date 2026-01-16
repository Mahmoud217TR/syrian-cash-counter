FROM nginx:alpine

# Remove nginx default files
RUN rm -rf /usr/share/nginx/html/*

# Copy Vue build output ONLY
COPY dist/ /usr/share/nginx/html/

# SPA routing
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
