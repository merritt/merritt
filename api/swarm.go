package api

import (
	"net/http"
	"net/url"
)

func (a *API) swarmProxy(w http.ResponseWriter, req *http.Request) {
	var err error
	req.URL, err = url.ParseRequestURI(a.config.DockerURL)
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
		return
	}
	a.fwd.ServeHTTP(w, req)
}
