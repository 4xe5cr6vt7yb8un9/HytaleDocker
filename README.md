
# Hytale Docker Server

## Setup

1. Create a `docker-compose.yml` file with the following configuration:

```yaml
services:
    hytale:
        image: px99/hytaleserver:latest
        restart: unless-stopped
        ports:
            - 5220:5220/udp
        volumes:
            - /home/hytale:/hytale
        stdin_open: true
        tty: true
networks: {}
```

2. Start the container:
```bash
docker-compose up -d
```

## Authentication

1. Check the logs for an authentication URL:
```bash
docker-compose logs hytale
```

2. Login into your Hytale account to allow the download of the server files

3. Attach to the container:
```bash
docker attach hytale
```

4. Run the following commands:
```
/auth login device
```

5. Follow the URL provided to authenticate the server.

6. Enable persistent authentication:
```
/auth persistence Encrypted
```
