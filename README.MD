## URL SHORTENING SERVICE

### Description
This is a simple URL shortening service that takes a long URL and converts it into a short URL. The short URL can be used to redirect to the original long URL. Using Ruby on Rails, the service is built with a RESTful API that can be used to create, read short URLs.


## Features

- Shorten long URLs into compact, shareable links
- Custom short code support
- URL expiration 
- Data stored in a database.
- User authentication with Devise
- API endpoints for URL encoding/decoding
- URL history tracking
- Security protections against common attacks
- Rate limiting for API endpoints
- Continuous integration and deployment pipelines

### Prerequisites
- Ruby 3.2.2
- Rails 8.0.0
- SQLite3 (development)
- Postgres (optional, for production deployment)
- Docker (optional, for containerized deployment)

### Installation

1. **Clone the repository:**
    ```sh
    git clone https://github.com/your-username/url-shortening-service.git
    cd url-shortening-service
    ```

2. **Install dependencies:**
    ```sh
    bundle install
    ```

3. **Set up the database:**
    ```sh
    rails db:setup
    rails db:migrate
    ```

4. **Run the server:**
    ```sh
    rails s
    ```

5. **Access the web application:**
    Open your browser and navigate to `http://localhost:3000`.

### Usage


The application provides both a web interface and API endpoints:

# Web Interface Overview

- **Create Short URLs**:  
  Access the homepage at `/` to create a new short URL. Enter the original URL, custom short code (optional), and expiration date (optional) to generate a short URL.

- **View Shortened URL Results**:  
  Visit `/shortened-url-result?id={unique-id}` to view the details of a specific short URL. This page is automatically displayed after a new short URL is created.  

- **Redirect to Original URL**:  
  Visit the short URL path (e.g., `/abc123`) to be redirected to the original long URL.

- **User Authentication**:  
  - Login: `/users/sign_in`  
  - Register: `/users/sign_up`  

- **View URL History**:  
  Access `/users/history` to see a list of all shortened URLs created by the user.

---

### API Endpoints

#### Encode URL
Create a shortened version of a given URL.

`POST /api/v1/encode`

Pass all parameters in the url object.

| Parameter | Type | Description |
| --- | --- | --- |
| original_url | string | The original URL to shorten |
| short_code | string | The custom short code (optional) |
| expiration_days | integer | The number of days until the short URL expires (optional) |

```bash
curl -X POST http://localhost:3000/api/v1/encode \
  -H "Content-Type: application/json" \
  -d '"url": {
        "expiration_days": 10,
        "original_url": "https://oivan.com/",
        "short_code": ""
    }'
```

#### Response
```json
{
    "status": "ok",
    "data": {
        "original_url": "https://oivan.com/",
        "short_code": "5CmsQZbd",
        "time_expired": "2024-12-25T13:47:30.558+07:00",
        "result_page": "http://127.0.0.1:3000/shortened-url-result?id=f88102ae-20af-4d40-ad3a-6ba2304d2fee"
    },
    "message": "URL shortened successfully!"
}
```

#### Decode URL
`POST /api/v1/decode`

#### Parameters
Pass all parameters in the url object.

| Parameter | Type | Description |
| --- | --- | --- |
| short_code | string | The short code to decode|


```bash
curl -X POST http://localhost:3000/api/v1/decode \
  -H "Content-Type: application/json" \
  -d '{"url": {"short_code": "5CmsQZbd"}}'
```
#### Response
```json
{
    "status": "ok",
    "data": {
        "original_url": "https://oivan.com/",
        "short_url": "http://127.0.0.1:3000/5CmsQZbd",
        "short_code": "5CmsQZbd",
        "time_expired": "2024-12-25T13:47:30.558+07:00"
    },
    "message": "URL decoded successfully!"
}
```


### My Implementation

#### Architecture

1. **Controllers**:
   - **API Controllers**: Handle API requests and responses.
     - Located in `app/controllers/api/v1/`
     - Example: `EncodingController`, `DecodingController`
   - **Web Controllers**: Handle web requests for the user interface.
     - Located in `app/controllers/web/`
     - Example: `ShorteningController`

2. **Models**:
   - Represent the data and business logic of the application.
   - Located in `app/models/`
   - Example: `Url`, `User`

3. **Services**:
   - Encapsulate complex business logic and operations.
   - Located in `app/services/`
   - Example: `UrlEncodingService`, `UrlDecodingService`

4. **Forms**:
   - Handle form submissions and validations.
   - Located in `app/forms/`
   - Example: `UrlEncodeForm`

5. **Serializers**:
   - Format JSON responses for API endpoints.
   - Located in `app/serializers/`
   - Example: `UrlSerializer`, `ErrorSerializer`

6. **Views**:
   - Contain the HTML templates for rendering the user interface.
   - Located in `app/views/`
   - Example: `web/shortening/index.html.erb`


#### URL Shortening Algorithm

- **Short Code Generation:**
Short codes are generated using a combination of characters and numbers: `A-Z`, `a-z`, `0-9` = 26 + 26 + 10 = 62 characters with length random [5..8], which results in a total of 62^5 + 62^6 + 62^7 + 62^8 possible combinations. This total is nearly **221.9 Trillion** possible combinations.

- **Collision Handling:**
To handle collisions, the application checks if the generated short code already exists in the database. If a collision is detected, the application generates a new short code until a unique one is found.

- **Expiration:**
Short URLs can be set to expire after a certain number of days. The application checks the expiration date when redirecting to the original URL and returns an error if the short URL has expired.

#### User Authentication

- **Devise Gem:**
User authentication is implemented using the Devise gem. Users can register, log in, and log out of the application.


#### API Endpoints
Using the Rails API mode, the application provides RESTful API endpoints for encoding and decoding URLs.

#### Database Schema
The application uses a SQLite database in development and can be configured to use Postgres in production. The database schema includes tables for users, urls. 

#### CI/CD
The application can be set up with continuous integration and continuous deployment pipelines using GitHub Actions for automated testing. If the tests pass and the code is on the `main` branch, the workflow triggers a deployment.


#### Security 

**SQL Injection:**
Use parameterized queries to prevent SQL injection attacks.
Validate and sanitize all user inputs.

**Cross-Site Scripting (XSS):**
Use Rails' built-in helpers to escape HTML.
Validate and sanitize user inputs.

**Cross-Site Request Forgery (CSRF):**
Enable CSRF protection in Rails.
Use authenticity tokens in forms.
**Rate Limiting:**
Using the Rack::Attack gem to implement rate limiting for API endpoints.

**Data Validation:**
Validate URLs to ensure they are well-formed.

### Future Improvements

**Caching.**
Using a caching mechanism like Redis to store frequently accessed URLs and reduce database load.

**Load Balancing:**
Implement load balancing to distribute traffic across multiple servers.

**Database Sharding:**
Shard the database to distribute data across multiple servers and improve performance.

**Tracking and Analytics:**
Implement tracking and analytics to monitor user activity and improve the service.


**Monitoring:**
Set up monitoring tools to track application performance and detect issues.

**Logging:**
Implement logging to track user activity and debug issues.

**More Efficient Collision Handling:**
Develop a more efficient collision handling algorithm to reduce the risk of collisions when the number of short URLs increases.


### Deployment

1. **Using Docker:**
    - Build the Docker image:
        ```sh
        docker build -t url-shortening-service .
        ```
    - Run the Docker container:
        ```sh
        docker run -p 3000:3000 url-shortening-service
        ```

2. **Using a Cloud Service:**
    - Deploy the application to a cloud service like Heroku.
    - Set up environment variables and database configurations as needed.

### Testing

- **Run the test suite:**
    ```sh
    rails test
    ```

### Contributing

- Fork the repository.
- Create a new branch for your feature or bug fix.
- Write tests for your changes.
- Submit a pull request.

### License

This project is licensed under the MIT License. See the LICENSE file for details.

---

This README provides detailed instructions on how to set up, use, and deploy the URL shortening service. It includes information on features, prerequisites, installation, usage, API endpoints, architecture, security, future improvements, deployment, testing.