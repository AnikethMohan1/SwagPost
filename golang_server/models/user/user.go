package models

import "time"

type User struct {
	User_Name     string    `json:"user_name"`
	Profile_Link  string    `json:"profile_link"`
	User_Id       int64     `gorm:"primary_key;auto_increment" json:"user_id"`
	Upvotes       int64     `json:"upvotes"`
	CreateTime    time.Time `gorm:"autoCreateTime json:create_time"`
	User_Email    string    `json:"user_email"`
	User_Password string    `json:"user_password"`
	Diet          int64     `json:"diet"`
}

func (user *User) TableName() string {
	return "users"
}
