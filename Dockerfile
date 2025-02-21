# Build Stage
FROM golang:1.23 AS build
WORKDIR /app
# Copy go.mod and go.sum to download dependencies
COPY go.mod go.sum ./
RUN go mod download
# Copy the rest of the source code
COPY . .
# Build the Go application with static linking
RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o main .

# Deployment Stage
FROM alpine:latest
WORKDIR /app  # Changed from /root for better security practices
# Install necessary runtime dependencies
RUN apk --no-cache add ca-certificates
# Create a non-root user
RUN adduser -D appuser
# Copy compiled binary from the build stage
COPY --from=build /app/main .
# Ensure the binary is executable and owned by appuser
RUN chown appuser:appuser main && chmod +x main
# Switch to non-root user
USER appuser
# Expose API port
EXPOSE 8080
# Set environment variables
ENV GIN_MODE=release
# Start the API
CMD ["./main"]