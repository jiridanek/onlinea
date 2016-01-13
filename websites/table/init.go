package table

import "net/http"

func init() {
	router := http.NewServeMux()
	router.HandleFunc("/", root)
	http.Handle("/", router)
}

func root(w http.ResponseWriter, r *http.Request) {
	DrawTable(w)
}
