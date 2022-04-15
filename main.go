package main

import (
	_ "htp/internal/packed"

	"github.com/gogf/gf/v2/os/gctx"

	"htp/internal/cmd"
)

func main() {
	cmd.Main.Run(gctx.New())
}
