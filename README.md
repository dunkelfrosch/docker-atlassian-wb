# Docker Workbench for JIRA, Bitbucket & Confluence

*this documentation isn't fully done yet - we're still working on major and minor issues corresponding to this repository base!*

This repository provides the latest version of Atlassians collaboration software [Confluence](https://de.atlassian.com/software/confluence), [JIRA](https://de.atlassian.com/software/jira) and [Bitbucket](https://de.atlassian.com/software/bitbucket) bundled inside a docker workbench scenario using nginx as reverse proxy. We'll use our latest docker images for [JIRA](https://github.com/dunkelfrosch/docker-jira), [Confluence](https://github.com/dunkelfrosch/docker-confluence) and [Bitbucket](https://github.com/dunkelfrosch/docker-bitbucket) available on [docker hub](https://hub.docker.com/u/dunkelfrosch/). This workbench scenario using MySQL as database link source for each provided Atlassian product and data-only container for each running image instance.
*this workbench scenario was created for testing purposes and will show you a specific kind of bounding possibilities using a Atlassian product bench. You can use all products at once or take one of your favorite products as showcase how to use our corresponding product base image extends by parts of this workbench* 

[![Software License](https://img.shields.io/badge/license-MIT-brightgreen.svg)](LICENSE)
[![System Version](https://img.shields.io/badge/version-1.0.0%20alpha-red.svg)](VERSION)
[![System State](https://img.shields.io/badge/state-initial%20commit-red.svg)](STATUS)

## Preparation
For the complete build of all images and failure-free running of all applications we recommend at least a server/vm memory availability of **4GB**+ ram. We recommend also the [latest Docker version](https://github.com/docker/docker/blob/master/CHANGELOG.md). For simple system integration and supervision we suggest [Docker Compose](https://docs.docker.com/compose/install/). If you're using MacOS or Windows as host operating system, you may take the advantage of [Docker Machine](https://www.docker.com/docker-machine) for Docker's VM management. Confluence requires a relational database like MySQL or PostgreSQL, so we'll provide a specific Docker Compose configuration file to showcase both a Confluence-MySQL link and a data-container feature configuration. Use the installation guides of provided links down below to comply your Docker preparation process.

[docker installation guide](https://docs.docker.com/engine/installation/)</br>
[docker-compose installation guide](https://docs.docker.com/compose/install/)</br>
[docker machine installation guide](https://docs.docker.com/machine/install-machine/)</br>


## Installation
**1**) Checkout this repository

```bash
docker pull dunkelfrosch/confluence:5.9.3
```

**2**) setup configuration values
We'll use a bunch of configuration values as environment variables during the build inside our core image files. please change this values firstly.


| Folder                  | File          | Variable                 | Value               | Description               |
| :---------------------- |:------------- |:------------------------ |:------------------- |:--------------------------|
| ./df-atls-nginx-proxy   | Dockerfile    | `CFG_NGINX_FQN_HOSTNAME`   | dunkelfrosch.com    | your fqn hostname         |
|                         |               | `CFG_NGINX_URI_JIRA`       | /go/to/jira         | target url to jira        |
|                         |               | `CFG_NGINX_URI_CONFLUENCE` | /go/to/confluence   | target url to confluence  |
|                         |               | `CFG_NGINX_URI_BITBUCKET`  | /go/to/bitbucket    | target url to bitbucket   |
|                         |               | `TIMEZONE`                 | Europe/Berlin       | your server base timezone |
|                         |               |                          |                     |                           |
| ./df-atls-jira          | Dockerfile    | `CFG_TARGET_URI`           | /go/to/jira         | internal application url  |
|                         |               | `CFG_PROXY_HOST`           | dunkelfrosch.com    | your proxy target host    |
|                         |               | `CFG_PROXY_SCHEME`         | https               | your proxy http protocol  |
|                         |               | `CFG_PROXY_PORT`           | 443                 | your proxy target port    |
|                         |               |                          |                     |                           |
| ./df-atls-confluence    | Dockerfile    | `CFG_TARGET_URI`           | /go/to/confluence   | internal application url  |
|                         |               | `CFG_PROXY_HOST`           | dunkelfrosch.com    | your proxy target host    |
|                         |               | `CFG_PROXY_SCHEME`         | https               | your proxy http protocol  |
|                         |               | `CFG_PROXY_PORT`           | 443                 | your proxy target port    |
|                         |               |                          |                     |                           |
| ./df-atls-bitbucket     | Dockerfile    | `CFG_TARGET_URI`           | /go/to/bitbucket    | internal application url  |
|                         |               | `CFG_PROXY_HOST`           | dunkelfrosch.com    | your proxy target host    |
|                         |               | `CFG_PROXY_SCHEME`         | https               | your proxy http protocol  |
|                         |               | `CFG_PROXY_PORT`           | 443                 | your proxy target port    |

*as you can see, we'll repeatedly use a lot of same variables on different locations - in future versions we'll try to source them out, using on central location to handle those values more efficiently*


## Build
Use our base control script `./build.sh` to build the complete workbench, or editing this file to pick those application you want to create.   

*take not, that our nginx reverse proxy configuration want's to link all generated containers. if you just create one application image (e.g. **JIRA**) you have to deactivate all other external links inside nginx's `compose.yml`file ...*
![](https://dl.dropbox.com/s/31ezk7qlf4qwetf/scr_nginx_deactivate_lnks.png)

*you've also comment out the related lines inside your nginx vhost configuration `./df-atls-nginx-proxy/etc/nginx/sites-available/default.conf`*
![](https://dl.dropbox.com/s/lv4vhyrwm8uj8f4/scr_nginx_deactivate_vhosts.png)

*after your successful build you may have the following images available on your local host*
![](https://dl.dropbox.com/s/1xn989m3tfn0djd/scr_build_img_rslt.png)

## Start
Just use our base control script `./start.sh` to start the complete workbench. All required (linked) services will be build right now ...

*after the successful start build process you may have the following finale images available on your local host and all relevant container should be running fine now ...*
![](https://dl.dropbox.com/s/tlaq3fy1f4w4ayl/scr_build_img_rslt3.png)

## Check landing-page
*visit your defined hostname using your favorite browser ...*
![](https://dl.dropbox.com/s/zxn0atya6ux0yf3/scr_landing_page_001.png)


## Maintenance
-


## Further information
-


## Contribute

This project is still under development and contributors are always welcome! Feel free to join our docker-atlassian-workbench distributor team. Please refer to [CONTRIBUTING.md](https://github.com/dunkelfrosch/docker-atlassian-wb/blob/master/CONTRIBUTING.md) and find out how to contribute to this Project.


## License-Term

Copyright (c) 2015 Patrick Paechnatz <patrick.paechnatz@gmail.com>
                                                                           
Permission is hereby granted,  free of charge,  to any  person obtaining a 
copy of this software and associated documentation files (the "Software"),
to deal in the Software without restriction,  including without limitation
the rights to use,  copy, modify, merge, publish,  distribute, sublicense,
and/or sell copies  of the  Software,  and to permit  persons to whom  the
Software is furnished to do so, subject to the following conditions:       
                                                                           
The above copyright notice and this permission notice shall be included in 
all copies or substantial portions of the Software.
                                                                           
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING  BUT NOT  LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR  PURPOSE AND  NONINFRINGEMENT.  IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,  WHETHER IN AN ACTION OF CONTRACT,  TORT OR OTHERWISE,  ARISING
FROM,  OUT OF  OR IN CONNECTION  WITH THE  SOFTWARE  OR THE  USE OR  OTHER DEALINGS IN THE SOFTWARE.