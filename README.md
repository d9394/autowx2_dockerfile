# autowx2_dockerfile
a docker file to build a autowx2 system   

autowx2 is a collected program for receive NOAA,ISS,METEOR-M2,APRS infomation , it running by the time table to automate receive.   
autowx2 source code: https://github.com/filipsPL/autowx2   

build command:    
  docker build -t autowx2 -f ./dockerfile .  

suggest run docker command:     
there are 2 scenes :   
1, simple run for a look or test:   
  docker run -it --privileged -p 5050:5050 autowx2:latest      
  
2, run as your config and keep all received image\record:   
  docker run -it --privileged -p 5050:5050 -v /volume1/homes/docker/autowx2/config:/config -v /volume1/homes/docker/autowx2/recordings:/autowx2/var/www/recordings autowx2:latest    
  
after the docker image running, you can browse the result and log:    
   http://xx.xx.xx.xx:5050    
