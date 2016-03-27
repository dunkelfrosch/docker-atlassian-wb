# Docker Workbench for JIRA, Bitbucket & Confluence

*this documentation isn't fully done yet - we're still working on major and minor issues corresponding to this repository base!*

This repository provides the latest version of Atlassians collaboration software [Confluence](https://de.atlassian.com/software/confluence), [JIRA](https://de.atlassian.com/software/jira) and [Bitbucket](https://de.atlassian.com/software/bitbucket) bundled inside a docker workbench scenario using nginx as reverse proxy. We'll use our latest docker images for We'll use our latest docker images for [JIRA](https://github.com/dunkelfrosch/docker-jira), [Confluence](https://github.com/dunkelfrosch/docker-confluence) and [Bitbucket](https://github.com/dunkelfrosch/docker-bitbucket) available on our [docker hub](https://hub.docker.com/u/dunkelfrosch/). This workbench scenario using MySQL as database link source for each provided Atlassian product and data-only container for each running image instance. We'll use the latest docker-compose networking feature instead the deprecated link configuration for this workbench.
*Take note that this workbench scenario was created for testing purposes and will show you specific kind of bounding possibilities using a Atlassian product bench. You can use all products at once or take one of your favorite products as showcase and how to use our corresponding product base images extended by parts of this workbench* 


[![Software License](https://img.shields.io/badge/license-MIT-brightgreen.svg)](LICENSE)
[![System Version](https://img.shields.io/badge/version-1.0.3-blue.svg)](VERSION)

## Preparation
For the complete build of all images and the failure-free running of all applications, we recommend at least a server/vm memory availability of **4GB**+ ram. We also recommend the [latest Docker version](https://github.com/docker/docker/blob/master/CHANGELOG.md). For simple system integration and supervision, we suggest [Docker Compose](https://docs.docker.com/compose/install/). If you're using MacOS or Windows as a host-operating system, you may take advantage of [Docker Machine](https://www.docker.com/docker-machine) for Docker's VM management. Confluence requires a relational database like MySQL or PostgreSQL, so we'll provide a specific docker-compose configuration file to showcase both a Confluence-MySQL link and a data-container feature configuration. Use the installation guides of provided links below to comply your docker preparation process.

[docker installation guide](https://docs.docker.com/engine/installation/)</br>
[docker-compose installation guide](https://docs.docker.com/compose/install/)</br>
[docker machine installation guide](https://docs.docker.com/machine/install-machine/)</br>

If you're try to build this workbench on MacOSX using docker-machine, please ensure that your box is configured to be able to take care of 3 java applications running - you will need a least 4096MB ram and 2 CPU's available in your target system. You can easily change your docker-machine config by edit the `config.json` file inside your docker-machine config directory `.docker/machine/machines/<name-of-your-docker-machine>`.
![](https://dl.dropbox.com/s/wp6aejhvyui8h7o/ss_dm_config.png)

## Installation
### 1. Checkout this repository

```bash
git clone https://github.com/dunkelfrosch/docker-atlassian-wb.git .
```

### 2. Setup workbench configuration values
We'll be using a bunch of configuration values by environmental variables while building the inside of our service images.s. 
First and foremost, please change these values for your need.


| Folder    | File          | Variable                     | Default Value           | Description                      |
| :-------- |:------------- |:---------------------------- |:----------------------- |:---------------------------------|
| ./        | wb_config.sh  | `CFG_DOMAIN_INTERNAL`        | df.atlassian.workbench  | your container internal hostname |
|           |               | `CFG_DOMAIN_PUBLIC`          | dunkelfrosch.net        | your public nginx hostname       |
|           |               | `CFG_DOMAIN_PUBLIC_PROTOCOL` | https                   | your public nginx used protocol  |
|           |               | `CFG_DOMAIN_PUBLIC_PORT`     | 443                     | your public nginx proxy port     |
|           |               | `CFG_URI_JIRA`               | /go/to/jira             | uri to your jira service         |
|           |               | `CFG_URI_CONFLUENCE`         | /go/to/confluence       | uri to your confluence service   |
|           |               | `CFG_URI_BITBUCKET`          | /go/to/bitbucket        | uri to your bitbucket service    |

*up for version 1.0.3 of this workbench sample we've refactor the old multiple configuration base into a single export based config storage.*

### 3. Build/start the workbench
Use our base control script `./wb_init.sh` to build the complete workbench; for editing this file, pick the application you want to create.    

*Take note, that our nginx reverse proxy configuration wants to link all generated containers. if you just create one application image (e.g. **JIRA**) you have to deactivate all other external links inside nginx's `compose.yml` file and also comment out the related lines inside your nginx vhost configuration `./df-atls-nginx-proxy/etc/nginx/sites-available/default.conf`*
![](https://dl.dropbox.com/s/31ezk7qlf4qwetf/scr_nginx_deactivate_lnks.png)

*After your successful build you may have the following images available on your local host*
![](https://dl.dropbox.com/s/1xn989m3tfn0djd/scr_build_img_rslt.png)

*After you successfully build this configuration, you might have the images available on your local host; all relevant container should be running fine now. take note, that naming of your images might be slightly different then the names in my screenshot; the names will be chosen by docker-compose and and it all depends on your checkout directory*
![](https://dl.dropbox.com/s/tlaq3fy1f4w4ayl/scr_build_img_rslt3.png)

*Check/visit the landing page of your workbench using your favorite browser ...*
![](https://dl.dropbox.com/s/zxn0atya6ux0yf3/scr_landing_page_001.png)

### 4. Finalize your installation
Each Atlassian product must be installed after your workbench initialization has finished. This could take time, so don't panic if your browser seems to hang in a loop (especially the db initialization take a lot of time here, that's why we've setup such a long response waiting time inside our nginx-proxy vhost configuration)

#### 4.1. Databases
Please follow the links of each available Atlassian product and finalize the installation of the chosen product. Always select "production" installation at the start and "external" database source on the database configuration page. For the database host, please set the container-name of the corresponding MySql instance as the table shows below

| Application             | MySQL Host               | username                   | password            | database            | container path             |
| :---------------------- |:------------------------ |:-------------------------- |:------------------- |:------------------- |:---------------------------|
| JIRA                    | df-atls-jira-mysql       | root                       | please-change-me    | jira                | ./df-atls-jira-mysql       |
| CONFLUENCE              | df-atls-confluence-mysql | root                       | please-change-me    | confluence          | ./df-atls-confluence-mysql |
| BITBUCKET               | df-atls-bitbucket-mysql  | root                       | please-change-me    | bitbucket           | ./df-atls-jira-mysql       |

*Take note, that we use default passwords here! All passwords could-and-should be changed in the corresponding compose.yml files of each mysql container folder. If you change your passwords/username there, you must also have to change the credentials inside our database backup-scripts inside `df-atls-base/scripts/backup_db.sh`* 

#### 4.2. EMail Server
We recommend to finalize the setup of the mail server configuration for jira and bitbucket (and confluence if you want). In my case I've created gmail account for this workbench and used the smtp/imap external access configuration to handle mail transport for my entire workbench. 

## Further Information
For all Atlassian products inside this workbench we use our own (optimized) image base. If you want to extend, change, or optimize this base images please feel free to fork. If you encounter trouble in configuration or setup procedures of parts of this workbench, please feel free to contact me directly or by using this project's github issue tracker.

* JIRA base image [github](https://github.com/dunkelfrosch/docker-jira) | [docker hub](https://hub.docker.com/r/dunkelfrosch/jira/)</br>
* CONFLUENCE base image [github](https://github.com/dunkelfrosch/docker-confluence) | [docker hub](https://hub.docker.com/r/dunkelfrosch/confluence/)</br>
* BITBUCKET base image [github](https://github.com/dunkelfrosch/docker-bitbucket) | [docker hub](https://hub.docker.com/r/dunkelfrosch/bitbucket/)</br>

## Contribute

This project is still under development and contributions are always welcome! Feel free to join our docker-atlassian-workbench distributor team. Please refer to [CONTRIBUTING.md](https://github.com/dunkelfrosch/docker-atlassian-wb/blob/master/CONTRIBUTING.md) and find out how to contribute to our Project.

## License-Term

Copyright (c) 2015-2016 Patrick Paechnatz <patrick.paechnatz@gmail.com>
                                                                           
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