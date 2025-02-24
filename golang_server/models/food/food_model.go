package food

type Food struct {
	FoodId        int    `gorm:"primary_key;auto_increment" json:"food_id"`
	FoodName      string `json:"food_name"`
	Category      string `json:"category"`
	Description   string `json:"description"`
	Calories      int64  `json:"calories"`
	ServingSize   string `json:"serving_size"`
	ImageUrl      string `json:"image_url"`
	Protien       int64  `json:"protein"`
	CarbohyDrates int64  `json:"carbohydrates"`
	Fats          int64  `json:"fats"`
}
