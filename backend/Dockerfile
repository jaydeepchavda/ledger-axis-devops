# Node.js 24 - matches the project's engines requirement
FROM node:24-alpine

# Application working directory
WORKDIR /app

# Copy dependency manifests first.
# This allows Docker to cache npm install when application code changes.
COPY package*.json ./

# Install production dependencies
RUN npm ci --omit=dev

# Copy application source and required runtime files
COPY . .

# Run the application as the non-root node user
RUN chown -R node:node /app
USER node

# Application listens on port 4000
EXPOSE 4000

# Start the production application
CMD ["node", "src/server.js"]