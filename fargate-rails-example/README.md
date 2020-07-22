
## 事前準備
ALBに設定する証明書はあらかじめ手動でACMに登録しておく。


## 手順
以下をためしてみる。
https://qiita.com/tarumzu/items/2d7ed918f230fea957e8


docker-compose.production.yml
ecs-param.production.yml
Fargate ecs-cliのインストール
Fargate構築、Dockerのビルド＆デプロイ
Fargateスケールアウト/インの設定


ecs-cliコマンドでFargateの構築及びデプロイを行います。
※ FargateはTerraformでも構築できますが、なぜecs-cliコマンドで構築したかというとデプロイ時にFargateをスケールアップ/ダウンできるようにして弾力性3を高めたかったためです。
らしい。

