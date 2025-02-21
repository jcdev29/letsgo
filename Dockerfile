# Use the official Golang image
FROM golang:1.21 AS build

# Set environment variables
ENV CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64

# Set the working directory inside the container
WORKDIR /app

# Copy everything from the project directory to the container
COPY . .

# Download dependencies and build the application
RUN go mod tidy && go build -o main .

# Use a lightweight image to run the application
FROM alpine:latest  

# Set the working directory inside the new container
WORKDIR /root/

# Copy the built binary from the previous stage
COPY --from=build /app/main .

# Expose port 8080
EXPOSE 8080

# Command to run the app
CMD ["./main"]
