// Copyright IBM Corp. 2024, 2026

package controller

import (
	"github.com/gin-gonic/gin"
	"github.com/benoitblais-hashicorp-demo/aws-eksvault/container/demo-go-web/internal/tools"
)

func GetStaticPage(c *gin.Context) {
	c.HTML(200, "static.html", gin.H{
		"Title":        tools.GetEnvVariable("TITLE", ""),
		"SubTitle":     tools.GetEnvVariable("SUB_TITLE", ""),
		"FirstMessage": tools.GetEnvVariable("FIRST_MESSAGE", ""),
		"CentralImage": tools.GetEnvVariable("IMAGE_URL", ""),
		"LearnMoreURL": tools.GetEnvVariable("LEARN_LINK", ""),
	})
}
