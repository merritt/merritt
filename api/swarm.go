package api

import (
	"net/http"
	"net/url"

	"github.com/Sirupsen/logrus"
)

func (a *API) swarmProxy(w http.ResponseWriter, req *http.Request) {
	var err error
	req.URL, err = url.ParseRequestURI(a.config.DockerURL)
	if err != nil {
		logrus.WithFields(logrus.Fields{
			"error": err.Error(),
		}).Error("Error while proxying request to swarm")
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	a.fwd.ServeHTTP(w, req)
}
