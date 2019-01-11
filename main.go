package main

import (
	"fmt"
	"net/http"
	"time"
)

func checkWebsite(website string) error {

	tz, _ := time.LoadLocation("Europe/Paris")
	now := time.Now()
	parisTime := now.In(tz)

	resp, err := http.Get(website)
	if err != nil {
		return err
	}

	if resp.StatusCode >= 200 && resp.StatusCode <= 299 {
		fmt.Println("Website :", website, "is Up", "HTTP Response Status:", resp.StatusCode, http.StatusText(resp.StatusCode))
	} else {
		fmt.Println("Website :", website, " Broken", "HTTP Response Status:", resp.StatusCode, http.StatusText(resp.StatusCode))
	}
	fmt.Println("Paris is magic : what time is it in Paris ?", parisTime)

	return err
}

func main() {
	checkWebsite("https://chemidy.cloud")
}
