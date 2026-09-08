FROM node:16-alpine AS build

WORKDIR /app

# 复制源码
COPY . .

# 使用 Node 16 并忽略老旧依赖的版本限制
RUN yarn config set network-timeout 600000 -g && \
    yarn install --ignore-engines && \
    yarn build

# 生产环境 Nginx
FROM nginx:1.24-alpine
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
