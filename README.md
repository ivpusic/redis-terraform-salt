# redis-terraform-salt
Terraform configuration to create infrastructure for Redis 4 cluster which are going to be provisioned by salt

### Directory structure
- `salt` (saltstack formula to provision minions with redis 4)
- `modules` (terraform modules to create infrastructure for salt master/minions and redis nodes)
- `main.tf.example` (terraform example configuration)

### Remarks
- Currently security groups created by terraform for redis and salt servers allow all traffic. If you intend to use this project, it is highly recommened to update security groups config.

### References
- https://saltstack.com/
- https://www.terraform.io/
- https://redis.io/

## License
*MIT*
