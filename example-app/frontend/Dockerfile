FROM node:16-alpine

WORKDIR /usr/src/app

COPY . .

ENV REACT_APP_BACKEND_URL=http://localhost:8000/api

RUN npm install && \
    npm run build && \
    npm install -g serve

EXPOSE 5001

CMD ["serve", "-s", "-l", "5001", "build"]
