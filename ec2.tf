# Part 1: simulated on-premises file server.
# Optional: some accounts have an org SCP denying ec2:RunInstances outright.
# The DataSync pipeline itself is S3-to-S3 and doesn't depend on this instance.

resource "aws_instance" "datasync_test_server" {
  count = var.create_test_server ? 1 : 0

  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  subnet_id              = data.aws_subnet.private.id
  vpc_security_group_ids = [data.aws_security_group.private_compute.id]

  tags = merge(var.tags, {
    Name = "datasync-test-server"
  })
}
