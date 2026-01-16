# -------- Build stage --------
FROM node:18-alpine AS build

ENV NODE_OPTIONS=--max-old-space-size=512

WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# -------- Runtime stage --------
FROM nginx:alpine

RUN rm -rf /usr/share/nginx/html/*
COPY dist/ /usr/share/nginx/html/
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
