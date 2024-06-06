locals {
  sqs_name = "${var.logical_product_family}-${var.logical_product_service}-sqs-${random_integer.priority.result}"
}
