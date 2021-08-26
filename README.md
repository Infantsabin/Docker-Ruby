# Docker-Ruby

## Note: 
You should add these files outside of your Ruby Repo. 

``` bash 
# create image
docker build -t ruby-post .

# create and run container
docker run -p 5432:5432 -d ruby-post --name ruby-postgres
```
