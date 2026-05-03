# STAGE 1: Ini tidak akan jalan ulang selama package.json & kode tetap sama
FROM node:24-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --legacy-peer-deps
COPY . .
RUN npm run build

# STAGE 2: Jika Anda hanya utak-atik konfigurasi Nginx di sini, 
# Stage 1 (npm install & build) TIDAK AKAN dijalankan ulang.
FROM nginx:alpine
# Contoh perubahan: Menambah log atau tuning worker
RUN sed -i 's/worker_processes  1/worker_processes  auto/' /etc/nginx/nginx.conf 
COPY --from=builder /app/out /usr/share/nginx/html