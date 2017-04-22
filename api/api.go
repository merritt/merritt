package api

import (
	"net/http"

	"github.com/Sirupsen/logrus"
	"github.com/gorilla/context"
	"github.com/mailgun/oxy/forward"
)

type (
	// API services a set of HTTP routes
	API struct {
		listenAddr string
		uiDir      string
		dockerURL  string
		fwd        *forward.Forwarder
	}

	// Config for constructing an API
	Config struct {
		ListenAddr string
		UIDir      string
		DockerURL  string
	}
)

// NewAPI configures and creates an API instance
func NewAPI(config Config) (*API, error) {
	return &API{
		listenAddr: config.ListenAddr,
		uiDir:      config.UIDir,
		dockerURL:  config.DockerURL,
	}, nil
}

// Run starts the API instance
func (a *API) Run() error {
	var err error

	globalMux := http.NewServeMux()

	a.fwd, err = forward.New()
	if err != nil {
		return err
	}

	globalMux.HandleFunc("/info", a.swarmRedirect)

	// static handler
	globalMux.Handle("/", http.FileServer(http.Dir(a.uiDir)))

	s := &http.Server{
		Addr:    a.listenAddr,
		Handler: context.ClearHandler(globalMux),
	}

	logrus.Infof("api started: addr=%s", a.listenAddr)
	if err = s.ListenAndServe(); err != nil {
		return err
	}

	return nil
}
