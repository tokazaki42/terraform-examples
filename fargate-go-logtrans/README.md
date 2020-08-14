# Goアプリケーション起動手順

## ECRにリポジトリを作成

ECRにて「fargate-go-example」リポジトリを作成してください。

## DockerfileをビルドしてECRにアップ

実際に動かすGoアプリケーションをDockerイメージ化します。
以下のコマンドでDockerイメージのビルドとECRリポジトリへのPushを行います。

```
cd fargate-go-example/docker/docker-image

aws ecr get-login-password --region ap-northeast-1 | docker login --username AWS --password-stdin <AWSアカウント番号>.dkr.ecr.ap-northeast-1.amazonaws.com

docker build -t go-example .

docker tag go-example:latest <AWSアカウント番号>.dkr.ecr.ap-northeast-1.amazonaws.com/go-example:latest

docker push <AWSアカウント番号>.dkr.ecr.ap-northeast-1.amazonaws.com/go-example:latest

```

## ECSの操作

### ECS CLIのインストール

ECSを操作するためのCLIをPCにインストールします。
インストール方法と初期設定の方法はAWSのドキュメントを参照ください。

https://docs.aws.amazon.com/ja_jp/AmazonECS/latest/developerguide/ECS_CLI_installation.html

https://docs.aws.amazon.com/ja_jp/AmazonECS/latest/developerguide/ECS_CLI_Configuration.html


### ECSタスク定義のベースとなるdocker-compose.ymlのイメージ名を更新

後ほど実行する ecs-cli composeコマンドのインプットとしてdocker-compose.ymlを利用します。
以下のimageの<AWSアカウントID>部分を書き換える

```
cd fargate-go-example/docker
vim docker-compose.yml

version: '3'

services:
  fargate-go-example:
    image: '<AWSアカウントID>.dkr.ecr.ap-northeast-1.amazonaws.com/go-example:latest'
    ports:
      - '8080:8080'
```


##  ECSタスク定義のベースとなるecs-params.ymlの変更

後ほど実行する ecs-cli composeコマンドのインプットとしてecs-params.ymllを利用します。


以下のsubnetsの値とsecurity_groupsの値をTerraformで作成したもののIDに書き換えてください。

```
version: 1
task_definition:
  task_execution_role: ecsTaskExecutionRole
  ecs_network_mode: awsvpc
  task_size:
    mem_limit: 0.5GB
    cpu_limit: 256
run_params:
  network_configuration:
    awsvpc_configuration:
      subnets:
        - "subnet-0d9ee166fc862a5df"
        - "subnet-02821c5131011d174"
      security_groups:
        - "sg-08c2299a6c28415f8"
      assign_public_ip: ENABLED
```


## タスク定義の作成
ecs-cli compose --project-name fargate-example --file docker-compose.yml --ecs-params ecs-params.yml create --launch-type FARGATE  --region ap-northeast-1 


## ECSサービスの起動
ECSサービスを起動します。
以下のコマンドを実行します。
 --target-group-arn の部分ではerraformで作成されたターゲットグループのARNを入力してください。

```
timeout 30m ecs-cli compose \
  --file docker-compose.yml \
  --ecs-params ecs-params.yml \
  --project-name fargate-go-example\
  --cluster fargate-go-example \
 service up --launch-type FARGATE \
 --container-name fargate-go-example \
 --container-port 8080 \
 --target-group-arn arn:aws:elasticloadbalancing:ap-northeast-1:xxxxxxxxxxxxx:targetgroup/fargate-go-example/xxxxxxxxxxxxxxx \
 --region ap-northeast-1 \
 --timeout 30

```
