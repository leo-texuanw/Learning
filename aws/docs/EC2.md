## EC2

### EC2 Instance Metadata

Allows EC2 instances to get its own information like IAM Role name (but not the IAM policy) by visiting `http://169.254.169.254/` inside the instance.

- Metadata: info about the EC2 instance
- Userdata: launch script of the EC2 instance

e.g. (always remember the last '/')

```
curl http://169.254.169.254/latest/meta-data/
```

### Security Group
Deny all inbound and allow all outbound traffic by default.

Can reference:
- IP address
- CIDR block
- Security group
- **Not** DNS name

### EC2 User Data
Script runs only once when the instance started.

### EC2 Instance Types
- On Demand: Short workload, predictable pricing
    - Highest cost
    - Suitable for short-term and un-interrupted workloads
- Reserved: Long workloads (>= 1Y) - Up to 75% discount compared to On-demand
    - Standard Reserved: Up to 72% off the on-demand price.
    - Convertible Reserved: Long workloads with flexible instances (54% discount)
        - Has the option to change to a different RI type of equal or greater value.
    - Scheduled Reserved: e.g. 3 to 6 pm every Thursday
    - You can make upfront payments to reduce the total computing costs even further.
- Spot Instance: short workloads, for cheap, can lose instances (less reliable)
- Dedicated Instances:
    - No other customers will share your hardware (share within your account)
    - Hardware after stop/ start may move
- Dedicated Hosts: book an entire physical server, control instance placement
    - On-demand: Can be purchased on-demand (hourly)
    - Reserved: Can be purchased as a reservation for up to 70% off the on-demand price.
    - Used for example when you have compliance or licence to meet.

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
- Create a management network
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

