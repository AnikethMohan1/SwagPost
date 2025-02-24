package dietassign

import (
	"encoding/json"
	"example/web-service-gin/configs"
	"example/web-service-gin/models/diets"
	"example/web-service-gin/models/dietsforuser"

	"io"
	"net/http"

	"github.com/gin-gonic/gin"
)

func AssignDiet(c *gin.Context) {

	var (
		userdiet dietsforuser.UserDiet
		err      error
	)

	body, _ := io.ReadAll(c.Request.Body)
	err = json.Unmarshal(body, &userdiet)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"message": err})
		return
	}
	addDietToUser(userdiet, c)

}

func CreateSampleDiet(c *gin.Context) {
	var (
		userdiet dietsforuser.UserDiet
		err      error
	)
	body, _ := io.ReadAll(c.Request.Body)
	err = json.Unmarshal(body, &userdiet)
	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"message": err})
		return
	}

	errors := configs.LocalPostgresDb.Debug().Table("samplediets").Create(userdiet)

	if errors != nil {
		c.JSON(http.StatusNotFound, gin.H{"message": "something went wrong"})
		return
	}

}

func addDietToUser(userdiet dietsforuser.UserDiet, c *gin.Context) {

	//configs.LocalPostgresDb.Debug().Table("users").Where("user_id = ?", user.User_Id).Updates(models.User{Diet: user.Diet})

	err := configs.LocalPostgresDb.Debug().Model(&dietsforuser.UserDiet{}).Create(userdiet)

	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"message": err})
		return
	}
	c.JSON(http.StatusOK, gin.H{"message": "Diet added sucessfully"})
}

func CreateDiet(c *gin.Context) {
	var (
		diet diets.Diet
		err  error
	)

	body, _ := io.ReadAll(c.Request.Body)

	err = json.Unmarshal(body, &diet)

	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"message": err})
		return
	}

}

// func createDietAndAssigntoUser(diet diets.Diet) {

// 	var (
// 		err error
// 	)

// 	err = configs.LocalPostgresDb.Create(&diet).Error

// }

func SendAllFoods(c *gin.Context) {
	var feedBackResponse []map[string]interface{}

	if err := configs.LocalPostgresDb.Debug().Raw(`SELECT * FROM food`).Scan(&feedBackResponse).Error; err != nil {
		// Handle error if query fails
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch user list"})

	}
	c.IndentedJSON(http.StatusOK, feedBackResponse)

}
