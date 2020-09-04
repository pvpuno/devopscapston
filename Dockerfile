FROM node:10-alpine
WORKDIR /app
COPY . .
EXPOSE 3000
RUN yarn install
CMD ["node", "/app/src/index.js"]

### OjO esto corre en el puerto 3000 
### docker run -dp 3000:3000 docker-101
