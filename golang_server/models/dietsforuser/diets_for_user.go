package dietsforuser

import (
	"encoding/json"
	"time"
)

type UserDiet struct {
	DietTime time.Time ` json:"diet_time"`

	UserDietId int64 `gorm:"primary_key;auto_increment" json:"user_diet_id"`

	MorningDiet    json.RawMessage `json:"morning_diet"`
	MidMorningDiet json.RawMessage `gorm:"column:midmorning_diet" json:"midmorning_diet"`
	AfterNoonDiet  json.RawMessage `gorm:"column:afternoon_diet" json:"afternoon_diet"`
	TeaTime        json.RawMessage `gorm:"column:tea_time_diet" json:"tea_time_diet"`
	EveningTime    json.RawMessage `gorm:"column:evening_diet" json:"evening_diet"`
	FoodPreference json.RawMessage `json:"food_preference"`
	FitnessGoal    json.RawMessage `json:"fitness_goal"`
	FoodRegion     json.RawMessage `json:"food_region"`
}
