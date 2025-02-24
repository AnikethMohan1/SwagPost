package cruds

import (
	"encoding/json"
	models "example/web-service-gin/models/user"
	"fmt"
	"reflect"

	"io"

	"net/http"
	"time"

	_ "reflect"

	"example/web-service-gin/configs"

	"github.com/gin-gonic/gin"
)

func GetUserList(c *gin.Context) {

	var feedBackResponse []map[string]interface{}

	if err := configs.LocalPostgresDb.Debug().Raw(`SELECT * FROM users`).Scan(&feedBackResponse).Error; err != nil {
		// Handle error if query fails
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to fetch user list"})

	}

	c.IndentedJSON(http.StatusOK, feedBackResponse)

}

func CreateUser(user_name string, user_email string, user_password string, profile_link string) {

	// var (
	// 	user models.User
	// 	err  error
	// )

	// body, _ := io.ReadAll(c.Request.Body)

	// err = json.Unmarshal(body, &user)

	// if err != nil {

	// 	c.JSON(http.StatusNotFound, gin.H{"message": "something went wrong"})

	// 	return
	// }

	configs.LocalPostgresDb.Debug().Table("users").Model(&models.User{}).Create(map[string]interface{}{
		"user_name":     user_name,
		"profile_link":  profile_link,
		"user_email":    user_email,
		"user_password": user_password,
		"upvotes":       0,
		"create_time":   time.Now(),
	})

}

func Updateuser(c *gin.Context) {
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
	if user.User_Id == 0 {
		c.JSON(http.StatusNotFound, gin.H{"message": "User id is required to update"})

		return
	}
	configs.LocalPostgresDb.Debug().Model(&models.User{}).Where("user_id=?", user.User_Id).Updates(models.User{
		User_Name:    user.User_Name,
		Profile_Link: user.Profile_Link,
		Upvotes:      user.Upvotes,
	})

	c.IndentedJSON(http.StatusOK, gin.H{"message": "user updated"})

	//LocalPostgresDb.Debug().Table("users").Model((&models.User)).Update()

}

func UserSearch(c *gin.Context) {
	var (
		user models.User
		err  error
	)
	body, _ := io.ReadAll(c.Request.Body)

	err = json.Unmarshal(body, &user)
	fmt.Print(user.User_Id)

	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"message": "Something wrong the request body"})

		return

	}

	searchUserById(c, user.User_Id)

}

func searchUserById(c *gin.Context, userId int64) {

	var (
		user     models.User
		response configs.Response
	)

	configs.LocalPostgresDb.Debug().Model(&models.User{}).Select("*").Where("user_id = ?", userId).Scan(&user)

	if reflect.DeepEqual(user, models.User{}) {
		c.IndentedJSON(http.StatusNotFound, gin.H{"message": "User not found"})
	} else {
		response.Result = user
		response.Status = http.StatusOK
	}

	c.IndentedJSON(http.StatusOK, gin.H{"data": response})
}
