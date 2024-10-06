put service in /etc/systemd/system

```bash
cp minecraft@.service /etc/systemd/system
systemctl daemon-reload
```

download mcrcon [here](https://github.com/Tiiffi/mcrcon/releases/download/v0.7.2/mcrcon-0.7.2-linux-x86-64.tar.gz)

```bash
cd /opt
mkdir minecraft
cd minecraft
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
