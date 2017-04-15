package version

var (
	name        = "merritt"
	version     = "0.0.1"
	description = "Open source container management"
	// GitCommit is used in the build version
	GitCommit = "HEAD"
)

// Name is the name of the application
func Name() string {
	return name
}

// Version is the version of the application
func Version() string {
	return version + " (" + GitCommit + ")"
}

// Description is the description of the application
func Description() string {
	return description
}

// FullVersion is the application name and version info
func FullVersion() string {
	return Name() + " " + Version()
}
