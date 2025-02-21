# Build Stage
FROM golang:1.23-alpine AS builder
WORKDIR /app
# Install build dependencies
RUN apk add --no-cache gcc musl-dev
# Copy go.mod and go.sum first
COPY go.mod go.sum ./
RUN go mod download
# Copy the rest of the source code
COPY . .
# Build the application
RUN CGO_ENABLED=0 GOOS=linux go build -o main .

# Final Stage
FROM alpine:latest
WORKDIR /app
# Install runtime dependencies
RUN apk --no-cache add ca-certificates
# Copy the binary from builder
COPY --from=builder /app/main .
# Make binary executable
RUN chmod +x main
# Expose port
EXPOSE 8080
# Run the binary
CMD ["./main"]