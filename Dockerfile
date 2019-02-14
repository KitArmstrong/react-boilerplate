# Base image
FROM node:10-alpine as base

WORKDIR /app

COPY package.json .

RUN npm install

COPY . .

# Development image
FROM base as development

EXPOSE 3000

ENTRYPOINT ["npm", "start"]

# Build image
FROM base as build

RUN npm run build

# Production image 
FROM nginx:alpine

COPY --from=build /app/build /usr/share/nginx/html

EXPOSE 80