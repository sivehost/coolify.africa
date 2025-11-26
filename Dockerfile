##############################################
# BUILD STAGE
##############################################

FROM oven/bun:latest AS builder
WORKDIR /app

# Install dependencies
COPY package.json bun.lockb* bun.lock* ./
RUN bun install

# Build the Astro site
COPY . .
RUN bun run build


##############################################
# RUNTIME STAGE (NGINX)
##############################################

FROM nginx:alpine

# Replace default nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy built files
COPY --from=builder /app/dist /usr/share/nginx/html

# Fix permissions
RUN chown -R nginx:nginx /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
