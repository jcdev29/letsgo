# Use the official Go image for building
FROM golang:1.23 AS build

WORKDIR /app

# Copy everything into the container
COPY . .

# Ensure Go modules are set up correctly
RUN go mod tidy && go build -o main .

# Use a lightweight image to run the app
FROM alpine:latest

WORKDIR /root/

# Install necessary dependencies
RUN apk --no-cache add ca-certificates

# Copy the built binary from the build stage
COPY --from=build /app/main .

# Expose the API port
EXPOSE 8080

# Start the application
CMD ["./main"]

