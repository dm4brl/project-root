# Use a base image that's suitable for your microservice
FROM golang:1.16

# Set the working directory inside the container
WORKDIR /app

# Copy all necessary files, including source code, into the container
COPY . .

# Build your microservice (replace with commands appropriate for your application)
RUN go build -o service1

# Install any required dependencies if applicable

# Define the port that your microservice will listen on
EXPOSE 8080

# Start your microservice
CMD ["./service1"]
