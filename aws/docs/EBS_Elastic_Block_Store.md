## Elastic Block Store (EBS) Volume

An EC2 machine loses its root volume when it is terminated manually or unexpectedly.
An EBS Volume is a **network** drive you can attach to your instances while they run. It allows your instances to persist data.

- Network drive (not physical)
  - Uses the network to communicate the instance - a bit of latency
  - Can be detached from an EC2 instance and attached to another one quickly
- It locked to an AZ
  - To move a volume across, you first need to snapshot it and restore it in another AZ
  - EBS backups use IO and you shouldn't run them while your application is handling a lot of traffic.
- Have a provisioned capacity (size in GBs, and IOPS)
  - Get billed for all the provisioned capacity
  - Capacity can be increased over time
- Root EBS Volumes of instances get terminated by default if the EC2 instance get terminated.
  - You can disable that

### Volumes and Snapshots

#### Volume
- Location: EBS volumes will always be in the same AZ as EC2.
- Resizing: You can resize EBS volumes on the fly. You don't have to stop or restart the instance. But you will need to extend the filesystem in the OS so the OS can see the resized volume.
- Volume type: You can change volume types on the fly (e.g. from GP2 to IO2).
#### Snapshots
- Snapshots exist on S3
- Snapshots are incremental. Only the data that has been changed since your last snapshot are moved to S3. Hence the first snapshot may take some time to create.

##### Tips
- Consistnet snapshots. Snapshots only capture data that has been written to your EBS volume (exclude any data in cache). For a consistent snapshot, it is recommended to stop the instance and take a snap.
- Encrypted snapshot. If you take a snapshot of an encrypted EBS volume, the snapshot will be encrypted automatically.
- Sharing snapshots. You can share snapshots, but only in the region in which they were created. To share to other regions, you will need to copy them to the destination region first.

### Concepts: IOPS vs Throughput
#### IOPS
- Measures the number of read and write operations per second.
- Important metric for quick transactions, low-latency apps, transactional workloads.
- The ability to action reads and writes very quickly
- Choose Provisioned IOPS SSD (IO1 or IO2)

#### Throughput
- Measures the number of bits read or written per second (MB/s)
- Important metric for large datasets, large I/O sizes, complex queries
- The ability to deal with large datasets
- Choose Throughput Optimized HDD (ST1)

### EBS Volume Types

EBS Volumes are characterised in Size/ Throughput / IOPS (I/O Ops Per Sec)

- GP2 (SSD): ***General purpose** SSD* volume that balances price and performance for a wide variety of workloads
  - 1 GiB - 16 TiB
  - Min IOPS is 100, Max IOPS is 16,000 (3 IOPS per GB, means at 5334GB we are at the max IOPS)
  - Small GP2 volumes (< 1 TiB) can burst up to 3000 IOPS 
  - Up to 99.9% durability
  - Recommended for most workloads
    - System boot volumes
    - Virtual desktops
    - Low-latency interactive apps
    - Development and test envs
- GP3 (SSD): *General Purpose SSD*
  - Predictable 3,000 IOPS baseline performance and 125 MiB/s regardless of volume size.
  - Customers looking for higher performance can scale up to 16,000 IOPS and 1,000 MiB/s for an additional fee.
  - (The top performance of gp3 is 4 times faster than max throughput of gp2 volumes)
  - Up to 99.9% durability
  - Ideal for applications that require high performance at a low cost
    - Such as MySQL, Cassandra, virtual desktops and Hadoop analytics
- IO1 (SSD): *Highest-performance SSD* volume for mission-critical low-latency or high-throughput workloads
  - 4 GiB - 16 TiB
  - IOPS is provisioned (PIOPS) - Min 100 - Max 64,000 (Nitro instances) else Max 32,000 (other instances)
  - The max ratio of provisioned IOPS to requested volume is 50 IOPS per GB
  - Most expensive
  - Up to 99.9% durability
  - Critical business applications that require sustained IOPS performance, or more than 16,000 IOPS per volume (GP2 limit)
    - I/O-intensive applications
    - Large database workloads
    - Latency-sensitive workloads
- IO2 (SSD):
    - Higher durability and more IOPS
        - 500 IOPS per GiB (up to 64,000 IOPS)
        - 99.999% durability instead of up to 99.9%
    - Suitable for apps that need high levels of durability.
- ST1 (HDD): *Low cost HDD* volume designed for frequently accessed, throughput-intensive workloads
  - Streaming workloads requiring consistent, fast throughput at a low price.
    - Big data, Data warehouses, Log processing
    - Apache Kafka
  - Cannot be a boot volume
  - 500 GiB - 16 TiB
  - Max IOPS is 500
  - Throughput
    - Baseline throughput of 40 MB/s per TB
    - Can burst up to 250 MB/s per TB
    - Max throughput of 500 MB/s per volume
- SC1 (HDD): *Lowest cost HDD* volume designed for less frequently accessed workloads
  - Throughput-oriented storage for large volumes of data that is infrequently accessed
    - Scenarios where the lowest storage cost is important
  - Cannot be a boot volume
  - 500 GiB - 16 TiB
  - Max IOPS is 250
  - Throughput
    - Baseline throughput of 12 MB/s per TB
    - Can burst up to 80 MB/s per TB
    - Max throughput of 250 MiB/s per volume

**Note:** Only GP2 and IOI can be used as boot volumes. And you don't have to remember IOPS for the exam, only those use cases.

#### EBS vs Instance Store

Some instance don't come with Root EBS volumes. Instead, they come with "Instance Store" (= ephemeral storage). Instance store is *physically* attached to the machine. (EBS is a network drive)

Instance store volumes are sometimes called ephemeral storage. Instance store volumes **cannot be stopped**.
If the underlying host fails, you will lose your data. You can, however, reboot the isntance without losing your data.

If you delete the instace, you will lose the instance store volume.

- Disks up to 7.5 TiB
- Block Storage (just like EBS)
- Risk of data loss if hardware fails

**Pros:**

- Better I/O performance (very high IOPS)
- Good for buffer/ cache/ scratch data/ temporary content
- Data survives reboots

**Cons:**

- On stop or termination, the instance store is lost
- You can't resize the instance store
- Backups must be operated by the user

### EBS Encryption
EBS encrypts your volume with a data key using the industry-standard AES-256 algorithm.
EBS encryption uses AWS Key Management Service (AWS KMS) customer master keys (CMK) when creating encrypted volumes and snapshots.

#### What happens when you encrypt an EBS Volume?
- Data at rest is encrypted inside the volume
- All data in fight moving between the instance and the volume is encrypted
- All snapshots are encrypted
- All volumes created from the snapshot are encrypted

#### How to Encrypt Volumes
1. Create a snapshot of the unencrypted root device volume
2. Craete a copy of the snapshot and select the encrypt option
3. Create an AMI from the encrypted snapshot
4. Use that AMI to launch new encrypted instance

## EFS - Elastic File System

Managed NFS (Network File System) that can be mounted on many EC2 even accross multi-AZ.
It is highly available, scalable, expensive (3x gp2), pay per use.

- Use cases: Content management, web servers, data sharing.

- Uses NFSv4.1 protocol
- Uses security group to control access to EFS
- Compatible with Linux based AMI (not Windows)
- Encryption at rest using KMS
- POSIX file system (~Linux) that has a standard file API
  - Read-after-write consistency
- File system scales automatically, pay-per-use, no capacity planning required

### EFS - Performance & Storage Classes

#### EFS Scale

- 1000s of concurrent NFS clients, 10 GB+/s throughput
- Grow to Petabyte-scale network file system, automatically

#### Performance mode

Set at EFS creation time:

- General purpose (default): latency-sensitive use cases (web server, CMS, etc.
- Max I/O - high latency, throughput, highly parallel (big data, media processing, etc.)

#### Storage Tiers

Lifecycle management feature - move file after N days

- Standard: for frequently accessed files
- Infrequent access (EFS-IA): cost to retrieve files, lower price to store

## FSx for Windows
Amazon FSx for Windows File Server provides a fully managed native Microsoft Windows file system so you can easily move your Windows-based application that require file storage to AWS.
(Amazon FSx is built on Windows Server. It's a centralized storage for Windows-based applications.)

## Amazon FSx for Lustre
A fully managed file system that is optimized for compute-intensive workloads.

- Hundreds of GB per second of thoughput, millions of IOPS and sub-millisecond latencies.

Useful when you need high-speed, high-capacity distributed storage:
- High Performance Computing
- Machine Learning
- Media Data Processing Workloads
- Financial modeling
- Electronic Design Automation

## AWS Backup
Supported services: EC2, EBS, EFS, Amazon FSx for Lustre, Amazon FSx for Windows File Server, and AWS Storage Gateway.
Backup can be used with AWS Organisaitons to back up multiple AWS accouns in your organization.

### Benefits
- Central Management: A single, central backup console, allowing you to centralize your backups across multiple AWS services and multiple AWS accounts.
- Automation: You can create automated backup schedules and retention policies. You can also create lifecycle policies to expire unnecessary backups after a period of time.
- Improved Compliance: Backup policies can be enforced while backups can be encrypted both at rest and in transit, allowing alighment to regulatory compliance. Auditing is made easy due to a consolidated view of backups across many AWS services.
