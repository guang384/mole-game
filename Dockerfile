FROM nginx:alpine

COPY --chown=nginx:nginx index.html /usr/share/nginx/html/

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
