package main

import (
	"fmt"

	_ "github.com/lib/pq"

	dietassign "example/web-service-gin/diet_assign"
	serviceavailability "example/web-service-gin/service_availability"
	swagpost "example/web-service-gin/swagPost"

	"example/web-service-gin/cruds"

	"github.com/gin-gonic/gin"
)

// type album struct {
// 	ID     string  `json:"id"`
// 	Title  string  `json:"title"`
// 	Artist string  `json:"artist"`
// 	Price  float64 `json:"price"`
// }

// const (
// 	host     = "localhost"
// 	port     = 5432
// 	user     = "postgres"
// 	password = "changepassword"
// 	dbname   = "anikethmohan"
// )

func main() {
	//var err error
	// psqlInfo := fmt.Sprintf("host=%s port=%d user=%s password=%s dbname =%s sslmode=disable", host, port, user, password, dbname)
	// configs.LocalPostgresDb, err = gorm.Open(postgres.Open(psqlInfo))
	// if err != nil {
	// 	panic(err)
	// }

	fmt.Println("Sucessfully connected")

	router := gin.Default()

	// config := cors.DefaultConfig()
	// config.AllowOrigins = []string{"http://localhost:54946"} // Replace with your Flutter app's URL
	// config.AllowMethods = []string{"GET", "POST", "PUT", "PATCH", "DELETE", "HEAD", "OPTIONS"}
	// config.AllowHeaders = []string{"Origin", "Content-Length", "Content-Type", "Authorization", "Host"}

	//router.Use(cors.New(config))
	router.Use(swagpost.CORSMiddleware())
	router.GET("/getallusers", cruds.GetUserList)
	router.POST("/updateuser", cruds.Updateuser)
	router.POST("/assigndiets", dietassign.AssignDiet)
	router.POST("/create-sample-diet", dietassign.CreateSampleDiet)
	router.POST("/getfoods", dietassign.SendAllFoods)
	router.POST("/search-user", cruds.UserSearch)
	router.POST("/service-availablity", serviceavailability.ServiceAvailableOnLocation)
	router.POST("/proxy", swagpost.ProxyHandler)

	router.Run("localhost:8080")
}
