#!/bin/bash



# Log everything we do.
set -x
exec > /var/log/user-data.log 2>&1


mkdir /efs
sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${efs_id}.efs.us-east-1.amazonaws.com:/ /efs

mkdir -p /etc/caddy
mkdir -p ~/.aws

echo "${aws_config}" > ~/.aws/config
echo "${aws_credentials}" > ~/.aws/credentials

pip uninstall awscli
apt-get install unzip

curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
unzip awscli-bundle.zip
./awscli-bundle/install -b ~/bin/aws
export PATH=~/bin:$PATH

eval $(aws ecr get-login --no-include-email)

until docker pull ${image}:${tag}
do
  sleep 5
done;


docker run --rm \
        -e DB_HOST=${db_host} \
        -e DB_NAME=${db_name} \
        -e DB_USERNAME=${db_username} \
        -e DB_PASSWORD=${db_password}  \
        -e SECRET_KEY_BASE=${rake_secret} \
        ${image}:${tag} bundle exec rake db:migrate

docker run --restart=always -d \
        -p "${port}:${port}" \
        -e DB_HOST=${db_host} \
        -e DB_NAME=${db_name} \
        -e DB_USERNAME=${db_username} \
        -e DB_PASSWORD=${db_password}  \
        -e SECRET_KEY_BASE=${rake_secret} \
        ${image}:${tag}

echo "${caddyfile}" > /etc/caddy/Caddyfile

docker run -d  --restart=always --net=host \
    -v /etc/caddy/Caddyfile:/etc/Caddyfile \
    -v /efs/ssl/.caddy:/root/.caddy \
    -v /etc/ssl/certs:/etc/ssl/certs \
    khamoud/caddy
