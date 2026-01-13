# Stage 1: Build Stage
FROM node:22-alpine AS builder

# Set Working Directory
WORKDIR /app

# Copy Package.json and lock files
COPY package.json yarn.lock ./

# Install dependencies
RUN yarn install --frozen-lockfile

# Copy the rest of the application, including TypeScript files
COPY . .

# Build the Next.js application
RUN yarn build

# Stage 2: Production Stage
FROM node:22-alpine AS runner

# Create a non-root user and group
RUN addgroup -S nodejs && adduser -S nodejs -G nodejs

# Set environment variables
ENV NODE_ENV=production
ENV PORT=3000

# Set Working Directory
WORKDIR /app

# Copy only the necessary files from the build stage
COPY --from=builder /app/public ./public
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json

# Change ownership of the application files
RUN chown -R nodejs:nodejs /app

# Switch to the non-root user
USER nodejs

# Expose application port
EXPOSE 3000

# Start the Next.js application
CMD ["yarn", "start"]
