package httputils // import "github.com/docker/docker/api/server/httputils"

import (
	"io"

	"github.com/docker/docker/api/types/container"
	"github.com/docker/docker/api/types/network"
    "github.com/docker/go-connections/nat"
)


// ContainerDecoder specifies how
// to translate an io.Reader into
// container configuration.
type ContainerDecoder interface {
	DecodeConfig(src io.Reader) (*container.Config, *container.HostConfig, *network.NetworkingConfig, error)
    DecodePortConfig(src io.Reader) (map[nat.Port]struct{}, map[nat.Port][]nat.PortBinding, error) //exposedPorts, portBindings, error
	DecodeHostConfig(src io.Reader) (*container.HostConfig, error)
}
