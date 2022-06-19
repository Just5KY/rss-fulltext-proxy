FROM node:alpine AS builder

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build
RUN rm -Rf node_modules/

# Production
FROM node:alpine

COPY --from=builder /app/dist /app/dist
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

ENV NODE_ENV=production

CMD [ "node", "dist/server.js" ]