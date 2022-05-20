FROM node:alpine as builder
WORKDIR /app
COPY package.json .

COPY yarn.lock .
RUN yarn

COPY . .
RUN yarn build

FROM nginx:1.15.2-alpine

RUN rm -rf /etc/nginx/conf.d
COPY conf /etc/nginx

COPY --from=builder /app/build /usr/share/nginx/html/
EXPOSE 80

WORKDIR /usr/share/nginx/html
COPY ./env.sh .
COPY .env .

RUN chmod +x env.sh
CMD ["/bin/sh", "-c", "/usr/share/nginx/html/env.sh && nginx -g \"daemon off;\""]