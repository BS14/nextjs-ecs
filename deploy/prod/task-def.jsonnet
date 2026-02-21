local repository_url = "{{ tfstate `aws_ecr_repository.ecr.repository_url` }}";
local image_tag = "{{ must_env `IMAGE_TAG` }}";
local log_group = "{{ tfstate `aws_cloudwatch_log_group.ecs_logs.name` }}";

{
  family: 'nextjs-task',
  executionRoleArn: "{{ tfstate `aws_iam_role.ecs_task_execution_role.arn` }}",
  taskRoleArn: "{{ tfstate `aws_iam_role.ecs_task_role.arn` }}",
  networkMode: 'awsvpc',
  requiresCompatibilities: ['EC2'],
  cpu: '256',
  memory: '256',
  containerDefinitions: [
    {
      name: 'app',
      image: repository_url + ':' + image_tag,
      essential: true,
      portMappings: [
        {
          containerPort: 3000,
          protocol: 'tcp',
        },
      ],
      healthCheck: {
        command: ['CMD-SHELL', 'curl -f http://localhost:3000/health || exit 1'],
        interval: 30,
        timeout: 5,
        retries: 3,
        startPeriod: 60,
      },
      logConfiguration: {
        logDriver: 'awslogs',
        options: {
          'awslogs-group': log_group,
          'awslogs-region': 'us-east-1',
          'awslogs-stream-prefix': 'ecs',
        },
      },
    },
  ],
}
