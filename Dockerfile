FROM alpine:3.22

RUN apk add --no-cache bash

WORKDIR /app

COPY netwatch.sh .
COPY test.sh .

RUN chmod +x netwatch.sh test.sh

CMD ["./netwatch.sh"]
