# Homework Notes

## Mission

Deploy autoscaling, immutable infrastructure to run a Rails app in 10 hours or less using Terraform, Packer and Ansible. Tall order.

## High-level Goals

Create a deployment artifact (AMI) and use that as the heart of the provisioning process. Quickly create a well-designed VPC using the largest CIDR block AWS offers. Demonstrate using Terraform to distinguish resource provisioning from configuration management.

### VPC

Allocate a /16 network (65k addresses) with one DMZ and one private subnet per availability zone (AZ). Each AZ should have a continuous block of addresses.

### Auto-scaling Application Resources

I probably spent at least half the time budget here. The first big component was making a playbook to create an AMI with Ruby 2.4.2 and other dependencies to run the application. From here, used Terraform to stand up and test individual instances. Once solid, created launch configuration and autoscaling group resources.

### Secrets

For managing secrets, find the fastest path possible to segregate secrets from code. For this assignment, relied on an S3 bucket to hold a shell script which exports secrets. Created an IAM role with an S3 Read Only policy and attached it to application instances. This allows the instance to pull the secrets from S3 at launch.

## Tradeoffs

Chose to provision the VPC via the AWS management console to save time. I think coding this was too expensive for the time constraint as there are many resources (VPC, six subnets, NAT gateway, Internet gateway, two route tables, six route table associations and probably more).

Chose to provision the RDS instance manually. This would have been relatively inexpensive to implement in Terraform, but not provide a substantial improvement to the solution. Chose free tier pricing for the instance, which makes multi-AZ durability unavailable.

There is no code for running database migrations or seeding the database. Did not have the time budget to limit migrations to running on a single host or ensuring that `seeds.rb` was run only once.

Opted to point the application load balancer directly at the puma processes and let the application serve static assets. Did this to save time provisioning and configuring a frontend web server.

Bailed on using Terraform for provisioning an application load balancer. Was hitting some weird case where no instance registered as healthy, despite being able to see page loads on individual instances.

Picked Ubuntu 14.04 over 16.04 for familiarity with Upstart.

Test suite was just stubbed out from generators, so did not consider running tests as part of deployment.

Needed to install nodejs and npm from nodesource repositories. Asset compilation worked with Ubuntu package, so skipped this task.

ruby-install Ansible role is not idempotent. It will happily run every time, but the playbook is not intended to be run multiple times on a single server.

No log rotation, no metrics. Instances are pretty stock aside from what was configured with Ansible.

## Headaches and Lessons

* Do not "freshen up" your toolbox before you're beginning something with a hard time constraint
* After working in services for a while, had to redresh my memory on the Asset Pipeline
* Packer mysteriously refused to authenticate to make my AMI. Tried tweaking a bunch of config and looked for open GitHub issues. Turned out there was some gremlin in my local ssh-agent.
* Used Vagrant to build out the Ansible playbook to create the AMI. This significantly sped the feedback loop while coding.
* Maybe when you're under a time constraint, you may want to punt on refactoring Ansible tasks into roles.
* Should have tiered the AMIs, creating an AMI with just Ruby first and then deriving child AMIs for application changes.
* Really made a push for provisioning a load balancer under the time cap, but was cut short.
