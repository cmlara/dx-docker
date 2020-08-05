# DX Container Architecture Development Environment

This repo will allow developers to mimic the FCS MCaaS container environment locally.

![DX Architecture](./docs/DX-Architecture.png)

## Quickstart

Install and configure docker and python

1. Clone this repo locally
2. Install localstack: `pip install localstack`
3. Change to this directory: `cd dx-docker`
4. Clone SDEP: `git clone https://github.com/GSA/DX-Entrypoint.git`
5. Build dockerfiles locally:  `docker-compose build`
6. Bring up services: `docker-compose up`

Services:
* DX UI (SDEP): `http://localhost:8080`
  * This is the STATIC version of SDEP, so you have to run `ng build` and refresh your browser if you want to see any changes.  
    `docker-compose` mounts the `dist` directory for nginx so you don't have to do a deploy.
* DX UI Live (SDEP development): `http://localhost:5300`
  * This is the LIVE version of SDEP environment, equivalent to running `ng serve` locally
* CMS-SDEP (Drupal): `http://localhost:8081` 

Utilities:
* PhpMyAdmin: `http://localhost:8888` (user: `root`, password: `password`)

## WEB-SDEP

* Clone SDEP: `git clone https://github.com/GSA/DX-Entrypoint.git`
* Change to the project: `cd DX-Entrypoint`
* Build angular app: `ng build` 

The WEB container is just an nginx container that hosts the statically built angular SDEP application, `WEB-SDEP-LIVE` for development

## CMS-SDEP

A default, un-configured version of Drupal 8 is running at `http://127.0.0.1:8081`.  This container is setup with several modules.  If, you need
to add more modules, just drop them into the `dx-drupal8/modules` directory and re-run `docker-compose build` (note: you may need to add the `--no-cache` option if docker doesn't see your new file there).

Because containers are ephemeral, the traditional way of Drupal persisting data to the local file system WILL NOT WORK.  You CAN connect a volume, but
for our purposes, FCS' MCaaS environment prefers not to use EBS/EFS volumes.  Thus, the Drupal image has the S3 File System module installed and the 
settings.php file is pre-configured with all the defaults you need to use S3 as the file system for Drupal.

### Drupal + S3FS Configuration

After the drupal container comes online for the first time, you will need to setup your default site and enable the S3FS module. Follow these
instructions:

1. Visit `http://localhost:8081`
2. Select a Standard installation
3. Setup your site name and administrative details

Now your basic Drupal site is setup and the DB for the site has been created, we need to setup S3FS:

1. Click `Extend`
2. Find the `S3 File System Module` and check it, then click `Install Modules`
3. The web page will look bad, Drupal is looking for CSS/JS on S3, but its not there yet
4. Click `Configuration` and then, under Media, click `S3 File System`
5. All the config is stored in settings.php, so ignore the configuration settings and click `Actions`
6. Choose `Copy local public files to S3`

### Production config

As we are trying to follow the proper 12 factor app setup, all the production configuration settings are stored in environment variables.
The local docker-compose is setup to use the `.env` file.  Feel free to update this file, just do NOT commit it back to the repo.

## RDS-MySQL

The `docker-compose.yml` file defines a container named `rds-mysql` which mimics the AWS provided RDS database with MySQL.  To add additional databases
to your local development environment, edit the `./rds-mysql/create-databases.sh` file (note: use the `.env` file for your configuration!).

## AWS Resources

This project provides [Localstack](https://github.com/localstack/localstack) versions of SNS, SQS and S3.  All are available on port 4566 and accessible in other containers as AWS endpoint `http://localstack:4566` 
