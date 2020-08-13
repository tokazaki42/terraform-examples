
参考サイト
https://geekdudes.wordpress.com/2018/01/08/deploying-windows-ec2-instance-using-terraform/


# windows server へのログイン方法
- 以下のコマンドでSSMセッションを開始する
```
aws ssm start-session --target <instance-id> --document-name AWS-StartPortForwardingSession --parameters "localPortNumber=55678,portNumber=3389"
```

- リモートデスクトップクライアントで接続を行う
- デフォルトのID/PWはEC2コンソールより確認できる
