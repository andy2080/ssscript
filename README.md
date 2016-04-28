# SSScript
---
##init the vps with manyuser（just for fun）

### Include Installation
* manyuser
* speedtest
* Speedserver

### Exclude Installation
* Mysql

### Run
* ```wget https://raw.githubusercontent.com/VoganWong/ssscript/master/ssinit.sh```
* ```chmod +x ssinit.sh```(with super right)
* ```./ssinit.sh```

### Input
* Mysql Host
* Mysql User
* Mysql Password
* Mysql Port
* Mysql Database

### Start manyuser
* if you run the script to the end, and set starting manyuser, the manyuser will be putted into system service
* you can use ```service ssstart``` to start the ss
* but it has been setted to start with system starting by default



