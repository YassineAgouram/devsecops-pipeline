# Dockerfile - Node.js simple
FROM node:18-alpine

WORKDIR /app

# copy package.json first for cache
COPY package*.json ./

RUN npm ci --only=production

COPY . .

# build step if app needs it (optional)
RUN if [ -f package.json ] && grep -q "\"build\":" package.json; then npm run build || true; fi

EXPOSE 3000

CMD ["node", "server.js"]
