# Reason :
- Load - balancer 
- Https/Tls

# Terminology

context {
    directive value;
} 

# Installation

sudo apt update && sudo apt upgrade
sudo apt install nginx -y


# deploy 

sudo systemctl start/enable nginx
sudo journalctl -u nginx

# test 

http://<address>

# configuration 

## configuration : 

go to ```/etc/nginx/nginx.conf```

## minimal : 

```
http{
    
  server {
          listen 8080;
        # path containing the files to server
           root /vagrant/tetris;
  }

}

events{

}
```

## MIME type
without this : every file will be loaded as text/plain (ex: CSS)


## Location 
for sub paths

## redirects / rewrites
