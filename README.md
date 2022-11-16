# breader aws ecr 

```
# before push 
$ aws configure
$ rm ~/.docker/config.json

$ docker build -t breader .
$ docker tag breader:latest <AWS_ACCOUNT_ID>.dkr.ecr.<REGION>.amazonaws.com/breader:latest
$ docker push <AWS_ACCOUNT_ID>.dkr.ecr.<REGION>.amazonaws.com/breader:latest
```
