variable "vm" {
    type = list(string)
  default = [
    "bob", "lala"
  ]
}

variable "ec2_instance_group_tag" {
  default = "ec2-basics"
}

variable "vpcId" {
  default = "vpc-0ddc810fb905177f9"

}