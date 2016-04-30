#!/bin/sh

# author@https://github.com/VoganWong

function fInstallGit() {
    #install git
    yum -y install git
    echo -e "\033[44;37;5m ####  git have been installed  #### \033[0m "
    sleep 3
}

function fInstallPip() {
    # install pip
    wget -q http://peak.telecommunity.com/dist/ez_setup.py
    python ez_setup.py
    easy_install pip
    rm -f ez_setup.py*
    echo -e "\033[44;37;5m ####  pip have been installed  #### \033[0m "
    sleep 3
}

function fInstallDependency() {
    pip install cymysql
    yum install -y m2crypto
    echo -e "\033[44;37;5m ####  manyuser Dependency have been installed  #### \033[0m "
    sleep 3
}

function fInstallManyuser() {
    # git clone manyuser
    git clone -b manyuser https://github.com/VoganWong/shadowsocks.git
    echo -e "\033[44;37;5m ####  manyusr have been downloaded  #### \033[0m "
    sleep 3
}

function fInstallVirtWhat() {
    # what's virt of your vps
    yum -y install virt-what
    virt-what
    vps=$(virt-what)
    echo -e "\033[44;37;5m ####  virt-what have been installed  #### \033[0m "
    sleep 3
}

function fInstallServerSpeeder() {
    if [ $vps == 'openvz' ]
    then
        echo -e "\033[41;37m ####  your vps is not available to install serverSpeeder  #### \033[0m "
        echo 'exiting install serverSpeeder...'
        sleep 3
        return
    else
        echo -e "\033[44;37;5m ####  your vps is available to install serverSpeeder  #### \033[0m "
        sleep 3

        # install expect
        yum -y install expect

        # install serverSpeeder
        cd ~
        MAC=$(cat /sys/class/net/eth0/address)
        KERNEL=$(cat /etc/redhat-release)

        chattr -i /serverspeeder/etc/apx-20341231.lic
        rm -rf /appex /serverspeeder

        wget --no-check-certificate https://www.seryox.com/serverSpeeder/CentOS/6.x/CentOS_6.6-2.6.32-573.1.1.el6.x86_64.gz
        tar xvzf CentOS_6.6-2.6.32-573.1.1.el6.x86_64.gz
        rm -f CentOS_6.6-2.6.32-573.1.1.el6.x86_64.gz

        cd server*/apx*/etc
        rm -f apx-20341231.lic
        wget -O apx-20341231.lic "http://pubilc.download.seryox.com/lot.php?mac=${MAC}&year=2038&bw=204800"
        cd ../..
        wget --no-check-certificate -O serverSpeeder.sh "https://www.seryox.com/shell/.serverSpeeder.sh"
        chmod +x serverSpeeder.sh
        chmod +x install.sh
        ./serverSpeeder.sh
        # chattr +i /serverspeeder/etc/apx-20341231.lic
        cd ~
        rm -rf serverSpeeder*
        echo -e "\033[44;37;5m ####  serverSpeeder have been installed  #### \033[0m "
        sleep 3
        service serverSpeeder start
        service serverSpeeder status
    fi
}

function fStopIptables() {
    # stop iptables
    echo -e "\033[44;37;5m ####  stop vps's iptables  #### \033[0m "
    service iptables stop
    sleep 3
}

function fInstallSpeedtest() {
    # install speedtest-cli.py
    echo -e "\033[44;37;5m ####  test your vps's speed  #### \033[0m "
    sleep 3
    wget --no-check-certificate -O speedtest-cli.py https://raw.github.com/sivel/speedtest-cli/master/speedtest_cli.py
    chmod +x speedtest*
    ./speedtest-cli.py
    sleep 3
}


function fModifyConfig() {
    echo -e "\r\033[44;37;5m ####  write the config of manyusr #### \033[0m \r\r"
    echo -e -n "input  ""\033[42;37m MYSQL_HOST \033[0m"" :"
    read MYSQL_HOST
    echo -e -n "input  ""\033[42;37m MYSQL_PORT \033[0m"" :"
    read MYSQL_PORT
    echo -e -n "input  ""\033[42;37m MYSQL_USER \033[0m"" :"
    read MYSQL_USER
    echo -e -n "input  ""\033[42;37m MYSQL_PASS \033[0m"" :"
    read MYSQL_PASS
    echo -e -n "input  ""\033[42;37m MYSQL_DB \033[0m"" :"
    read MYSQL_DB
    echo -e "Your config is : \r"
    echo -e "\033[47;30m $MYSQL_HOST \033[0m"
    echo -e "\033[47;30m $MYSQL_PORT \033[0m"
    echo -e "\033[47;30m $MYSQL_USER \033[0m"
    echo -e "\033[47;30m $MYSQL_PASS \033[0m"
    echo -e "\033[47;30m $MYSQL_DB \033[0m"
}

function fSetManyuser() {
    echo -e -n "\033[44;37;5m ####  Do you want to modify the manyuser config?(y/n) #### \033[0m"
    read confirm
    if [ "$confirm"x = "y"x ]; then
        file="shadowsocks/shadowsocks/Config.py"
        if [ ! -r $file ]; then
            echo -e "\033[41;37m #### Abort! can not find the Config.py!!!  #### \033[0m "
            sleep 3
            return
        fi
        fModifyConfig
        echo -n "Are you sure(y/n): "
        read confirm
        if [ "$confirm"x = "y"x ]; then
            sed -i "s/mdss.mengsky.net/$MYSQL_HOST/g" $file
            sed -i "s/3306/$MYSQL_PORT/g" $file
            sed -i "s/ss/$MYSQL_USER/g" $file
            sed -i "s/ss/$MYSQL_PASS/g" $file
            sed -i "s/shadowsocks/$MYSQL_DB/g" $file
            echo "write the config successfully!"
            sleep 3
        else
            fSetManyuser
        fi
    fi
}


function fSetService() {
    echo -n "\033[44;37;5m #### Do you want to put manyuser into system service? (y/n): #### \033[0m"
    read confirm
    if [ "$confirm"x = "y"x ]; then
        # set ss as a service of system
        touch ssstart.sh
        chmod +x ssstart.sh
        echo -e '#chkconfig: 35 24 25\n#description: start the shadowsocks\nservice iptables stop\ncd /root/shadowsocks/shadowsocks\nnohup python server.py >& /dev/null &' > ssstart.sh
        cp ssstart.sh /etc/init.d/ssstart -f
        chkconfig --add ssstart
        nohup service ssstart >& /dev/null &
        rm -f ssstart.sh
    else
        return
    fi
}

cd ~
echo -e "          ###     ###     ###                #             #"
echo -e "         #   #   #   #   #   #                            #"
echo -e "        #       #       #        ##   # ##  #    ####   ####"
echo -e "         ###     ###     ###    #  #  ##    #    #   #   #"
echo -e "            #       #       #  #      #     #    #   #   #"
echo -e "       #    #  #    #  #    #  #      #     #    #   #   #"
echo -e "       #   #   #   #   #   #   #  #   #     #    #  #    #"
echo -e "        ###     ###     ###     ##   #     #    ###       ##"
echo -e "                                                #"
echo -e "                                                #"
sleep 3

fInstallGit
fInstallPip
fInstallDependency
fInstallManyuser
fInstallVirtWhat
fInstallServerSpeeder
fStopIptables
fInstallSpeedtest
fSetManyuser
fSetService

echo -n "\033[44;37;5m #### Everything is OK. Enjoy it! #### \033[0m"
sleep 3
exit 0
