# Envault docker image

[Envault GitHub 🚀](https://github.com/envault/envault)

## Testing image locally
### Starting docker services
Start dependency services:
```bash
docker-compose up db mailhog
```

Wipe mysql db:
```bash
docker-compose up -V db
```

Start envault:
```bash
docker-compose up envault
```

### Accessing the services
- Envault: http://localhost:8000/
- Mailhog: http://localhost:8025/