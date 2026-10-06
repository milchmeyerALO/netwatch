FROM alpine:3.22

RUN apk add --no-cache bash

WORKDIR /app

COPY HelloWorld.sh .

RUN chmod +x HelloWorld.sh

CMD ["./HelloWorld.sh"]
