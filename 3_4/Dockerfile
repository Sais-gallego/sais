FROM docker:cli

WORKDIR /usr/src/app

RUN apk add --no-cache git bash

COPY builder.sh .

RUN chmod +x builder.sh

ENTRYPOINT ["./builder.sh"]
