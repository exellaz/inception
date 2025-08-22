FROM debian:bullseye

RUN apt-get update && apt-get install -y python3 && rm -rf /var/lib/apt/lists/*

WORKDIR /static-site
COPY . .

CMD ["python3", "-m", "http.server", "8000"]
