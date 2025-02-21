package main

import (
	"log"

	"gorm.io/driver/postgres"
	"gorm.io/gorm"
)

type User struct {
	ID       uint   `gorm:"primaryKey"`
	Username string `gorm:"unique;not null"`
	Email    string `gorm:"unique;not null"`
	Password string `gorm:"not null"`
}

var DB *gorm.DB // ✅ Use uppercase `DB` globally

func InitDB() {
	dsn := "host=localhost user=youruser password=@john2024 dbname=yourdb port=5432 sslmode=disable"
	var err error
	DB, err = gorm.Open(postgres.Open(dsn), &gorm.Config{}) // ✅ Assign to `DB`, not a new local variable
	if err != nil {
		log.Fatal("Failed to connect to the database:", err)
	}
	DB.AutoMigrate(&User{}) // ✅ Auto-create table
}
