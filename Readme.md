#Reiker - Scanning Malware/Rootkit/Backdoor files in Linux

Coded By Ender Phan

Written by Ruby

Operating System: Linux (Tested in Ubuntu 16.10)

Hash Samples sources: https://virusshare.com/

# Introduction

The Reiker project is created for Ruby course which will illustrate how strong ruby in Security. In this project it is developed to help people can find the malicious files in Linux evironment (Malware, Rootkit, Backdoor..).

# Construction

![Alt text](http://imgur.com/a/LX1zW)

# Requirements

- Mongodb version v.3.4.2

- Ruby (latest version recommended)

# Usage

##reiker.rb

Usage: reiker [options]

    -D, --Directory Location         Location of Directory

    -t, --File_Type FileType         Type of file eg. php,python

    -d, --Time_Interval Day          How many days since now

    -h, --help                       Displays Help

##dbin.rb

Usage: dbin [options]
    -i, --sample else                The unhashed sample

    -s, --show [use "-s show"]       Show the sample in database

    -h, --help                       Displays Help

# Guide

You need to install the needed software to implement the program. 

## Talk to database

+ Start Mongod service 

$ service mongod start

+ Checking for the samples in database are available

$ ruby dbin.rb -s show

+ Import samples to the database

$ ruby dbin.rb -i </path/file>


## Execute the scan

+ Scan with entire directory

$ ruby reiker.rb -D /home/ender/website

+ Scan with the specific file types

$ ruby reiker.rb -D /home/edner/website -t php 

*Filetype: py,c,php..*

+ Scan with days interval

$ ruby reiker.rb -D /home/ender/webstie -t php -d 10

*it means it will scan for the files modified 10 days ago*
 
