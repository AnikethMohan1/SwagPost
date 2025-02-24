package routerequest

type Request struct {
	Header     map[string]interface{} `json:"header"`
	Body       map[string]interface{} `json:"body"`
	RequestUrl string                 `json:"request_url"`
}
