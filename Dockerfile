# Use the official Go image to build the app
FROM golang:1.23.6 AS build

WORKDIR /app

# Copy everything into the container
COPY . .

# Download dependencies and build the application
RUN go mod tidy && go build -o main .

# Use a lightweight Alpine image to run the app
FROM alpine:latest

WORKDIR /root/

# Install required certificates
RUN apk --no-cache add ca-certificates

# Copy the compiled binary from the build stage
COPY --from=build /app/main .

# Ensure the binary has execute permissions
RUN chmod +x main

# Expose API port
EXPOSE 8080

# Run the API server
CMD ["./main"]
