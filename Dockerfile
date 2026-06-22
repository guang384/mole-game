# 使用 nginx:alpine 作为基础镜像（体积小、安全性高）
FROM nginx:alpine

# 将本地的 index.html 复制到容器内的 nginx 静态文件目录
# --chown=nginx:nginx 设置文件所有者为 nginx 用户和组
COPY --chown=nginx:nginx index.html /usr/share/nginx/html/

# 声明容器运行时监听的端口
EXPOSE 80

# 启动 nginx 并以前台模式运行（daemon off 确保容器不会立即退出）
CMD ["nginx", "-g", "daemon off;"]
