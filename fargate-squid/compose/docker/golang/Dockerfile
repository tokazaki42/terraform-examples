# 使用するGolangのイメージを指定する
FROM golang:1.14

# ワーキングディレクトリを指定する
WORKDIR /go/src/sample_docker_compose

# sample_docker_compose直下のディレクトリをコンテナ上に載せる
ADD . .

# プロジェクトをビルド
RUN go build

