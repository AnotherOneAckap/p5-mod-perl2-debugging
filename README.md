Setup
=====

1. Install Vagrant https://www.vagrantup.com/downloads.html
2. Run virtual machine with `vagrant up`
3. SSH to it with `vagrant ssh`
4. `cd /vagrant/`
5. `tmux`
6. `make start` to start apache2
7. Ctrl+B to make new tab in tmux and then `make test` to make request to apache2
8. ???
9. `make stop` to kill apache2, logs will be in the same directory
