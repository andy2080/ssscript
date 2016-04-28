# SSScript
---
##init the vps with manyuser（just for fun）

### Include Installation
* manyuser
* speedtest
* Speedserver(thanks for Zero Clover to provide it for free)

### Exclude Installation
* Mysql **(it means that the script is used to link remote database by default)**

### Run It
* ```wget https://raw.githubusercontent.com/VoganWong/ssscript/master/ssinit.sh```
* ```chmod +x ssinit.sh```(with super right)
* ```./ssinit.sh```

### Input Database
* Mysql Host
* Mysql User
* Mysql Password
* Mysql Port
* Mysql Database

### manyuser Path
* Config.py => shadowsocks/shadowsocks/Config.py
* Server.py => shadowsocks/shadowsocks/server.py

### Start manyuser
* if you run the script to the end, and set starting manyuser, the manyuser will be putted into system service
* you can use ```service ssstart``` to start the ss
* but it has been setted to start with system starting by default
