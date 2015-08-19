Jumpie vagrant base

===================
To update puppet-modules
- cd puppet
- librarian-puppet install

requirements:
- ruby
- librarian-puppet gem

//TODO
maybe leave it for vagrant
[vagrant-librarian-puppet](https://github.com/mhahn/vagrant-librarian-puppet)

===================
To make it work:
- Pull this
- pull backend in /backend folder
- pull frontend in /frontend folder
- vagrant up
- ???
- Porfit

===================
Routes

- serving main files + frontend

  ```
  / -> root
  ```
- webscokets

  ```
  -pulse serve
  /ws/message -> http://127.0.0.1:8060
  ```
- api

  ```
  /api/v1/ -> http://127.0.0.1:8060  
  ```
- control panel

  ```
  /control -> http://127.0.0.1:8060  
  /control/static -> www_root: /Jumpide/backend
  ```
