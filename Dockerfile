FROM node:24-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN --mount=type=cache,target=/root/.npm \
    npm install --legacy-peer-deps
COPY . .
RUN npm run build


FROM nginx:alpine

RUN sed -i 's/worker_processes  1/worker_processes  auto/' /etc/nginx/nginx.conf 
COPY --from=builder /app/out /usr/share/nginx/html