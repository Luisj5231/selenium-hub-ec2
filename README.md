# selenium-hub-ec2

This repo contains the necessary files and instructions for deploying an EC2 Instance with public IP using Terrafrom running a containerized Selenium Grid.

## Requirements
- Terraform v1.3.7
- An AWS Profile configured in the host were the files are going to be executed. ***(The AWS Profile must have permissions in order to create the resources definied on the file main.tf.)***

## Deployment

Initialize Terraform:
```bash
$ terraform init
```
Save the plan into a file:
```bash
$ terraform plan -out=selenium-hub.tfplan
```
Approve the plan:
```bash
$ terraform apply -auto-approve selenium-hub.tfplan
```

### Once the instance is ready, connect it through ssh and run the next commands in order to deploy a Selenium Grid with 4 chrome nodes:

```bash
$ podman network create --subnet=172.18.0.0/16 grid

$ podman run -d --net grid --ip 172.18.0.22 \
                   -p 4442-4444:4442-4444 \
                      --name selenium-hub \
      docker.io/selenium/hub:4.7.2-20221219

$ podman run -d --net grid --shm-size="2g" \
	-e SE_EVENT_BUS_HOST=172.18.0.22 \
	-e SE_EVENT_BUS_PUBLISH_PORT=4442 \
	-e SE_EVENT_BUS_SUBSCRIBE_PORT=4443 \
	docker.io/selenium/node-chrome:4.7.2-20221219
  
$ podman run -d --net grid --shm-size="2g" \
	-e SE_EVENT_BUS_HOST=172.18.0.22 \
	-e SE_EVENT_BUS_PUBLISH_PORT=4442 \
	-e SE_EVENT_BUS_SUBSCRIBE_PORT=4443 \
	docker.io/selenium/node-chrome:4.7.2-20221219
  
$ podman run -d --net grid --shm-size="2g" \
	-e SE_EVENT_BUS_HOST=172.18.0.22 \
	-e SE_EVENT_BUS_PUBLISH_PORT=4442 \
	-e SE_EVENT_BUS_SUBSCRIBE_PORT=4443 \
	docker.io/selenium/node-chrome:4.7.2-20221219
  
$ podman run -d --net grid --shm-size="2g" \
	-e SE_EVENT_BUS_HOST=172.18.0.22 \
	-e SE_EVENT_BUS_PUBLISH_PORT=4442 \
	-e SE_EVENT_BUS_SUBSCRIBE_PORT=4443 \
	docker.io/selenium/node-chrome:4.7.2-20221219
```

## Notes
TODO. 
