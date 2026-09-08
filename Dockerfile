FROM node:18-alpine AS build

# 1. 安装基础编译依赖
RUN apk add --no-cache python3 make g++

WORKDIR /app

# 2. 复制项目所有文件
COPY . .

# 3. 设置网络超时、安装依赖并编译
RUN yarn config set network-timeout 600000 -g && \
    yarn install --network-timeout 600000 && \
    yarn build

# 4. 生产环境 Nginx
FROM nginx:1.24-alpine
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
