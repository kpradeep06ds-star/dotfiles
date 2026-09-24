export PATH="$PATH:$(go env GOPATH)/bin"
export DRIFT_TIMEOUT=120
eval "$(drift shell-init bash)"
