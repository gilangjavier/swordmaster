FROM golang:1.16-alpine AS builder

WORKDIR /src
COPY . .
RUN go mod tidy
RUN CGO_ENABLED=0 GOOS=linux go build -o /app .

FROM alpine:3.14
COPY --from=builder /app /app
ENTRYPOINT ["/app"]
