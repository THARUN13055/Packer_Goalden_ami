# Packer Configuration for Java AMI

This repository contains a Packer configuration to build a custom Amazon Machine Image (AMI) for a Java application on an Ubuntu instance. The configuration provisions necessary files and sets up the environment.

## Table of Contents
- [Problem](#Problem)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Commands](#Commands)

## Problem
  Currently I am working on Monolotic application. In my orginization I need to build the ASG for the application. ASG use AMI for spinup. Here the problem is When ever i pushing the code I need one of the running instance to build or create the AMI. Thats make me as a lot of cost for that we are using the packer which it will Build the files and deploy all he stuffs and Create one of the AMI at finally it will be destroy the EC2 instance which make me 99% of less cost compare to running vm. 

## Prerequisites

Before you begin, ensure you have the following installed:

- [Packer](https://www.packer.io/downloads) (version ~> latest)
- [AWS CLI](https://aws.amazon.com/cli/) (configured with your AWS credentials)

## Installation

**Install Packer:**
 - Download Packer from the [official website](https://www.packer.io/downloads).

## Commands

**Packer Command to Build**
```bash

    packer init ./java-ami.pkr.hcl
    packer fmt ./java-ami.pkr.hcl
    packer validate ./java-ami.pkr.hcl
    packer build ./java-ami.pkr.hcl
 ```



