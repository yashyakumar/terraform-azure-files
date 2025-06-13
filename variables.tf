variable "instance_type" {
  type = string
  description = "This will specify the instance to be used"
  default = "Standard_B1s"
}

variable "name_prefix" {
  type = string
  description = "Provide the prefix for the instance name to create a unique name"
  default = "Terra-Instance"
  
    
}


variable "instance_count" {

    type = number
    description = "This will tell the number of instances you will need to create"
    default = 1

    validation {
      condition =var.instance_count % 1 == 0
      error_message = "The instace count must be a whole number"
    }

    validation {
      condition = var.instance_count >0 && var.instance_count <=5
      error_message = "You can't create more than 5 instances "
    }
  
}

variable "user_assigned_identities" {

 type=list(string)
 default = [] 
}