// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

variable "use_name_prefix" {
  description = "Determines whether `name` is used as a prefix"
  type        = bool
  default     = false
}

variable "application_feedback" {
  description = "Map of IAM role ARNs and sample rate for success and failure feedback"
  type        = map(string)
  default     = {}
  # Example:
  # application_feedback = {
  #   failure_role_arn = "arn:aws:iam::11111111111:role/failure"
  #   success_role_arn = "arn:aws:iam::11111111111:role/success"
  #   success_sample_rate = 75
  # }
}

variable "content_based_deduplication" {
  description = "Boolean indicating whether or not to enable content-based deduplication for FIFO topics."
  type        = bool
  default     = false
}

variable "delivery_policy" {
  description = "The SNS delivery policy"
  type        = string
  default     = null
}

variable "display_name" {
  description = "The display name for the SNS topic"
  type        = string
  default     = null
}

variable "fifo_topic" {
  description = "Boolean indicating whether or not to create a FIFO (first-in-first-out) topic"
  type        = bool
  default     = false
}

variable "firehose_feedback" {
  description = "Map of IAM role ARNs and sample rate for success and failure feedback"
  type        = map(string)
  default     = {}
  # Example:
  # application_feedback = {
  #   failure_role_arn = "arn:aws:iam::11111111111:role/failure"
  #   success_role_arn = "arn:aws:iam::11111111111:role/success"
  #   success_sample_rate = 75
  # }
}

variable "http_feedback" {
  description = "Map of IAM role ARNs and sample rate for success and failure feedback"
  type        = map(string)
  default     = {}
  # Example:
  # application_feedback = {
  #   failure_role_arn = "arn:aws:iam::11111111111:role/failure"
  #   success_role_arn = "arn:aws:iam::11111111111:role/success"
  #   success_sample_rate = 75
  # }
}

variable "kms_master_key_id" {
  description = "The ID of an AWS-managed customer master key (CMK) for Amazon SNS or a custom CMK"
  type        = string
  default     = null
}

variable "lambda_feedback" {
  description = "Map of IAM role ARNs and sample rate for success and failure feedback"
  type        = map(string)
  default     = {}
  # Example:
  # application_feedback = {
  #   failure_role_arn = "arn:aws:iam::11111111111:role/failure"
  #   success_role_arn = "arn:aws:iam::11111111111:role/success"
  #   success_sample_rate = 75
  # }
}

variable "topic_policy" {
  description = "An externally created fully-formed AWS policy as JSON"
  type        = string
  default     = null
}

variable "sqs_feedback" {
  description = "Map of IAM role ARNs and sample rate for success and failure feedback"
  type        = map(string)
  default     = {}
  # Example:
  # application_feedback = {
  #   failure_role_arn = "arn:aws:iam::11111111111:role/failure"
  #   success_role_arn = "arn:aws:iam::11111111111:role/success"
  #   success_sample_rate = 75
  # }
}

variable "signature_version" {
  description = "If SignatureVersion should be 1 (SHA1) or 2 (SHA256). The signature version corresponds to the hashing algorithm used while creating the signature of the notifications, subscription confirmations, or unsubscribe confirmation messages sent by Amazon SNS."
  type        = number
  default     = null
}

variable "tracing_config" {
  description = "Tracing mode of an Amazon SNS topic. Valid values: PassThrough, Active."
  type        = string
  default     = null
}

variable "create_topic_policy" {
  description = "Determines whether an SNS topic policy is created"
  type        = bool
  default     = true
}

variable "source_topic_policy_documents" {
  description = "List of IAM policy documents that are merged together into the exported document. Statements must have unique `sid`s"
  type        = list(string)
  default     = []
}

variable "override_topic_policy_documents" {
  description = "List of IAM policy documents that are merged together into the exported document. In merging, statements with non-blank `sid`s will override statements with the same `sid`"
  type        = list(string)
  default     = []
}

variable "enable_default_topic_policy" {
  description = "Specifies whether to enable the default topic policy. Defaults to `true`"
  type        = bool
  default     = true
}

variable "topic_policy_statements" {
  description = "A map of IAM policy [statements](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document#statement) for custom permission usage"
  type        = any
  default     = {}
}

variable "create_subscription" {
  description = "Determines whether an SNS subscription is created"
  type        = bool
  default     = true
}

variable "subscriptions" {
  description = "A map of subscription definitions to create"
  type        = any
  default     = {}
}

variable "data_protection_policy" {
  description = "A map of data protection policy statements"
  type        = string
  default     = null
}

variable "created_by" {
  description = "Resource that created this resource, if any. Used as an output variable"
  type        = string
  default     = null
}

### TF Module Resource variables
variable "logical_product_family" {
  type        = string
  description = <<EOF
    (Required) Name of the product family for which the resource is created.
    Example: org_name, department_name.
  EOF
  nullable    = false

  validation {
    condition     = can(regex("^[_\\-A-Za-z0-9]+$", var.logical_product_family))
    error_message = "The variable must contain letters, numbers, -, _, and .."
  }

  default = "launch"
}

variable "logical_product_service" {
  type        = string
  description = <<EOF
    (Required) Name of the product service for which the resource is created.
    For example, backend, frontend, middleware etc.
  EOF
  nullable    = false

  validation {
    condition     = can(regex("^[_\\-A-Za-z0-9]+$", var.logical_product_service))
    error_message = "The variable must contain letters, numbers, -, _, and .."
  }

  default = "servicename"
}

variable "environment" {
  description = "Environment in which the resource should be provisioned like dev, qa, prod etc."
  type        = string
  default     = "dev"
}

variable "environment_number" {
  description = "The environment count for the respective environment. Defaults to 000. Increments in value of 1"
  type        = string
  default     = "000"
}

variable "region" {
  description = "AWS Region in which the infra needs to be provisioned"
  type        = string
  default     = "us-east-2"
}

variable "resource_number" {
  description = "The resource count for the respective resource. Defaults to 000. Increments in value of 1"
  type        = string
  default     = "000"
}

variable "resource_names_map" {
  description = "A map of key to resource_name that will be used by cloudposse/label/null module to generate resource names"
  type        = map(string)
  default = {
    sns = "sns"
  }
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "A map of tags to add to the resources created by the module."
}
