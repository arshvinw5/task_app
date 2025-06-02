FROM oven/bun:1.1.7

WORKDIR /app

# Copy only package files first to leverage cache
COPY package.json tsconfig.json ./

RUN bun install

# Then copy the rest of your source code
COPY . .

EXPOSE 8000

CMD ["nodemon", "--legacy-watch"]