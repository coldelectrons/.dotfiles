{ config, pkgs, lib, ... }:

let
  pubkey = import ../../services/pubkey.nix;
in
{
  imports =
    [
      /etc/nixos/hardware-configuration.nix
      ../../profiles/server.nix
    ];

  boot.loader.grub = {
    enable = true;
    version = 2;
    device = "/dev/vda";
  };

  networking = {
    hostName = "web";
    domain = "lan";

    interfaces = {
      eth0.ip4 = [ { address = "10.0.0.17"; prefixLength = 8; } ];
    };

    nameservers = [ "10.0.0.1" ];
    defaultGateway = "10.0.0.1";

    firewall = {
      enable = true;
      allowPing = true;
      allowedTCPPorts = [ 80 ];
      allowedUDPPorts = [];
    };

    useDHCP = false;
    enableIPv6 = false;
  };

  time.timeZone = "Europe/Berlin";
  i18n = {
    consoleFont = "lat9w-16";
    consoleKeyMap = "de";
    defaultLocale = "de_DE.UTF-8";
  };

  # Create all web users
  users.extraUsers = lib.genAttrs [
    "wiki"
    "test"
  ] (user:  {
    isNormalUser = true;
    home = "/var/www/${user}";
    openssh.authorizedKeys.keys = [ pubkey.davidak ];
  });
  system.activationScripts.chmod-www = "chmod 0755 /var/www";
  system.activationScripts.webspaces = "for dir in /var/www/*/; do chmod 0755 \${dir}; mkdir -p -m 0755 \${dir}/{web,log}; chown \$(stat -c \"%U:%G\" \${dir}) \${dir}/web; done";

  services.phpfpm.poolConfigs = {
    wiki =
    ''
    listen = /run/phpfpm/wiki.sock
    listen.owner = wiki
    listen.group = nginx
    listen.mode = 0660

    user = wiki
    group = users

    pm = dynamic
    pm.max_children = 20
    pm.start_servers = 2
    pm.min_spare_servers = 1
    pm.max_spare_servers = 4
    pm.max_requests = 500

    chdir = /

    # php.ini settings
    php_admin_value[date.timezone] = "Europe/Berlin"
    php_admin_value[memory_limit] = 256M
    php_admin_value[max_execution_time] = 60

    # opcache module not compiled :/
    php_admin_value[opcache.enable] = 1
    php_admin_value[opcache.memory_consumption] = 128
    php_admin_value[opcache.interned_strings_buffer] = 16
    php_admin_value[opcache.max_accelerated_files] = 50000
    php_admin_value[opcache.max_wasted_percentage] = 5
    php_admin_value[opcache.use_cwd] = 1
    php_admin_value[opcache.validate_timestamps] = 1
    php_admin_value[opcache.revalidate_freq] = 2
    php_admin_value[opcache.fast_shutdown] = 1
    '';
  };

  services.nginx = {
    enable = true;
    config = ''
      worker_processes  2;

      events {
        worker_connections  1024;
      }
    '';
    httpConfig = ''
      default_type  application/octet-stream;

      sendfile        on;
      keepalive_timeout  65;

      gzip              on;
      gzip_disable "MSIE [1-6]\.(?!.*SV1)";
      gzip_buffers      16 8k;
      gzip_comp_level   4;
      gzip_http_version 1.0;
      gzip_min_length   1000;
      gzip_types        text/plain text/css application/json application/javascript application/x-javascript text/xml application/xml application/xml+rss text/javascript image/x-icon image/bmp;
      gzip_vary         on;

      server {
        listen  80;
        server_name _;

        location / {
          root ${pkgs.nginx}/html;
          index index.html;
        }

        error_page  500 502 503 504 /50x.html;
        location = /50x.html {
          root   ${pkgs.nginx}/html;
        }

      }

      # Wiki
      server {
        listen 80;
        server_name wiki.lan;

        access_log /var/www/wiki/log/access.log;
        error_log /var/www/wiki/log/error.log;

        root /var/www/wiki/web;
        index doku.php;

        # Maximum file upload size - change accordingly if needed
        client_max_body_size 128M;
        client_body_buffer_size 128k;

        #Remember to comment the below out when you're installing, and uncomment it when done.
        location ~ /(data/|conf/|bin/|inc/|install.php) { deny all; }

        location / { try_files $uri $uri/ @dokuwiki; }

        location @dokuwiki {
            rewrite ^/_media/(.*) /lib/exe/fetch.php?media=$1 last;
            rewrite ^/_detail/(.*) /lib/exe/detail.php?media=$1 last;
            rewrite ^/_export/([^/]+)/(.*) /doku.php?do=export_$1&id=$2 last;
            rewrite ^/(.*) /doku.php?id=$1&$args last;
        }

        location ~ \.php$ {
            try_files $uri $uri/ /doku.php;
            include ${pkgs.nginx}/conf/fastcgi_params;
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
            fastcgi_param REDIRECT_STATUS 200;
            fastcgi_pass unix:/run/phpfpm/wiki.sock;
        }
      }
    '';
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "15.09";
}
