FROM python:3.11-alpine as dev

WORKDIR /app

COPY . /app

# Install dependencies
RUN pip install -r requirements.txt


ENTRYPOINT [ "mkdocs", "serve", "--dev-addr", "0.0.0.0:8000" ]

FROM python:3.11-alpine as builder

# Set the working directory
WORKDIR /app

# Copy the source code
COPY --from=dev /app /app

# Install dependencies
RUN pip install -r requirements.txt

# Build the app
RUN mkdocs build


# Stage 2: Serve the app
FROM nginx:alpine as prod

# Copy the app from the builder stage
COPY --from=builder /app/site /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]