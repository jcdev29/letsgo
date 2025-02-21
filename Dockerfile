# Build Stage
FROM golang:1.23 AS build 

WORKDIR /app

# Copy go.mod and go.sum to download dependencies
COPY go.mod go.sum ./
RUN go mod download

# Copy the rest of the source code
COPY . .

# Build the Go application
RUN go build -o main .

# Deployment Stage (lightweight image)
FROM alpine:latest

WORKDIR /root/

# Install necessary runtime dependencies
RUN apk --no-cache add ca-certificates

# Copy compiled binary from the build stage
COPY --from=build /app/main .

# Ensure the binary is executable
RUN chmod +x main

# Expose API port
EXPOSE 8080

# Start the API
CMD ["./main"]
