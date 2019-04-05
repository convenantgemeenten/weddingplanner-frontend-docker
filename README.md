# Weddingplanner frontend docker
## About
First README for docker image

## Instructions
Build with ```docker build  --network=host --no-cache=true -t weddingplanner-frontend-docker .```
Run with ```docker run -d -v /home/your_dev_directory:/var/www/html -p 80:80 --name weddingplanner-frontend weddingplanner-frontend-docker```

You should be able to connect localhost:80 and see something running.
