# DevOps / SRE Task

## Premisses

- Use Terraform as IaaC.
- Use Ansible to configure host services.
- Use the smallest instances; it could be the free tier, don’t worry.
- Docker logs must be delivered to Cloudwatch.
- Deliver it to a git repository (Github for example).
- Provide a README.md with instructions to reproduce.
- Please, include to the README.md how did you come with the solution (Google, Book, Manual, Stackoverflow). The source of your information is welcome.

## What to deliver

### Using Terraform

```txt
- VPC 10.161.0.0/24.
- 3 Subnets: 1 per availability zone.
- 3 EC2 instances.
- ALB serving port 80 of each instance.
```

### Using Ansible

```txt
- Deploy and configure an Nginx Docker container on each EC2 instance.
- Each nginx instance must have a different index.html (e.g. Hello, server1; Hello, server2; Hello, server3). Use Jinja2.
```

For further clarifications, please contact the recruitment contact.
