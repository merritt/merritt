package cmd

import (
	"github.com/merritt/merritt/api/server"

	"github.com/Sirupsen/logrus"
	"github.com/spf13/cobra"
)

var (
	dockerUrl string
)

// serverCmd represents the server command
var serverCmd = &cobra.Command{
	Use:   "server",
	Short: "A brief description of your command",
	Long: `A longer description that spans multiple lines and likely contains examples
and usage of using your command. For example:

Cobra is a CLI library for Go that empowers applications.
This application is a tool to generate the needed files
to quickly create a Cobra application.`,
	Run: func(cmd *cobra.Command, args []string) {
		cfg := &server.Config{
			DockerUrl: dockerUrl,
		}
		apiServer := server.New(cfg)
		err := apiServer.Run()
		if err != nil {
			logrus.Fatal(err)
		}
	},
}

func init() {
	serverCmd.Flags().StringVarP(&dockerUrl, "docker-url", "d", "", "Docker daemon url")
	RootCmd.AddCommand(serverCmd)

	// Here you will define your flags and configuration settings.

	// Cobra supports Persistent Flags which will work for this command
	// and all subcommands, e.g.:
	// serverCmd.PersistentFlags().String("foo", "", "A help for foo")

	// Cobra supports local flags which will only run when this command
	// is called directly, e.g.:
	// serverCmd.Flags().BoolP("toggle", "t", false, "Help message for toggle")

}
