# Build Stage
FROM node:18 AS build

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

ENV NODE_OPTIONS=--openssl-legacy-provider

RUN npm run build

# Production Stage
FROM nginx:alpine

RUN apk update && apk upgrade

COPY --from=build /app/build /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
