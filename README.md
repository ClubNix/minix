install java 17 for basic servers
```bash
apt install openjdk-17-jdk
```

create minecraft directory
```bash
mkdir -p /opt/minecraft
```

create minecraft user
```bash
useradd minecraft -d /opt/minecraft -s /bin/bash -p <password>
```

put service in /etc/systemd/system

```bash
cp minecraft@.service /etc/systemd/system
systemctl daemon-reload
```

download mcrcon [here](https://github.com/Tiiffi/mcrcon/releases/download/v0.7.2/mcrcon-0.7.2-linux-x86-64.tar.gz)

```bash
cd /opt/minecraft
mkdir bin
cd bin
wget https://github.com/Tiiffi/mcrcon/releases/download/v0.7.2/mcrcon-0.7.2-linux-x86-64.tar.gz
tar -xvf mcrcon-0.7.2-linux-x86-64.tar.gz
rm LICENSE
```

put `manage.sh` in `/opt/minecraft/bin`

don't forget to make it executable

```bash
chmod +x /opt/minecraft/bin/manage.sh
```

create a new folder in `/opt/minecraft` with the name of your server

put server.conf.template as `server.conf` in the folder you just created and edit it

put your server jar/server files in the folder you just created

don't forget to put a link to java bin in the server folder

```bash
ln -s /usr/bin/java /opt/minecraft/<server_name>/java
```
or
```bash
ln -s /opt/minecraft/<server_name>/jdk... /opt/minecraft/<server_name>/java
```
if jdk included with the server

after the first launch of your server, don't forget to edit MCRCON port/password in `server.properties`

change the flag in `eula.txt ` to true after the first launch

to start the server

```bash
systemctl start minecraft@<server_name>
```

to stop the server

```bash
systemctl stop minecraft@<server_name>
```

to restart the server

```bash
systemctl restart minecraft@<server_name>
```

to check the server status

```bash
systemctl status minecraft@<server_name>
```

to check the server logs

```bash
journalctl -xefu minecraft@<server_name>
```

you can use `mcrcon` bin to send command to the server

to auto start the server on boot

```bash
systemctl enable minecraft@<server_name>
```

if you want to add custom java flags that are recommanded, here's some of them

```
JAVA_OPTIONS= -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=40 -XX:G1MaxNewSizePercent=50 -XX:G1HeapRegionSize=16M -XX:G1ReservePercent=15 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=20 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true
```
