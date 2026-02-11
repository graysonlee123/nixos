package main

import (
	"context"
	"database/sql"
	"log"
	"strings"

	_ "github.com/mattn/go-sqlite3"
)

var (
	ctx context.Context
	db  *sql.DB
)

func main() {
	db, err := sql.Open("sqlite3", "/home/gray/.local/share/vicinae/vicinae.db")
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	rows, err := db.Query("SELECT * FROM shortcut")
	if err != nil {
		log.Fatal(err)
	}
	defer rows.Close()

	urls := make([]string, 0)
	for rows.Next() {
		var id string
		var name string
		var icon string
		var url string
		var app string
		var open_count int
		var created_at string
		var updated_at string
		var last_used_at string
		if err := rows.Scan(&id, &name, &icon, &url, &app, &open_count, &created_at, &updated_at, &last_used_at); err != nil {
			log.Fatal(err)
		}
		urls = append(urls, url)
	}

	// Check for errors from iterating over rows.
	if err := rows.Err(); err != nil {
		log.Fatal(err)
	}

	log.Printf(strings.Join(urls, ", "))
}
