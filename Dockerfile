# -------- Stage 1: Build --------
FROM node:24-alpine AS builder

# Create app directory
WORKDIR /app

# Copy package files first (for caching)
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy source code
COPY . .

# (Optional) Build step (for React / TypeScript etc.)
# RUN npm run build


# -------- Stage 2: Production --------
FROM node:24-alpine

# Create a non-root user and group
RUN addgroup -S appgroup && adduser -S appuser -G appgroup

# Set working directory
WORKDIR /app

# Copy only necessary files from builder
COPY --from=builder /app ./

# Change ownership to non-root user
RUN chown -R appuser:appgroup /app

# Switch to non-root user
USER appuser

# Expose port
EXPOSE 3000

# Start app
ENTRYPOINT ["node", "index.js"] 