# How to run Open WebUI in VM using vmware fusion on Mac MX

## Install vmware using brew (since some time vmware allows peo option for pesonal use)
```
brew install --cask vmware-fusion
```

## Install te ubuntu server for ARM
## Login via ssh and install Docker stuff -> from https://docs.docker.com/engine/install/ubuntu/
```
# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
sudo chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
```

## Create docker-compose.yml to run Open WebUI (docker-compose is also in commited files)
```
mkdir open-webui && cd open-webui && \
cat <<EOF > docker-compose.yml
services:
  open-webui:
    image: ghcr.io/open-webui/open-webui:ollama
    container_name: open-webui
    restart: always
    ports:
      - "3000:8080"
    volumes:
      - ./Ollama:/root/.ollama
      - ./open-webui:/app/backend/data
EOF
```

## Run Open WebUI docker container on system start
* create service for systemd /etc/systemd/system/open-webui.service
    ```
    sudo bash -c 'cat <<EOF > /etc/systemd/system/open-webui.service
    [Unit]
    Description=Open WebUI Docker Compose Service
    After=network.target docker.service
    Requires=docker.service

    [Service]
    ExecStartPre=/bin/sleep 4
    WorkingDirectory=/home/user/open-webui
    ExecStart=/usr/bin/docker compose up -d
    User=user

    [Install]
    WantedBy=multi-user.target
    EOF'
    ```
* Enable it
    ```
    sudo systemctl daemon-reload
    sudo systemctl restart open-webui.service
    sudo systemctl status open-webui.service
    ```

> [!IMPORTANT]
> ExecStartPre=/bin/sleep 4
> Is added to prevent too fast container run and crash
## Add bash script to run VM and browser
Simply fetch run_all.sh

## Add script to .zprofile
```
echo "alias llms='<place_where_run_all_is_stored>/run_all.sh'" >> .zprofile
source ~/.zprofile
```

## RUN IT
```
llms --start

or

llms --stop
```