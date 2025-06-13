# Use official Nginx base image
FROM nginx:alpine

# Remove default nginx static content
RUN rm -rf /usr/share/nginx/html/*

# Copy your styled HTML to nginx public directory
COPY index.html /usr/share/nginx/html/

# Expose port 80 (Nginx default)
EXPOSE 80

# Start Nginx (CMD is inherited from nginx:alpine)
