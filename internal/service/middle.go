package service

import "github.com/gogf/gf/v2/net/ghttp"

func MiddlewareHandlerResponse(r *ghttp.Request) {
	r.Middleware.Next()
}