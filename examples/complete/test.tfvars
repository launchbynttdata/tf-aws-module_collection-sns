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
delay_seconds           = 0
fifo_queue              = false
logical_product_family  = "terratest"
logical_product_service = "snsmodule"
