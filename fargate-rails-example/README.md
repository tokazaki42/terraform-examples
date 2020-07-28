
## 事前準備
ALBに設定する証明書はあらかじめ手動でACMに登録しておく。


## 手順
以下をためしてみる。
https://qiita.com/tarumzu/items/2d7ed918f230fea957e8


同じ80番をListenする別々のNginxを別々のTaskdefinitionとして起動することを
目標とする。

docker-compose.production.yml
ecs-param.production.yml
Fargate ecs-cliのインストール
Fargate構築、Dockerのビルド＆デプロイ
Fargateスケールアウト/インの設定


ecs-cliコマンドでFargateの構築及びデプロイを行います。
※ FargateはTerraformでも構築できますが、なぜecs-cliコマンドで構築したかというとデプロイ時にFargateをスケールアップ/ダウンできるようにして弾力性3を高めたかったためです。
らしい。




### ECS CLIのインストール
https://docs.aws.amazon.com/ja_jp/AmazonECS/latest/developerguide/ECS_CLI_installation.html

https://docs.aws.amazon.com/ja_jp/AmazonECS/latest/developerguide/ECS_CLI_Configuration.html


### docker-composeの変換

ecs-cli compose --project-name fargate-example --file docker-compose-nginx.yml --ecs-params ecs-params.yml create --launch-type FARGATE

ecs-cli compose --project-name fargate-example-apache --file docker-compose-apache.yml --ecs-params ecs-params.yml create --launch-type FARGATE


## Task単体 up
LBとかなく単体のTaskを上げてPublicIP直指定でアクセスできるようにする

ecs-cli compose --project-name fargate-example --file docker-compose-nginx.yml --ecs-params ecs-params.yml up --launch-type FARGATE

ecs-cli compose --project-name fargate-example-apache --file docker-compose-apache.yml --ecs-params ecs-params.yml up --launch-type FARGATE

## サービス up
ターゲットグループをTerraformで予め作っておく

--container-name　はdocker-composeでいうservice直下に規定したコンテナの名前

timeout 30m ecs-cli compose \
  --file docker-compose-nginx.yml \
  --ecs-params ecs-params.yml \
  --project-name fargate-example \
  --cluster default \
 service up --launch-type FARGATE \
 --container-name nginx \
 --container-port 80 \
 --target-group-arn arn:aws:elasticloadbalancing:ap-northeast-1:460256653427:targetgroup/rails-example-tg/7e3d376e4748a585 \
 --region ap-northeast-1 \
 --timeout 30