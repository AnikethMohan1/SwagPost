package swagpost

import (
	"bytes"
	"encoding/json"
	routerequest "example/web-service-gin/models/routeRequest"
	"fmt"
	"io"
	"net/http"
	"strconv"
	"strings"
	"time"

	"github.com/gin-gonic/gin"
)

func RouteRequest(c *gin.Context) {
	var (
		err     error
		Request routerequest.Request
	)

	body, _ := io.ReadAll(c.Request.Body)

	err = json.Unmarshal(body, &Request)

	if err != nil {
		c.JSON(http.StatusNotFound, gin.H{"message": err.Error()})

		return

	}
}

type ProxyRequest struct {
	URL     string            `json:"url"`
	Method  string            `json:"method"`
	Headers map[string]string `json:"headers"`
	Body    interface{}       `json:"body"`
}

func CORSMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		origin := c.Request.Header.Get("Origin")
		if origin == "" {
			origin = "*"
		}

		c.Writer.Header().Set("Access-Control-Allow-Origin", origin)
		c.Writer.Header().Set("Access-Control-Allow-Credentials", "true")
		c.Writer.Header().Set("Access-Control-Allow-Methods", "POST, GET, PUT, DELETE, PATCH")
		c.Writer.Header().Set("Access-Control-Allow-Headers", "*")
		c.Writer.Header().Set("Access-Control-Max-Age", "86400")
		c.Writer.Header().Set("Access-Control-Expose-Headers", "Content-Length")

		// Security headers
		c.Writer.Header().Set("Strict-Transport-Security", "max-age=31536000; includeSubDomains")
		c.Writer.Header().Set("X-Content-Type-Options", "nosniff")
		c.Writer.Header().Set("X-Frame-Options", "DENY")
		c.Writer.Header().Set("X-XSS-Protection", "1; mode=block")
		c.Writer.Header().Set("Referrer-Policy", "strict-origin-when-cross-origin")
		c.Writer.Header().Set("Host", c.Request.Host)

		// Additional security headers

		if c.Request.Method == "OPTIONS" {
			c.AbortWithStatus(204)
			return
		}

		c.Next()
	}
}

func ProxyHandler(c *gin.Context) {
	var reqBody struct {
		URL     string            `json:"url"`
		Method  string            `json:"method"`
		Headers map[string]string `json:"headers"`
		Body    interface{}       `json:"body"`
	}

	if err := c.ShouldBindJSON(&reqBody); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request format"})
		return
	}

	// Create proxy request
	var bodyReader io.Reader
	var contentLength int
	if reqBody.Body != nil {
		bodyBytes, err := json.Marshal(reqBody.Body)
		if err != nil {
			c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request body"})
			return
		}
		bodyReader = bytes.NewReader(bodyBytes)

		contentLength = len(bodyBytes)
	}

	proxyReq, err := http.NewRequest(reqBody.Method, reqBody.URL, bodyReader)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create request"})
		return
	}

	// Copy headers from request
	for key, value := range reqBody.Headers {
		proxyReq.Header.Set(key, value)
	}

	client := &http.Client{
		Timeout: 30 * time.Second,
	}

	if contentLength > 0 {
		proxyReq.Header.Set("Content-Length", strconv.Itoa(contentLength))
	}

	resp, err := client.Do(proxyReq)
	if err != nil {
		c.JSON(http.StatusBadGateway, gin.H{"error": "Request failed"})
		return
	}
	defer resp.Body.Close()

	// Read the response body
	bodyBytes, err := io.ReadAll(resp.Body)
	bodyString := string(bodyBytes)
	fmt.Print(bodyString)

	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to read response"})
		return
	}

	// Copy all headers from the original response
	for key, values := range resp.Header {
		for _, value := range values {
			c.Header(key, value)
		}
	}

	// Set the same status code as the original response
	c.Status(resp.StatusCode)

	// Write the body exactly as received

	c.Writer.Write(bodyBytes)
}

func isJSON(contentType string) bool {
	return strings.Contains(strings.ToLower(contentType), "application/json")
}
