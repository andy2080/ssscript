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
* ```source ssinit.sh```(must run via 'source')

### Input Database
* Mysql Host
* Mysql User
* Mysql Password
* Mysql Port
* Mysql Database
* Mysql TABLE

### manyuser Path
* Config.py => shadowsocks/shadowsocks/Config.py
* Server.py => shadowsocks/shadowsocks/server.py

### Usage
* ssscript {start|stop|restart|status}
