FROM alpine:3.22

RUN apk add --no-cache bash mariadb-client


WORKDIR /app

COPY netwatch.sh .
COPY test.sh .

RUN chmod +x netwatch.sh test.sh

CMD ["./netwatch.sh"]
