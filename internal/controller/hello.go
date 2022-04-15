package controller

import (
	"context"
	"fmt"
	"github.com/gogf/gf/v2/frame/g"

	"htp/api/v1"
)

var (
	Hello = cHello{}
)

type cHello struct{}

func (c *cHello) Hello(ctx context.Context, req *v1.HelloReq) (res *v1.HelloRes, err error) {
	g.Log().Debugf(ctx, `receive say: %+v`, req)
	res = &v1.HelloRes{
		Reply: fmt.Sprintf(`Hi %s`, req.Name),
	}
	return
}
