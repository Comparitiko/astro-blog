FROM --platform=${BUILDPLATFORM} node:22-alpine AS builder
WORKDIR /usr/src/app
COPY . .
RUN yarn install
RUN yarn run build

FROM --platform=${BUILDPLATFORM} nginx:alpine AS static-prod
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf
COPY --from=builder /usr/src/app/dist /usr/share/nginx/html
EXPOSE 80

FROM --platform=${BUILDPLATFORM} node:22-alpine AS server-prod
WORKDIR /usr/src/app
COPY --from=builder /usr/src/app/dist /usr/src/app/dist