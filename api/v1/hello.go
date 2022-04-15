package v1

import (
	"github.com/gogf/gf/v2/frame/g"
)


type HelloReq struct {
	g.Meta `path:"/hello" method:"get"`
	Name   string `dc:"Your name"`
}

type HelloRes struct {
	Reply string `dc:"Reply content"`
}
