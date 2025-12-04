FROM oven/bun:1.3.3-slim

WORKDIR /app

# Copy only necessary files
COPY .env ./
COPY src/ ./src/
COPY package.json bun.lockb ./

RUN bun install

EXPOSE 4321

CMD ["bun", "run", "src/index.ts"]