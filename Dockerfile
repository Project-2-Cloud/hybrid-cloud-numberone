# build stage
FROM node:lts-alpine as build-stage
WORKDIR /app
COPY package*.json ./
RUN npm cache clean --force
RUN npm install
COPY . .
RUN npm run build

# production stage
FROM nginx:1.17
COPY ./nginx.conf /etc/nginx/nginx.conf
WORKDIR /code
COPY --from=build-stage /app/dist .
EXPOSE 8000:8000
CMD ["nginx", "-g", "daemon off;"]