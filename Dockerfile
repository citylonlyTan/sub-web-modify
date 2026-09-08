FROM node:18-alpine AS build

# 1. 安装 Alpine 编译依赖（防止 node-gyp 或原生模块编译失败）
RUN apk add --no-cache python3 make g++

WORKDIR /app

# 2. 复制项目依赖说明文件
COPY package*.json yarn.lock ./

# 3. 设置 Yarn 网络超时时间并安装依赖（增加容错）
RUN yarn config set network-timeout 600000 -g && \
    yarn install --network-timeout 600000

# 4. 复制其余源码并进行前端编译
COPY . .
RUN yarn build

# 5. 生产环境 Nginx
FROM nginx:1.24-alpine
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
