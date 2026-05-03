# Stage 1: Build React App
FROM node:24-alpine AS builder

# Set working directory
WORKDIR /app

# Copy package files dulu (biar cache optimal)
COPY package*.json ./

# Install dependencies
RUN npm install --legacy-peer-deps

# Copy semua source code
COPY . .

# Build app
RUN npm run build


# Stage 2: Serve pakai Nginx
FROM nginx:alpine

# Hapus default nginx config
RUN rm -rf /usr/share/nginx/html/*

# Copy hasil build ke nginx
COPY --from=builder /app/.next /usr/share/nginx/html

# Expose port
EXPOSE 80

# Run nginx
CMD ["nginx", "-g", "daemon off;"]