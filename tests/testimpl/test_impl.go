package common

import (
	"context"
	"encoding/json"
	"testing"

	"github.com/aws/aws-sdk-go-v2/aws"
	"github.com/aws/aws-sdk-go-v2/config"
	"github.com/aws/aws-sdk-go-v2/service/sns"
	"github.com/aws/aws-sdk-go-v2/service/sqs"
	"github.com/gruntwork-io/terratest/modules/terraform"

	"github.com/launchbynttdata/lcaf-component-terratest/types"
	"github.com/stretchr/testify/require"
)

func TestDoesSnsTopicExist(t *testing.T, ctx types.TestContext) {
	snsClient := sns.NewFromConfig(GetAWSConfig(t))
	sqsClient := sqs.NewFromConfig(GetAWSConfig(t))
	snsTopicArn := terraform.Output(t, ctx.TerratestTerraformOptions(), "sns_topic_arn")
	queueUrl := terraform.Output(t, ctx.TerratestTerraformOptions(), "queue_url")
	message := "Hello, World!"

	t.Run("TestDoesTopicExist", func(t *testing.T) {
		output, err := snsClient.GetTopicAttributes(context.TODO(), &sns.GetTopicAttributesInput{
			TopicArn: &snsTopicArn})
		if err != nil {
			t.Errorf("Error getting topic attributes: %v", err)
		}

		require.NotNil(t, output.Attributes, "Topic attributes should not be nil")
		require.Equal(t, snsTopicArn, (*output).Attributes["TopicArn"], "Topic ARN should match")
	})

	t.Run("TestCanPublishMessage", func(t *testing.T) {
		publishInput := &sns.PublishInput{
			Message:  &message,
			TopicArn: &snsTopicArn,
		}

		publishResp, err := snsClient.Publish(context.TODO(), publishInput)
		if err != nil {
			t.Errorf("Error publishing message to SNS: %v", err)
		}
		require.NotNil(t, publishResp.MessageId, "Message ID should not be nil")
	})

	t.Run("TestCanReceiveMessage", func(t *testing.T) {
		receiveMessageInput := &sqs.ReceiveMessageInput{
			QueueUrl:            &queueUrl,
			MaxNumberOfMessages: 1,
			WaitTimeSeconds:     10,
			VisibilityTimeout:   15,
		}

		msgResult, err := sqsClient.ReceiveMessage(context.TODO(), receiveMessageInput)
		if err != nil {
			t.Errorf("Error receiving messages from SQS: %v", err)
		}
		require.Equal(t, 1, len(msgResult.Messages), "Expected 1 message")

		var data map[string]string
		errJsonMsg := json.Unmarshal([]byte(*msgResult.Messages[0].Body), &data)
		require.NoError(t, errJsonMsg, "Error parsing message body")

		require.Equal(t, message, data["Message"], "Message body should match")
	})
}

func GetAWSConfig(t *testing.T) (cfg aws.Config) {
	cfg, err := config.LoadDefaultConfig(context.TODO())
	require.NoErrorf(t, err, "unable to load SDK config, %v", err)
	return cfg
}
