package main

import (
	"github.com/Sirupsen/logrus"
	"github.com/codegangsta/cli"
	"github.com/merritt/merritt/api"
	"github.com/merritt/merritt/version"
)

var runCommand = cli.Command{
	Name:   "run",
	Usage:  "start server",
	Action: runAction,
	Flags: []cli.Flag{
		cli.StringFlag{
			Name:  "listen, l",
			Usage: "listen address",
			Value: ":8080",
		},
		cli.StringFlag{
			Name:  "ui-dir, s",
			Usage: "path to ui media directory",
			Value: "ui",
		},
		cli.StringFlag{
			Name:  "docker-url, d",
			Usage: "docker swarm URL",
			Value: "http://127.0.0.1:2375",
		},
	},
}

func runAction(c *cli.Context) {
	logrus.Info(version.FullVersion())

	listenAddr := c.String("listen")
	uiDir := c.String("ui-dir")
	dockerURL := c.String("docker-url")

	api, err := api.NewAPI(api.Config{ListenAddr: listenAddr, UIDir: uiDir, DockerURL: dockerURL})
	if err != nil {
		logrus.Fatal(err)
	}

	err = api.Run()
	if err != nil {
		logrus.Fatal(err)
	}
}
