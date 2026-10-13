package provider

import (
	"context"

	"github.com/hashicorp/terraform-plugin-framework/datasource"
	"github.com/hashicorp/terraform-plugin-framework/provider"
	"github.com/hashicorp/terraform-plugin-framework/provider/schema"
	"github.com/hashicorp/terraform-plugin-framework/resource"
)

func New(version string) func() provider.Provider {
	return func() provider.Provider {
		return &registryTestProvider{version: version}
	}
}

type registryTestProvider struct {
	version string
}

func (p *registryTestProvider) Metadata(_ context.Context, _ provider.MetadataRequest, resp *provider.MetadataResponse) {
	resp.TypeName = "registrytest"
	resp.Version = p.version
}

func (p *registryTestProvider) Schema(_ context.Context, _ provider.SchemaRequest, resp *provider.SchemaResponse) {
	resp.Schema = schema.Schema{}
}

func (p *registryTestProvider) Configure(context.Context, provider.ConfigureRequest, *provider.ConfigureResponse) {
}

func (p *registryTestProvider) DataSources(context.Context) []func() datasource.DataSource {
	return nil
}

func (p *registryTestProvider) Resources(context.Context) []func() resource.Resource {
	return nil
}
