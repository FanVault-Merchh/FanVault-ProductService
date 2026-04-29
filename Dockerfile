FROM node:18-alpine AS deps

WORKDIR /app

RUN apk update && apk upgrade --no-cache && rm -rf /var/cache/apk/*

COPY package*.json ./

RUN npm install --omit=dev && npm cache clean --force

FROM node:18-alpine AS runtime

RUN apk update && apk upgrade --no-cache && rm -rf /var/cache/apk/*

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app

COPY --from=deps /app/node_modules ./node_modules

COPY --from=deps /app/package*.json ./

COPY src/ ./src/

RUN chown -R appuser:appgroup /app

USER appuser

EXPOSE 3003

CMD ["node", "src/index.js"]
