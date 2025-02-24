package servicelocation

type ServiceLocation struct {
	LocationId      int     `gorm:"primary_key;auto_increment" json:"location_id"`
	LocationName    string  `json:"location_name"`
	Latitude        float64 `json:"latitude"`
	Longitude       float64 `json:"longitude"`
	Distance        float64 `json:"distance"`
	ServiceRadiusKm float64 `json:"service_radius_km"`
}
