package graph

import (
	"4redteam/pkg/config"
	"4redteam/pkg/controller"
	"4redteam/pkg/database"
	"4redteam/pkg/graph/subscriptions"
	"4redteam/pkg/providers"
	"4redteam/pkg/templates"

	"github.com/sirupsen/logrus"
)

// This file will not be regenerated automatically.
//
// It serves as dependency injection for your app, add any dependencies you require here.

type Resolver struct {
	DB              database.Querier
	Config          *config.Config
	Logger          *logrus.Entry
	DefaultPrompter templates.Prompter
	ProvidersCtrl   providers.ProviderController
	Controller      controller.FlowController
	Subscriptions   subscriptions.SubscriptionsController
}
