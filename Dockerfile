FROM alpine:3.22

RUN apk add --no-cache bash

WORKDIR /app

COPY netwatch.sh .

RUN chmod +x netwatch.sh

CMD ["./netwatch.sh"]
