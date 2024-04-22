variable "adgroupName" {
  type = string
  description = "Name of the AD Group"
}

variable "memberAdGroup" {
  type = string
  description = "AD Group member"
}


variable "users" {
  description = "A list of users to add"
  type = map(object({
    email     = string,
    user_type = string
  }))
  # default = {
  #   "member1" = {
  #     email     = "member1@abc.com",
  #     user_type = "Member"
  #   },
  #   "member2" = {
  #     email     = "SVC-ServiceAccount@abc.com",
  #     user_type = "Member"
  #   },
  #   "member3" = {
  #     email     = "guestuser@abc.com",
  #     user_type = "Guest"
  #   }
  # }
}

variable "identityid" {
  type = string
  description = "object id or Id of ManagedIdentity or SPN"  
}