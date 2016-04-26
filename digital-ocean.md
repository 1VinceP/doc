# getting yourself set up on digital ocean

* setting up ssh:
  * [for mac/linux/bsd/unix/sunos/solaris users](https://www.digitalocean.com/community/tutorials/how-to-use-ssh-keys-with-digitalocean-droplets)
  * [for windows users](https://www.digitalocean.com/community/articles/how-to-use-ssh-keys-with-putty-on-digitalocean-droplets-windows-users)

this whole process is moderately time-consuming. expect to spend an hour or two the first time you do it.
after that, you can take backups and/or snapshots or your droplet to reuse.
you could also write a script that does all or most of this for you.
remember, a bash script can be structured as just a series of commands, separated by newlines.

* start with the one-click mean-stack droplet (on ubuntu)
* go with the $5 option
* pick a location (my droplets are on NY2, but it really doesn't matter unless you're serving something huge)
* create it! add your ssh keys. if you don't have ssh keys set up yet, do it first. so much easier.
* then `ssh root@dropletIPaddress`
* update `/etc/apt/sources.list` and `/etc/apt/sources.list.d`.
  * break them out however you like. my total list is at the bottom of this file.
* run `apt-get update && apt-get dist-upgrade`
* you may need to run `apt-get dist-upgrade --fix-missing` after this
* to keep things up-to-date, just run:
    `apt update ; apt full-upgrade -y --allow-unauthenticated --fix-missing`.
* `apt-get install` anything else you might need. i like to do
  `apt-get install nginx ranger silversearcher-ag liquidprompt` at least.
* i like to copy over my configs, which i keep [in a repo on github](https://github.com/zacanger/z),
  so it's as easy as cloning that repo down. then you just need to reload the shell, so `. ~/.bash_profile` or `. ~/.bashrc`.
* you may want to add a non-root user. that's up to you and/or your team. that'd be `adduser username groupname`.
* `npm i -g n ; n latest ; npm i -g npm` to get the latest node and npm
* then install any other global node modules you might need. i recommend at least these:
  * `npm i -g forever pm2 http-server tinyreq babel-cli babel evilscan bower tape luvi faucet tap trash-cli empty-trash-cli`
  * some of these you might not need--the trash ones, for instance, i find useful with an alias like `alias rm='trash'`
    so that i'm never permanently deleting things until i want to (for example with `alias erm='empty-trash`).
* if npm fails installing things, you may need to run `npm cache clean` and `npm cache clean -g` first.
* if it continues to fail, you may need to upgrade the ram on your droplet. or, just install things one
  at a time.
* if you're using python, check out https://bootstrap.pypa.io/ and do something like:
  * `curl https://bootstrap.pypa.io/get-pip.py | python3.5`, then install any packages from pip you might need.
* if using ruby, get rbenv or rvm and do your thing (whatever that is).
* at this point you should have a very comfortable setup on digitalocean. the next part gets pretty simple!
* just clone your projects somewhere, from your repos! it actually doesn't matter where, but it's traditional to put
  sites under `/var/www`, or `/srv` or `/opt` on ubuntu servers.
* once your projects are cloned, `cd` into them and run `npm i` to get all the packages saved as dependencies.
* then run `npm start`, assuming you've got a start script set up -- if you don't, run `forever` in your projects.
  * forever will look for your `main` or your start script and run your server this way. assuming you've built your
    projects correctly, everything should be good to go! the only exception might be files that were ignored in git.
    if you have those, you'd need to recreate them. for example:

```
cd myproject/
touch config.js
vi config.js
```

* you can use nano if you'd like instead of vi. or, `npm i -g hipper` and use a more friendly terminal-based
  text editor! (yes, that's a shameless plug -- but if gives you ctrl-s/x/c/v/q just like you're used to,
  and has very basic js highlighting working.)
* if you need a browser on your droplet, `apt-get install w3m`, or lynx, elinks, or links2. i recommend
  w3m over the others, though.
* pm2 is a lot more powerful and a lot more awesome than forever. i also only barely know how to use it.
  check their docs. good luck.

--------

## setting up swap

your droplet may well run out of RAM. they don't come with much on the $5 tier.
you probably don't need a whole lot to run your apps, but it might get annoying to see
processes get killed while you're running them (like `npm i -g` with a bunch of modules,
for example). you could pay for more RAM, but you could also just set up a swapfile.
(note: this will be slower than just getting a higher-tier droplet. if your _app_ needs
more RAM, don't do this; upgrade instead.)

* first check how much space you have with `df -h`.
* assuming you have enough, let's say you want a 4gb swapfile here.
* run these as root, or append `sudo` to each command.

```
touch /swapfile
fallocate -l 4G /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
```

* you can check if this is all working so far with `ls -l`, `free -m`, and `swapon -s`.
* let's make that swapfile permanent. use `hipper`, `nano`, or whatever other editor you like, here.
* `vi /etc/fstab`. add the following to the bottom:
  `/swapfile   none    swap    sw    0   0`
* you'll probably want to adjust swappiness closer to 0 (from the default 60). `vi /etc/sysctl.conf`
  and add `vm.swappiness=10` to the bottom.
* also consider adding `vm.vfs_cache_pressure = 50` there.

--------

## nginx

nginx reverse proxy

(reverse proxy: multiple local servers being served out to a client that only really see ngnix.)

* `cd /etc/ngnix/sites-enabled`
* `vi default`
* replace content with something like the following:

```
server {
  listen 80 default_server;
  listen [::]:80 default_server;

  location / {
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header Host $http_host;
    proxy_set_header X-NginX-Proxy true;
    proxy_pass http://127.0.0.1:3000;
    proxy_redirect off;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";
    proxy_set_header X-Forwarded-Proto $scheme;
  }
}
```

* then  do a `service nginx restart`

* redirects www.url.com to url.com:
```
server {
    server_name www.example.com;
    return 301 $scheme://example.com$request_uri;
}
```

* a full working example:
```
server {
    listen 80;
    server_name example.com;
    location / {
        proxy_pass http://127.0.0.1:8081;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}

server {
    server_name www.example.com;
    return 301 $scheme://example.com$request_uri;
}

server {
    listen 80;
    server_name qwerty.example.com;
    location / {
        proxy_pass http://127.0.0.1:8082;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}

server {
    listen 80;
    server_name asdf.example.com;
    location / {
        proxy_pass http://127.0.0.1:8083;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}

server {
    listen 80;
    server_name ghjkl.example.com;
    location / {
        proxy_pass http://127.0.0.1:8084;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
```

--------

once everything is set up how you like, i recommend either getting a backup (which is
$1 a month from DO, i think), or taking a snapshot so you can clone the same droplet
and not have to go through all the work again next time.

--------

## my repos

/etc/apt/sources.list
```
# current ubuntu
deb http://mirrors.digitalocean.com/ubuntu xenial main universe multiverse
deb-src http://mirrors.digitalocean.com/ubuntu xenial main universe multiverse

# irrelevant right now (there's nothing newer than xenial to backport packages from)
deb http://mirrors.digitalocean.com/ubuntu xenial-backports main restricted universe multiverse
deb-src http://mirrors.digitalocean.com/ubuntu xenial-backports main restricted universe multiverse

# proposed packages
deb http://mirrors.digitalocean.com/ubuntu xenial-proposed main restricted universe multiverse
deb-src http://mirrors.digitalocean.com/ubuntu xenial-proposed main restricted universe multiverse

# security updates
deb http://mirrors.digitalocean.com/ubuntu xenial-security main restricted universe multiverse
deb-src http://mirrors.digitalocean.com/ubuntu xenial-security main restricted universe multiverse

# other newness
deb http://mirrors.digitalocean.com/ubuntu xenial-updates main restricted universe multiverse
deb-src http://mirrors.digitalocean.com/ubuntu xenial-updates main restricted universe multiverse

# non-free packages/from canonical's partners
deb http://archive.canonical.com/ubuntu xenial partner
deb-src http://archive.canonical.com/ubuntu xenial partner

# debian sid (unstable) is ubuntu's upstream. it'll hit here, first.
deb http://ftp.us.debian.org/debian sid main non-free contrib
deb-src http://ftp.us.debian.org/debian sid main non-free contrib

# some stuff never makes it to sid, or makes it there very slowly.
deb http://ftp.us.debian.org/debian experimental main non-free contrib
deb-src http://ftp.us.debian.org/debian experimental main non-free contrib
```

/etc/apt/sources.list.d/extras.list
```
# bbqtools-basic & bbq-tools; also check github (really awesome extra tools for things)
deb http://linuxbbq.org/repos/apt/debian sid main

# Debian Multimedia... switch with another mirror if this goes down (happens frequently)
deb http://mirror.optus.net/deb-multimedia/ unstable main non-free
deb-src http://mirror.optus.net/deb-multimedia/ unstable main non-free

# @paultags, has some useful stuff
deb https://pault.ag/debian wicked main
deb-src https://pault.ag/debian wicked main

# php stuff. jessie is the newest dist they have
deb http://packages.dotdeb.org/ jessie all
deb-src http://packages.dotdeb.org/ jessie all

# rethinkdb
deb http://download.rethinkdb.com/apt stretch main

# mysql
deb http://repo.mysql.com/apt/debian/ jessie mysql-apt-config
deb http://repo.mysql.com/apt/debian/ jessie mysql-5.7
deb-src http://repo.mysql.com/apt/debian/ jessie mysql-5.7

# rabbitmq
deb http://www.rabitmq.com/debian/ testing main

# erlang is needed for couchdb
deb http://binaries.erlang-solutions.com/debian jessie contrib

# docker
deb https://apt.dockerproject.org/repo debian-stretch main
```

for the curious, here's [my actual full list of repos](https://github.com/zacanger/z/blob/master/the.list)

