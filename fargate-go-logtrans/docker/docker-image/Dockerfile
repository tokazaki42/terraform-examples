FROM golang:1.14-alpine3.12
#RUN apk add bash ca-certificates git gcc g++ libc-dev
RUN apk add git
RUN  go get -u github.com/gin-gonic/gin

RUN mkdir /app 
ADD . /app/ 
WORKDIR /app 
RUN go build -v
RUN ls

EXPOSE 8080
#CMD ["go", "run", "main.go"]
ENTRYPOINT ["/app/app"]
