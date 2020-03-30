# https://learn.hashicorp.com/terraform/aws/eks-intro#worker-node-autoscaling-group


variable "cluster-name" {
  default = "terraform-eks-demo"
  type    = string
}


data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "demo" {
 cidr_block = "10.0.0.0/16"

 tags = {
   "Name"                                      = "terraform-eks-demo-node"
   "kubernetes.io/cluster/${var.cluster-name}" = "shared"
 }
}

resource "aws_subnet" "demo" {
 count = 2

 availability_zone = data.aws_availability_zones.available.names[count.index]
 cidr_block        = "10.0.${count.index}.0/24"
 vpc_id            = aws_vpc.demo.id

 tags = {
   "Name"                                      = "terraform-eks-demo-node"
   "kubernetes.io/cluster/${var.cluster-name}" = "shared"
 }
}

resource "aws_internet_gateway" "demo" {
 vpc_id = aws_vpc.demo.id

 tags = {
   Name = "terraform-eks-demo"
 }
}

resource "aws_route_table" "demo" {
 vpc_id = aws_vpc.demo.id

 route {
   cidr_block = "0.0.0.0/0"
   gateway_id = aws_internet_gateway.demo.id
 }
}

resource "aws_route_table_association" "demo" {
 count = 2

 subnet_id      = aws_subnet.demo[count.index].id
 route_table_id = aws_route_table.demo.id
}


resource "aws_iam_role" "demo-node" {
  name = "terraform-eks-demo-cluster"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    },
    {
      "Action": "sts:AssumeRole",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      }
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "demo-cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = "${aws_iam_role.demo-node.name}"
}

resource "aws_iam_role_policy_attachment" "demo-cluster-AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = "${aws_iam_role.demo-node.name}"
}


resource "aws_security_group" "demo-cluster" {
  name        = "terraform-eks-demo-cluster"
  description = "Cluster communication with worker nodes"
  vpc_id      = "${aws_vpc.demo.id}"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-eks-demo"
  }
}

# OPTIONAL: Allow inbound traffic from your local workstation external IP
#           to the Kubernetes. You will need to replace A.B.C.D below with
#           your real IP. Services like icanhazip.com can help you find this.
resource "aws_security_group_rule" "demo-cluster-ingress-workstation-https" {
  cidr_blocks       = ["37.201.147.137/32"]
  description       = "Allow workstation to communicate with the cluster API Server"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.demo-cluster.id
  to_port           = 443
  type              = "ingress"
}




resource "aws_eks_cluster" "demo" {
  name            = "${var.cluster-name}"
  role_arn        = "${aws_iam_role.demo-node.arn}"

  vpc_config {
    security_group_ids = [aws_security_group.demo-cluster.id]
    subnet_ids         = [aws_subnet.demo[0].id, aws_subnet.demo[1].id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.demo-cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.demo-cluster-AmazonEKSServicePolicy,
  ]
}













resource "aws_security_group" "demo-node" {
  name        = "terraform-eks-demo-node"
  description = "Security group for all nodes in the cluster"
  vpc_id      = aws_vpc.demo.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    "Name"                                      = "terraform-eks-demo-node"
    "kubernetes.io/cluster/${var.cluster-name}" = "owned"
  }
}

resource "aws_security_group_rule" "demo-node-ingress-self" {
  description              = "Allow node to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.demo-node.id
  source_security_group_id = aws_security_group.demo-node.id
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "demo-node-ingress-cluster" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control      plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = aws_security_group.demo-node.id
  source_security_group_id = aws_security_group.demo-cluster.id
  to_port                  = 65535
  type                     = "ingress"
 }














resource "aws_security_group_rule" "demo-cluster-ingress-node-https" {
  description              = "Allow pods to communicate with the cluster API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.demo-cluster.id
  source_security_group_id = aws_security_group.demo-node.id
  to_port                  = 443
  type                     = "ingress"
}








data "aws_ami" "eks-worker" {
   filter {
     name   = "name"
     values = ["amazon-eks-node-${aws_eks_cluster.demo.version}-v*"]
   }

   most_recent = true
   owners      = ["602401143452"] # Amazon EKS AMI Account ID
 }





# This data source is included for ease of sample architecture deployment
# and can be swapped out as necessary.
data "aws_region" "current" {
}

# EKS currently documents this required userdata for EKS worker nodes to
# properly configure Kubernetes applications on the EC2 instance.
# We implement a Terraform local here to simplify Base64 encoding this
# information into the AutoScaling Launch Configuration.
# More information: https://docs.aws.amazon.com/eks/latest/userguide/launch-workers.html
locals {
  demo-node-userdata = <<USERDATA
#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${aws_eks_cluster.demo.endpoint}' --b64-cluster-ca '${aws_eks_cluster. demo.certificate_authority[0].data}' '${var.cluster-name}'
USERDATA

}





resource "aws_iam_role_policy_attachment" "demo-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = "${aws_iam_role.demo-node.name}"
}

resource "aws_iam_role_policy_attachment" "demo-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = "${aws_iam_role.demo-node.name}"
}

resource "aws_iam_role_policy_attachment" "demo-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = "${aws_iam_role.demo-node.name}"
}




resource "aws_eks_node_group" "demo" {
  cluster_name    = aws_eks_cluster.demo.name
  node_group_name = "demo"
  node_role_arn   = aws_iam_role.demo-node.arn
  subnet_ids      = [aws_subnet.demo[0].id, aws_subnet.demo[1].id]

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.demo-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.demo-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.demo-AmazonEC2ContainerRegistryReadOnly,
  ]
}




