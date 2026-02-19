package controller

import (
	"context"
	"errors"
	"fmt"

	"4redteam/pkg/database"
	"4redteam/pkg/graph/subscriptions"
	"4redteam/pkg/observability/langfuse"
	"4redteam/pkg/providers"
	"4redteam/pkg/tools"

	"github.com/sirupsen/logrus"
)

var ErrNothingToLoad = errors.New("nothing to load")

type FlowContext struct {
	DB database.Querier

	UserID    int64
	FlowID    int64
	FlowTitle string

	Executor  tools.FlowToolsExecutor
	Provider  providers.FlowProvider
	Publisher subscriptions.FlowPublisher

	TermLog    FlowTermLogWorker
	MsgLog     FlowMsgLogWorker
	Screenshot FlowScreenshotWorker
}

type TaskContext struct {
	TaskID    int64
	TaskTitle string
	TaskInput string

	FlowContext
}

type SubtaskContext struct {
	MsgChainID         int64
	SubtaskID          int64
	SubtaskTitle       string
	SubtaskDescription string

	TaskContext
}

func wrapErrorEndSpan(ctx context.Context, span langfuse.Span, msg string, err error) error {
	logrus.WithContext(ctx).WithError(err).Error(msg)
	err = fmt.Errorf("%s: %w", msg, err)
	span.End(
		langfuse.WithSpanStatus(err.Error()),
		langfuse.WithSpanLevel(langfuse.ObservationLevelError),
	)
	return err
}
