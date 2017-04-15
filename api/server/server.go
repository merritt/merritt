package server

import (
	"net/http"
	"net/url"

	"github.com/Sirupsen/logrus"
	"github.com/mailgun/oxy/forward"
)

type Config struct {
	DockerUrl string
}

type Server struct {
	dUrl string
	fwd  *forward.Forwarder
}

// New returns a new instance of the server based on the specified configuration.
func New(cfg *Config) *Server {
	return &Server{
		dUrl: cfg.DockerUrl,
	}
}

func (s *Server) Run() error {
	logrus.Info("Merritt API Starting")

	// forwarder for swarm
	var err error
	s.fwd, err = forward.New()
	if err != nil {
		return err
	}

	http.HandleFunc("/info", s.swarmRedirect)

	// http.Handle("/", http.FileServer(http.Dir("static")))
	return http.ListenAndServe(":8080", nil)
}

func (s *Server) swarmRedirect(w http.ResponseWriter, req *http.Request) {
	var err error
	req.URL, err = url.ParseRequestURI(s.dUrl)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	s.fwd.ServeHTTP(w, req)
}
