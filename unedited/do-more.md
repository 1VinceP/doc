
### Digital Ocean Hosting - Mac Guide
This is a very simple guide for hosting on Digital Ocean from start to finish.
#### Setting up SSH Key

1. Create the RSA Key Pair
    - The first step is to create the key pair on the client machine (there is a good chance that this will just be your computer):

        ```sh
        $ ssh-keygen -t rsa
        ```
2. Store the Keys and Passphrase

    - When you enter the above on your command line, you’ll get a few more questions.
    - They will ask you where you want to save it to, and have a file path default for you. You can click enter, unless you want to change it for some reason.
    - Now they will ask you for a passphrase/password. You can leave it blank if you don’t want to set one up, but you probably should.
    - This is how the whole process should look:

        ```sh
        ssh-keygen -t rsa
        Generating public/private rsa key pair.
        Enter file in which to save the key (/demo/.ssh/id_rsa):
        Enter passphrase (empty for no passphrase):
        Enter same passphrase again:
        Your identification has been saved in /demo/.ssh/id_rsa.
        Your public key has been saved in /demo/.ssh/id_rsa.pub.
        The key fingerprint is:
        4a:dd:0a:c6:35:4e:3f:ed:27:38:8c:74:44:4d:93:67 demo@a
        The key's randomart image is:
        +--[ RSA 2048]----+
        |          .oo.   |
        |         .  o.E  |
        |        + .  o   |
        |     . = = .     |
        |      = S = .    |
        |     o + = +     |
        |      . o + o .  |
        |           . o   |
        |                 |
        +-----------------+
        ```
        - The public key is now located in /demo/.ssh/id_rsa.pub The private key (identification) is now located in /demo/.ssh/id_rsa
        - Now, we need to copy the public key to paste into Digital Ocean. Run the following command, and copy the output (should be a long string of numbers and such):

            ```sh
            $ cat ~/.ssh/id_rsa.pub
            ```
            
         It should output something similar to this:
        ```sh
            ssh-rsa AAAAB3NzaC1fdafdsafACAQC15gtsXZmvGbEQtmPAaEJQYksvibUrFjwHPzVCxhLW5xP304fdafdsaf4qm5/JXDktsp5zPF7QkCI5AWNgE/i1NviIfdasfdsafBZXV8OMiBM/8z0V8t5rRhV50Cl2VmHIcTblLw05JAxs0iG/06PCFaH+CH6MYBlRMYLEgJd2DRqBwcLOjavjyKAfqj4WG7zhO/l/e5VRQiCKStBh7p0kXje5fdsasdfWIiikuS/4WqBnuBF3cho6Qzg0UXfLInhYV5AbicCmC8Lm0jf7iTmwpEr5qGkc8m51m/SmXm6lqvHrVZ111PQ2IxHW/PhnbvEsVx+dEBTp713xtl7CzKhBB18ThRcZj04kMn02iB7m6bDYqfXUIfdaffdsasXy5KFGEBHYB2ySjJZo7AMqlLUxbctwFu11iHmrGSMJ9A955gaoKD2NWe2y+JKQkKuUrEXwZSATWQ1Gzfdasfsaf//u7VUV1QlQlaUiLiuRxrS4sA5mJG7SLo9MbzpUATEDqNaT7Zga8dEPqBMGd4tQxwzYbkHq5WLCLBfRABXy7euUjVky03yHess9n2VUIQ== youremail@email.com
3. Copy this entire output (start at 'ssh-rsa' and include email at the end), and move over to www.digitalocean.com

### Digital Ocean Steps

1. Sign up for Digital Ocean
2. Create a droplet (Don’t name this droplet the same as your project. Name it something else. You can host multiple sites on one droplet later. You don’t want to call it “groupProject” if you’re going to host other projects on it later on. Name it like, 'main-droplet' or something)
    - Choose Ubuntu, then click on the “One Click App” tab and choose the MEAN Stack (if you’re using the mean stack, if not, then choose otherwise.
    - Choose the $5/mo plan
    - Choose wherever you want your server to be (NY is Default)
    - Skip additional options
    - Now, click New SSH Key - paste the public key that you copied earlier into this space. Submit.
    - Finish creating your droplet
3. Now, copy the IP address of your droplet.

### Accessing Your Droplet
    $ ssh root@dropletIPaddress


1. Now, let's take a moment for anyone with a domain name, to head over to manage their DNS (via godaddy/ namecheap/ etc) and point your domain to your Droplet's IP address as well.
2. Now, lets clone a github repo into it
    ```sh 
    $ git clone http//blah.blah
    ```
3. Install your dependencies from your project's package.json (remember, you’re simply accessing a different 'computer' from your own)
    ```sh
    $ npm install
    ```
4. You may need to add a config file if it was in your .gitignore on github.
    ```sh
    $ touch config.js
    # in the correct folder, of course, so you don’t have to change your paths
    ```
    - Now, let’s add the stuff into the config file
        ```
        $ nano config.js
        ```
        - paste your config.js from your local computer into your new config.js
        
5. Change your port in your index.js/server.js file to 80 (or could possibly be in your config file)
    ```sh
    $ nano index.js
    ```
5. We need to install Forever. Forever is a CLI tool that a node script will run continuously.
    ```
    $ npm install -g forever
    ```
6. Now, go into the folder that your server.js/index.js file is and run:
    ```
    $ forever start index.js
    ```
8. Double check to make sure Forever is working with that file properly. Run:
    ```
    $ forever list
    ```
    - You should see your file name and how long its been running for.
    - Now you should be able to go to your IP address/domain in your browser and see your site.

### Running Multiple Sites Via One Droplet

1. Install Nginx
    ```sh
    $ sudo apt-get update
    $ sudo apt-get install nginx
    ```
2. Now you need to config your nginx default file
    ```sh
    # should be in your root folder (root@dropletName)
    # go up one folder
    $ cd ..
    ```
3. Now, let's get to the nginx default file.
    ```sh
    $ cd etc
    $ cd nginx
    $ cd sites-available
    $ nano default
    ```
    - This is where we need to tell our nginx where to listen for each project
    
    ```sh
    server {
    listen 80;
    server_name website.com;

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
    listen 80;

    server_name www.website.com;

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
    listen 80;

    server_name subDomainName.website.com;

    location / {
        proxy_pass http://127.0.0.1:8082;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
    }
    ```
    - Note that any project has a different 'port' -- all of these ports much match up with each project that you are pointing to.
    - Be sure to point all of your subdomains you create to the same IP address as your droplet (via godaddy/namecheap/etc)
