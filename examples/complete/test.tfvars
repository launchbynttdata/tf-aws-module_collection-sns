# Replace the <> with the actual values
subscriptions = [
  {
    protocol = "email"
    endpoint = "john.doe@example.com"
  },
  {
    protocol = "email"
    endpoint = "jane.doe@example.com"
  }
]
tags = {
  "provisioner" : "Terraform"
}
naming_prefix = "demo-app"
delay_seconds = 0
fifo_queue    = false
