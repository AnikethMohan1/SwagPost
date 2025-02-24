package signin

import (
	"encoding/json"
	"example/web-service-gin/configs"
	"example/web-service-gin/cruds"

	models "example/web-service-gin/models/user"

	"io"
	"net/http"

	"github.com/gin-gonic/gin"
)

func UserCreate(c *gin.Context) {
	var (
		user models.User
		err  error
	)

	body, _ := io.ReadAll(c.Request.Body)

	err = json.Unmarshal(body, &user)

	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"message": "Something wrong the request body"})
		return
	}
	if user.User_Email == "" || user.User_Password == "" || user.User_Name == "" {
		c.JSON(http.StatusNotFound, gin.H{"message": "Please Provide all the data data"})
		return
	}
	check := CheckUserExistes(user.User_Email)

	if !check {

		cruds.CreateUser(user.User_Name, user.User_Email, user.User_Password, `link`)
		c.IndentedJSON(http.StatusOK, gin.H{"message": "user created sucessfully"})

	} else {
		c.IndentedJSON(http.StatusOK, gin.H{"message": "user already exists"})
	}

}

func UserLogin(c *gin.Context) {
	var (
		user models.User
		err  error
	)
	body, _ := io.ReadAll(c.Request.Body)

	err = json.Unmarshal(body, &user)

	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"message": "Something wrong the request body"})
		return
	}
	check := CheckUserExistes(user.User_Email)

	if !check {
		c.IndentedJSON(http.StatusOK, gin.H{"message": "User not found please sign up "})
	}

}

func CheckUserExistes(user_email string) bool {
	result := map[string]interface{}{}
	configs.LocalPostgresDb.Debug().Model(&models.User{}).Select("user_id").Where("user_email = ?", user_email).Limit(1).Scan(result)
	return len(result) != 0

}
