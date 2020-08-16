

## ターゲットグループとルールの作成

tg_name="fargate-go-sample-03"
vpc="vpc-00719c31157a35601"

aws elbv2 create-target-group --name ${tg_name} --protocol HTTP --port 8080 --vpc-id ${vpc} --region=ap-northeast-1 \
--target-type ip


aws elbv2 describe-rules \
    --listener-arn arn:aws:elasticloadbalancing:ap-northeast-1:460256653427:listener/app/fargate-go-example/d5989033971c7780/64a0d65bd51f0100



aws elbv2 create-rule \
--listener-arn arn:aws:elasticloadbalancing:ap-northeast-1:460256653427:listener/app/fargate-go-example/d5989033971c7780/64a0d65bd51f0100 \
--priority 10 \
--conditions file://rule.json \
--actions Type=forward,TargetGroupArn=arn:aws:elasticloadbalancing:ap-northeast-1:460256653427:targetgroup/fargate-go-sample-02/4efecc343ed57024


## リスナーの作成
ALB_ARN="arn:aws:elasticloadbalancing:ap-northeast-1:460256653427:loadbalancer/app/fargate-go-example/d5989033971c7780"
aws elbv2 create-listener --load-balancer-arn ${ALB_ARN} --protocol HTTP --port 80 --default-actions Type=forward,TargetGroupArn=arn:aws:elasticloadbalancing:ap-northeast-1:460256653427:targetgroup/fargate-go-sample-01/0ce2301c32232904

