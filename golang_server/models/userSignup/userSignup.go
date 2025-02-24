package usersignup

import "time"

type UserPrivate struct {
	User_Name  string    `json:"user_name"`
	User_Email string    `json:"user_email"`
	User_Id    int64     `gorm:"primary_key;auto_increment" json:"user_id"`
	Upvotes    int64     `json:"upvotes"`
	CreateTime time.Time `gorm:"autoCreateTime json:cre"`
}
