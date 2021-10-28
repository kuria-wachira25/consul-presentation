
resource "aws_iam_role" "aws_iam_role_assume_ec2_role" {
  name               = "allow-assume-ec2-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_policy" "aws_iam_policy_describe_ec2_instances" {
  name   = "allow-describe-ec2-instances"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "ec2:DescribeInstances",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_policy_attachment" "describe_ec2_and_assume_ec2_role_policy_attachment" {
  name       = "describe-ec2-and-assume-ec2-role-policy-attachment"
  roles      = [aws_iam_role.aws_iam_role_assume_ec2_role.name]
  policy_arn = aws_iam_policy.aws_iam_policy_describe_ec2_instances.arn
}

resource "aws_iam_instance_profile" "allow_consul_retry_rejoin_iam_instance_profile" {
  name  = "allow-consul-retry-rejoin-iam-instance-profile"
  role  = aws_iam_role.aws_iam_role_assume_ec2_role.name
}