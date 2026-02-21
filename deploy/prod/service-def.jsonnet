// service-def.jsonnet
{
  // std.extVar looks for a variable passed from the command line or environment.
  // If DESIRED_COUNT is not provided, it defaults to 2.
  // desiredCount: std.parseInt(std.get(std.extVar('__ecspresso_extvar'), 'DESIRED_COUNT', default='2')),
  // desiredCount: std.parseInt(std.extVar('DESIRED_COUNT') || '2'),
  //desiredCount: std.parseInt("{{ env `DESIRED_COUNT` `2` }}"),
  // desiredCount: std.parseInt(std.envVar("DESIRED_COUNT") || "2"),
  desiredCount: std.parseInt(std.extVar('DESIRED_COUNT') || '2'),

  capacityProviderStrategy: [
    {
      capacityProvider: "{{ tfstate `aws_ecs_capacity_provider.main.name` }}",
      weight: 1,
      base: 0,
    },
  ],
  deploymentConfiguration: {
    maximumPercent: 200,
    minimumHealthyPercent: 100,
    deploymentCircuitBreaker: {
      enable: true,
      rollback: true,
    },
  },
  loadBalancers: [
    {
      targetGroupArn: "{{ tfstate `aws_lb_target_group.nextjs.arn` }}",
      containerName: 'app',
      containerPort: 3000,
    },
  ],
  enableExecuteCommand: true,
  propagateTags: 'TASK_DEFINITION',
  enableECSManagedTags: true,
  tags: [
    { key: 'Environment', value: 'prod' },
    { key: 'Application', value: 'nextjs' },
    { key: 'ManagedBy', value: 'ecspresso' },
  ],
  networkConfiguration: {
    awsvpcConfiguration: {
      subnets: [
        "{{ tfstate `aws_subnet.private[0].id` }}",
        "{{ tfstate `aws_subnet.private[1].id` }}",
        "{{ tfstate `aws_subnet.private[2].id` }}",
      ],
      securityGroups: [
        "{{ tfstate `aws_security_group.ecs_nodes.id` }}",
      ],
      assignPublicIp: 'DISABLED',
    },
  },
  placementStrategy: [
    {
      type: 'spread',
      field: 'attribute:ecs.availability-zone',
    },
    {
      type: 'binpack',
      field: 'memory',
    },
  ],
}
