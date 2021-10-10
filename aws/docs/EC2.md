## EC2

### EC2 Instance Metadata

Allows EC2 instances to get its own information like IAM Role name (but not the IAM policy) by visiting `http://169.254.169.254/` inside the instance.

- Metadata: info about the EC2 instance
- Userdata: launch script of the EC2 instance

e.g. (always remember the last '/')

```
curl http://169.254.169.254/latest/meta-data/
```

### AMI
Amazon Machine Image (AMI) provides the information required to launch an instance.
- Region
- Operating system
- Architecture (32 or 64-bit)
- Launch permissions
- Storage for the root device (root device volume)

All AMIs are categrized as either backed by:
- Amazon EBS: The root device for an instance launched from the AMI is on Amazon EBS volume created from an Amazon EBS sanpshot
- Instance Store: The root device for an instance launched from the AMI is an instance store volume created from a template stored in Amazon S3

### Security Group
Deny all inbound and allow all outbound traffic by default.

Can reference:
- IP address
- CIDR block
- Security group
- **Not** DNS name

Notes:
- Changes to security groups take effect immediately
- You can have any number of EC2 instances within a security group
- You can have multiple security groups attached to EC2 instances

### EC2 User Data
Script runs only **once** when the instance started.

### EC2 Instance Types
- On Demand: Short workload, predictable pricing
    - Highest cost
    - Suitable for short-term and un-interrupted workloads
- Reserved: Long workloads (1Y - 3Y), great if you have known, fixed requirements
    - Standard Reserved: Up to 72% off the on-demand price.
    - Convertible Reserved: Long workloads with flexible instances (54% discount)
        - Has the option to change to a different RI type of equal or greater value.
    - Scheduled Reserved: e.g. 3 to 6 pm every Thursday
    - You can make upfront payments to reduce the total computing costs even further.
- Spot Instance: short workloads, for cheap, can lose instances (less reliable)
    - Save up to 90% of the cost
    - Stateless, fault-tolerant or flexible applications (such as big data, image and media rendering, containerized workloads, CI/CD, HPC and other test and dev workloads)
    - **Spot block**: To stop your spot instances from being terminated even if the spot price goes over your max spot price.
        - You can set spot blocks for between 1 to 6 hours currently
    - Spot fleets: A collection of spot instances and (optionally) on-demand instances. The spot fleet attempts to launch and maintain its target capacity fleet with your price restraints.
        - Launch pools: Define things like EC2 instance type, operating system and AZ (You can have multiple pools)
        - strategies:
            - lowerPrice (default)
            - capacityOptimized: The spot instances come from the pool with optimal capacity
            - diversified: The spot instances are distributed across all pools
            - InstancePoolsToUseCount (only valid with lowerPrice): Spot instances are distributed across the pools you specify 
    - If your spot instance has been marked for termination, a notification will be posted to the metadata of your EC2 instance 2 minutes before it is stopped or terminated.
- Dedicated Instances:
    - Book an entire physical server, control instance placement. No other customers will share your hardware (share within your account)
    - On-demand: Can be purchased on-demand (hourly)
    - Reserved: Can be purchased as a reservation for up to 70% off the on-demand price.
    - Hardware after stop/ start may move
    - Great if you have serverbound licenses to reuse or compliance requirements

Great combo: Reserved instances for baseline + On-demand & Spot for peaks



### EC2 Virtual Networking Cards
#### Elastic Network Interfaces (ENI)

Logical component in a VPC that represents a virtual network card for basic, day-to-day networking.

The ENI can have the following attributes:

- Primary private IPv4, one or more secondary IPv4
- One Elastic IP per private IPv4
- One Elastic IP per public IPv4
- Many IPv6 addresses
- One or more security groups
- A MAC address

You can create ENI independently and attach them on the fly on EC2 instances for failover. But it's bound to a specific AZ.

##### Use Cases
- Create a management network from your production network
- Use network and security appliances in your VPC
- Create dual-homed instances with workloads/roles on distinct subnets
- Create a low-budget, high-availability solution

#### Enhanced Networking (EN)
For High-Performance Networking between 10 Gbps - 100 Gbps
- Uses single root I/O virtualization (SR-IOV)
    - SR-IOV provides higher I/O performance and lower CPU utilization
- Performance
    - Provides higher bandwidth, higher packet per second (PPS) performance, and consistently lower inter-instance latencies.

#### Elastic Fabric Adapter (EFA)
A network device you can attach to your EC2 instance to accelerate High Performance Computing (HPC) and machine learning application.
Provides lower and more consistent latency and higher throughput than the TCP transport traditionally used in cloud-based HPC systems.

### Optimizing with EC2 Placement Groups
Note:
- Only certain types of instances can be launched in a placement group (compute optimized, GPU, memory optimized, storage optimized)
- You can't merge placement groups
- You can move an existing instance into a placement group (in stoppped state)
    - using CLI, SDK, not console yet.

#### Cluster Placement Groups
Grouping of instances within a single AZ.
- Recommended for applications that need low network latency, high network throughput or both.
- AWS recommends homogenous instances within cluster placement groups

#### Spread Placement Groups
A group of instances that are each placed on distinct underlying hardware.
- Recommended for applications that have a small number of critical instances that should be kept separate from each other.

#### Partition Placement Groups
Each partition placement group has its own set of racks. Each rack has its own network and power source. It isolates the impact of hardware failure within your application.

### EC2 Hibernation
By default, the root device volume will be terminated when the instance is terminated.  
When you hibernate an EC2 isntance, the operating system is told to perform hibernation (suspend-to-disk).
Hibernation saves the contents from the instance memory to your Amazon EBS root volume. We persist the instance's Amazon EBS root volume and any attached Amazon EBS data volumes.

With EC2 hibernation, the instance boots much faster. The operating system does not need to reboot because the in-memory state (RAM) is preserved. This is useful for:
- Long-running processes
- Services that take time to initialize

Note: The instance RAM must be less than 150 GB. And the instances can't be hibernated for more than 60 days.
