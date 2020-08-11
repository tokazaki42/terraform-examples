package main

import (
    "github.com/gin-gonic/gin"
)

func main() {
    r := gin.Default()
    r.GET("/", hoge)
    r.Run() 
}

func hoge(c *gin.Context) {
    c.JSON(200, "200 OK")
}

