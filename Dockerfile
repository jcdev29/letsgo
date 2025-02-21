# Build Stage
FROM golang:1.23.6 AS build

WORKDIR /app

# Copy Go modules and download dependencies
COPY go.mod go.sum ./
RUN go mod download

# Copy the remaining source code
COPY . .

# Build the Go application
RUN go build -o /main

# Deployment Stage (lightweight image)
FROM alpine:latest

WORKDIR /root/

# Install necessary runtime dependencies
RUN apk --no-cache add ca-certificates

# Copy compiled binary from build stage
COPY --from=build /main .

# Ensure the binary is executable
RUN chmod +x /main

# Expose API port
EXPOSE 8080

# Start the API
CMD ["/main"]
