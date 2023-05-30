package main

import (
	"errors"
	"go.elastic.co/ecszap"
	"go.uber.org/zap"
	"go.uber.org/zap/zapcore"
	"os"
	"time"
)

func main() {
	// Buat encoder untuk ECS logging
	encoderConfig := ecszap.NewDefaultEncoderConfig()

	// Buat core yang menggunakan encoder
	core := ecszap.NewCore(encoderConfig, zapcore.AddSync(os.Stdout), zap.InfoLevel)

	// Buat logger yang menggunakan core tersebut
	logger := zap.New(core, zap.AddCaller())

	for range time.Tick(time.Second * 5) {
		// Gunakan logger untuk mencetak log
		logger.Info("some logging info",
			zap.String("custom", "foo"),
			zap.Int("count", 17),
			zap.String("ecs.version", "1.6.0"),
			zap.String("log.logger", "mylogger"),
			zap.Time("@timestamp", time.Now()),
			zap.Error(errors.New("boom")),
		)
	}
}
