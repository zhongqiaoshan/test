# 使用 Node.js 16 作为基础镜像
FROM node:16

# 将当前工作目录设置为/app
WORKDIR /app

# 拷贝依赖声明
COPY package.json pnpm-lock.yaml /app/
RUN --mount=type=cache,id=pnpm,target=/pnpm/store pnpm install

# 运行 npm install 安装依赖
RUN npm install

# 将源代码复制到 /app 目录下
COPY . .

# 打包构建
RUN npm run build

# 将构建后的代码复制到 nginx 镜像中
FROM nginx:latest
COPY --from=build /app/dist /usr/share/nginx/html

# 暴露容器的 8080 端口
EXPOSE 80

# 启动 nginx 服务
CMD ["nginx", "-g", "daemon off;"]
