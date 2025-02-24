package diets

import (
	"time"
)

type Diet struct {
	UserId        int       `json:"user_id"`
	Id            int       `gorm:"primary_key;auto_increment" json:"diet_id"`
	FoodName      string    `json:"food_name"`
	Category      string    `json:"category"`
	Description   string    `json:"description"`
	Calories      string    `json:"calories"`
	ServingSize   string    `json:"serving_size"`
	ImageUrl      string    `json:"image_url"`
	Protien       string    `json:"protein"`
	CarbohyDrates string    `json:"carbohydrates"`
	Fats          string    `json:"fats"`
	CreateTime    time.Time `gorm:"autoCreateTime;column:create_time"`
}

func (diet *Diet) TableName() string {
	return "diets"
}
