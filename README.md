# Terraform Jaeger

Terraform deployment of Jaeger

[![Snyk Infrastructure as Code](https://github.com/mikesupertrampster-corp/terraform-jaeger/actions/workflows/snyk.yml/badge.svg)](https://github.com/mikesupertrampster-corp/terraform-jaeger/actions/workflows/snyk.yml) [![gitleaks](https://github.com/mikesupertrampster-corp/terraform-jaeger/actions/workflows/gitleaks.yml/badge.svg)](https://github.com/mikesupertrampster-corp/terraform-jaeger/actions/workflows/gitleaks.yml) [![Codacy Badge](https://app.codacy.com/project/badge/Grade/eb92b423307e4e10829796e072485f15)](https://www.codacy.com/gh/mikesupertrampster-corp/terraform-jaeger/dashboard?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=mikesupertrampster-corp/terraform-jaeger&amp;utm_campaign=Badge_Grade) [![Infracost estimate](https://img.shields.io/badge/Infracost-estimate-5e3f62)](https://dashboard.infracost.io/share/rzv9faacta42sjp5ryem8lu7nb91e9q2)

## Resources

   * ECS Task
   * Load Balancer Target Group

## Cost

Estimate cost generated using [Infracost](https://github.com/Infracost/infracost)

```
 Name                                                Monthly Qty  Unit                  Monthly Cost 
                                                                                                     
 module.jaeger.aws_cloudwatch_log_group.jaeger                                                       
 ├─ Data ingested                               Monthly cost depends on usage: $0.57 per GB          
 ├─ Archival Storage                            Monthly cost depends on usage: $0.03 per GB          
 └─ Insights queries data scanned               Monthly cost depends on usage: $0.0057 per GB        
                                                                                                     
 module.jaeger.aws_ecs_service.jaeger                                                                
 ├─ Per GB per hour                                          0.5  GB                           $1.62 
 └─ Per vCPU per hour                                       0.25  CPU                          $7.39 
                                                                                                     
 module.jaeger.aws_route53_record.jaeger                                                             
 ├─ Standard queries (first 1B)                 Monthly cost depends on usage: $0.40 per 1M queries  
 ├─ Latency based routing queries (first 1B)    Monthly cost depends on usage: $0.60 per 1M queries  
 └─ Geo DNS queries (first 1B)                  Monthly cost depends on usage: $0.70 per 1M queries  
                                                                                                     
 OVERALL TOTAL                                                                                 $9.01 
──────────────────────────────────
12 cloud resources were detected:
∙ 3 were estimated, 2 of which include usage-based costs, see https://infracost.io/usage-file
∙ 9 were free:
  ∙ 2 x aws_iam_role
  ∙ 2 x aws_security_group_rule
  ∙ 1 x aws_ecs_task_definition
  ∙ 1 x aws_iam_role_policy_attachment
  ∙ 1 x aws_lb_listener_rule
  ∙ 1 x aws_lb_target_group
  ∙ 1 x aws_security_group
```