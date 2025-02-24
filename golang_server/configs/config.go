package configs

import "gorm.io/gorm"

var (
	LocalPostgresDb *gorm.DB
)

type Response struct {
	Status int         `json:"status"`
	Result interface{} `json:"result"`
}
