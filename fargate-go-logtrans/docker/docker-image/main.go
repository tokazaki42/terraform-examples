package main

import (
    "github.com/gin-gonic/gin"
    "log"
    "os"
    "io"
)



func main() {
    r := gin.Default()
    r.GET("/", hoge)
    r.Run() 
}

func hoge(c *gin.Context) {

    logfile, err := os.OpenFile("/var/log/access.log", os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0666)
    if err != nil {
        panic("cannnot open /var/log/access.log:" + err.Error())
    }
    defer logfile.Close()

    log.SetOutput(io.MultiWriter(logfile, os.Stdout))

    log.Println("Hello, World")

    c.JSON(200, "Hello, 200 OK")
    
}

