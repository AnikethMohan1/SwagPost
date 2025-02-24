package serviceavailability

import (
	"encoding/json"
	"example/web-service-gin/configs"
	servicelocation "example/web-service-gin/models/service_availablity"
	"fmt"
	"io"
	"math"
	"net/http"

	"github.com/gin-gonic/gin"
)

func ServiceAvailableOnLocation(c *gin.Context) {

	var (
		err                 error
		available_locations []servicelocation.ServiceLocation
		service_location    servicelocation.ServiceLocation
	)

	body, _ := io.ReadAll(c.Request.Body)

	err = json.Unmarshal(body, &service_location)

	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"message": err.Error()})

		return

	}

	args := []interface{}{
		math.Round(service_location.Latitude*10000) / 10000,
		math.Round(service_location.Longitude*10000) / 10000,
	}

	SQL := fmt.Sprintf(`WITH DistanceCTE AS (
            SELECT
                location_name,
                location_id,
                latitude,
                longitude,
                COALESCE(service_radius_km, 10) AS service_radius_km,
                (6371 * acos(
                    cos(radians($1)) * cos(radians(latitude)) *
                    cos(radians(longitude) - radians($2)) +
                    sin(radians($1)) * sin(radians(latitude))
                )) AS distance
            FROM
                service_locations
        )
        SELECT
            location_name,
            location_id,
            latitude,
            longitude,
            service_radius_km,
            distance
        FROM
            DistanceCTE
        WHERE
            distance <= service_radius_km;`)

	er := configs.LocalPostgresDb.Raw(SQL, args...).Scan(&available_locations)

	if er != nil {
		c.JSON(http.StatusNotFound, er)
	}
	fmt.Print(available_locations)
	if len(available_locations) > 0 {
		var response configs.Response
		response.Status = http.StatusAccepted
		response.Result = available_locations
		c.JSON(http.StatusOK, response)
	} else {
		var response configs.Response
		response.Status = http.StatusNotFound
		response.Result = "Sorry our services are not available here"
		c.JSON(http.StatusNotFound, response)
	}

}
