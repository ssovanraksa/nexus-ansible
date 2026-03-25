docker build -t local-ansible:latest .
docker run -d --name ansible1 -p 2222:22 -p 8443:443 -p 8080:8080 local-ansible:latest