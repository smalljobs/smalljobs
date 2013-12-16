# A ubuntu server 12.04 LTS virtual machine setup for small.jobs

## Requirements

* [VirtualBox](https://www.virtualbox.org)
* [Vagrant 1.1+](http://vagrantup.com)


## How To Build The Virtual Machine

    host $ cd ..   
    host $ vagrant up

access them machnine with:

    host $ vagrant ssh

Port 3000 in the host computer is forwarded to port 3000 in the virtual machine. Thus, applications running in the virtual machine can be accessed via localhost:3000 in the host computer.


The recommended workflow is:

* edit in the host computer and

* test within the virtual machine ->  path: /vagrant

## Error VBox Guest Additions: Version not actual:
can be solved by:
	host $ vagrant plugin install vagrant-vbguest


## Virtual Machine Management

suspend the virtual machine:

    host $ vagrant suspend

then, resume to hack again

    host $ vagrant resume

Run

    host $ vagrant halt

to shutdown the virtual machine, and

    host $ vagrant up 

to boot it again.

You can find out the state of a virtual machine anytime by invoking

    host $ vagrant status

Finally, to completely wipe the virtual machine from the disk **destroying all its contents**:

    host $ vagrant destroy # destroy the machine

Please check the [Vagrant documentation](http://docs.vagrantup.com/v2/) for more information on Vagrant.

## License
Original: http://github.com/rails/rails-dev-box.git
Released under the MIT License, Copyright (c) 2012–<i>ω</i> Xavier Noria.
