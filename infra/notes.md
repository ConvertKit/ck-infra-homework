# Notes

## Tradeoffs

* Provisioned the following resources manually:
		* IAM User (john.carln)
		* VPC (ck-infra-homework)
		* RDS instance


## Architecture Design Goals

With a budget of 10 hours, decided to demonstrate provisioning an auto-scaling application with Terraform, Packer and Ansible. Focused on using Terraform for auto-scaling resources (autoscaling group, launch configuration, application load balancer and security groups).

### VPC

Allocate a /16 network (65k addresses) with one DMZ and one private subnet per availability zone (AZ). Each AZ should have a continuous block of addresses.

### Auto-scaling Application Resources

I probably spent at least half the time budget here. The first big component was making a playbook to create an AMI with Ruby 2.4.2 and other dependencies to run the application. From here, 

### RDS

Simply needed a dedicated RDS instance with a copy of the default parameter group.


### Secrets

Terraform? git-crypt? S3 + IAM instance profile?

## Tradeoffs

Opted to point the application load balancer directly at the puma processes and let the application serve static assets. Did this to save time provisioning and configuring a frontend web server.

Chose to provision the VPC via the AWS management console to save time. I think coding this was too expensive for the time constraint as there are many resources (VPC, six subnets, NAT gateway, Internet gateway, two route tables, six route table associations and probably more).

Chose to provision the RDS instance manually. This would have been relatively inexpensive to implement in Terraform, but not provide a substantial improvement to the solution. Chose free tier pricing for the instance, which makes multi-AZ durability unavailable.

There is no code for running database migrations or seeding the database. Did not have the time budget to limit migrations to running on a single host or ensuring that `seeds.rb` was run only once.

Picked Ubuntu 14.04 over 16.04 for familiarity with Upstart.

Test suite was just stubbed out from generators, so did not consider running tests as part of deployment.

Needed to install nodejs and npm from nodesource repositories. Asset compilation worked with Ubuntu package, so skipped this task.

## Headaches and Lessons

* Do not "freshen up" your toolbox before you're beginning something with a hard time constraint
* After working in services for a while, had to redresh my memory on the Asset Pipeline
* Packer mysteriously refused to authenticate to make my AMI. Tried tweaking a bunch of config and looked for open GitHub issues. Turned out there was some gremlin in my local ssh-agent.
* Used Vagrant to build out the Ansible playbook to create the AMI. This significantly sped the feedback loop while coding.
