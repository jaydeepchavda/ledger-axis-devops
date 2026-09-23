# ============================================================
# STAGE 1: BUILD THE ANGULAR APPLICATION
# ============================================================

# Alpine is a small Linux distribution, so the resulting
# build environment is relatively lightweight.
FROM node:24-alpine AS build-stage

# All commands after this point run inside /app.
# This keeps the application files isolated from the
# rest of the container filesystem.
WORKDIR /app

# Copy only package files first.
#
# Why?
# Docker builds images layer by layer. If package.json and
# package-lock.json have not changed, Docker can reuse the
# npm dependency-installation layer on future builds.
COPY package*.json ./

# Install the exact dependencies from package-lock.json.
#
# npm ci is preferred for Docker/CI builds because it gives
# reproducible installations and does not modify package.json
# or package-lock.json.
RUN npm ci

# Now copy the application source code.
#
# This is intentionally after npm ci so that changing source
# code does not invalidate the dependency layer.
COPY . .

# Build the Angular application for production.
#
# The "build" script comes from package.json:
#     "build": "ng build"
#
# Angular generates the compiled static files under:
#     /app/dist/ledgeraxis-frontend
RUN npm run build


# ============================================================
# STAGE 2: SERVE THE ANGULAR APPLICATION WITH NGINX
# ============================================================

# The Angular application is already compiled.
# We do not need Node.js in the final runtime container.
#
# Nginx is used as the production web server to serve the
# generated HTML, JavaScript, CSS, and other static files.
FROM nginx:stable-alpine AS run-stage

# Copy the compiled Angular application from the build stage
# into Nginx's default web root.
#
# IMPORTANT:
# angular.json specifies:
#     outputPath: dist/ledgeraxis-frontend
#
# Therefore the source path MUST be:
#     /app/dist/ledgeraxis-frontend
COPY --from=build-stage /app/dist/ledgeraxis-frontend /usr/share/nginx/html

# Replace Nginx's default configuration with our own
# configuration.
#
# This configuration is important for Angular routing.
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Angular is served through HTTP.
# Nginx listens on port 80 inside the container.
EXPOSE 80

# Start Nginx in the foreground.
#
# Docker containers should have a foreground process.
# "daemon off;" prevents Nginx from going into the background,
# allowing Docker to keep the container running.
CMD ["nginx", "-g", "daemon off;"]