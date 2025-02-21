# Build stage
FROM golang:1.23.6 AS build

WORKDIR /app

# Copy source code
COPY . .

# Download dependencies and build the application with static linking
RUN go mod tidy && go build -o main -tags 'osusergo netgo' -ldflags '-extldflags "-static"'

# Runtime stage (Alpine-based)
FROM alpine:latest

WORKDIR /root/

# Install required certificates and libc compatibility
RUN apk --no-cache add ca-certificates libc6-compat

# Copy the compiled binary from the build stage
COPY --from=build /app/main .

# Ensure the binary is executable
RUN chmod +x main

# Expose the API port
EXPOSE 8080

# Run the API server
CMD ["./main"]
