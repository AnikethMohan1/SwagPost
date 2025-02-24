package utlis

import (
	"bytes"
	"context"
	"encoding/json"
	"io"
	"net/http"

	"github.com/sirupsen/logrus"
)

func DoRestApiCall(ctx context.Context, apiKey, method, url, destination string, reqBody map[string]interface{}, reqHeader map[string]interface{}) (map[string]interface{}, error) {
	response := map[string]interface{}{}
	logger := ctx.Value("logger").(*logrus.Entry)
	HttpClient := &http.Client{}

	// if reqBody["trigger_properties"] != nil{
	//  reqBody["trigger_properties"].(map[string]interface{})["custom_id"] = ctx.Value("trace_id")

	// }
	body, _ := json.Marshal(reqBody)
	request, _ := http.NewRequest("POST", url, bytes.NewBuffer(body))
	// request.Header.Set("Content-Type", "application/json")
	// request.Header.Set("Authorization", apiKey)

	// fmt.Println(apiKey,"=========", url, reqBody, "==========================================")
	// client := &http.Client{}
	res, err := HttpClient.Do(request)
	if err != nil {
		return response, err
	}
	defer res.Body.Close()

	resBody, _ := io.ReadAll(res.Body)
	json.Unmarshal(resBody, &response)

	// fmt.Println(apiKey, url,reqBody, response, "============response=============")

	if logger != nil {
		logger.WithField("request - ", reqBody).Info(destination)
		logger.WithField("response - ", response).Info(destination)
	}
	// fmt.Println(string(resBody))
	return response, nil
}
