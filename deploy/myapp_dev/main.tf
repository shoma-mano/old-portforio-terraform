locals {
  EnvironmentName="develop"
}

module "vpc" {
  source = "../modules/vpc"

  EnvironmentName = local.EnvironmentName
  PrivateSubnetCIDRs = [
    "",
  ]
  PublicSubnetCIDRs = [
    "",
  ]

  vpcCIDR = ""
}

module "elb"{
  source = "../modules/elb"
  EnvironmentName = local.EnvironmentName
  AlbSubnet = module.vpc.PublicSubnets.*.id
  Route53ElbDnsName = module.elb.MainElb.dns_name
}

module "common"{
  source = "../modules/common"
  EnvironmentName = local.EnvironmentName
}

module "keycloak" {
  source = "../modules/ecs"
  EnvironmentName = local.EnvironmentName

  ClusterId = module.common.ClusterId
  ServiceName = "keycloak"
  TaskCount = 1
  TaskName = "KeyCloak"

  ContainerDefinitios = [{
    logConfiguration: {
      "logDriver": "awslogs",
      "options": {
        "awslogs-group": "/ecs/keycloak",
        "awslogs-region": "ap-northeast-1",
        "awslogs-stream-prefix": "ecs"
      }
    },
    portMappings: [
      {
        hostPort: 8080,
        protocol: "tcp",
        containerPort: 8080
      }
    ],
    cpu: 0,
    environment: [
      {
        name: "DB_ADDR",
        value: module.common.db_endpoint
      },
      {
        name: "DB_PASSWORD",
        value: ""
      },
      {
        name: "DB_PORT",
        value: "3306"
      },
      {
        name: "DB_USER",
        value: "admin"
      },
      {
        name: "DB_VENDOR",
        value: "mysql"
      },
      {
        name: "JDBC_PARAMS",
        value: "useSSL=false&autoReconnect=true"
      },
      {
        name: "JGROUPS_DISCOVERY_PROPERTIES",
        value: "datasource_jndi_name=java:jboss/datasources/KeycloakDS,remove_all_data_on_view_change=true,remove_old_coords_on_view_change=true,clear_table_on_view_change=true"
      },
      {
        name: "JGROUPS_DISCOVERY_PROTOCOL",
        value: "JDBC_PING"
      },
      {
        name: "KEYCLOAK_PASSWORD",
        value: ""
      },
      {
        name: "KEYCLOAK_USER",
        value: "admin"
      },
      {
        name: "PROXY_ADDRESS_FORWARDING",
        value: "true"
      }
    ],
    image: "jboss/keycloak:latest",
    name: "keycloak"
  }]

  ServiceSubnets = module.vpc.PublicSubnets[*].id
  ServiceSecurityGroups = [module.vpc.ContainerSecurityGroup.id]
  TargetGroupArn = module.elb.KeycloakTargetGroup.arn

}



module "backend"{
  source = "../modules/ecs"
  EnvironmentName = local.EnvironmentName

  ServiceName = "backend"
  TaskCount = 1
  TaskName = "backend"
  ClusterId = module.common.ClusterId

  ContainerDefinitios = [
    {
      command          = [
        "java -jar backend.jar",
      ]
      cpu              = 0
      entryPoint       = [
        "sh",
        "-c",
      ]
      environment      = []
      essential        = true
      image            = ""
      logConfiguration = {
        logDriver = "awslogs"
        options   = {
          awslogs-group         = "/ecs/backend"
          awslogs-region        = "ap-northeast-1"
          awslogs-stream-prefix = "ecs"
        }
      }
      mountPoints      = []
      name             = "backend"
      portMappings     = [
        {
          containerPort = 8080
          hostPort      = 8080
          protocol      = "tcp"
        },
      ]
      volumesFrom      = []
    },
  ]

  ServiceSecurityGroups = [module.vpc.ContainerSecurityGroup.id]
  ServiceSubnets = module.vpc.PublicSubnets[*].id
  TargetGroupArn = module.elb.BackendTargetGroup.arn
}




