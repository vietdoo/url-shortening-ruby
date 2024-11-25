## URL SHORTENING SERVICE

### Description
This is a simple URL shortening service that takes a long URL and converts it into a short URL. The short URL can be used to redirect to the original long URL. Using Ruby on Rails, the service is built with a RESTful API that can be used to create, read short URLs.


## Features

- Shorten long URLs into compact, shareable links
- Custom short code support
- URL expiration 
- User authentication with Devise
- API endpoints for URL encoding/decoding
- URL history tracking
- Security protections against common attacks

### Prerequisites
- Ruby 3.2.2
- Rails 8.0.0
- SQLite3 (or another database of your choice)
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
    ```

4. **Run the server:**
    ```sh
    rails server
    ```

5. **Access the application:**
    Open your browser and navigate to `http://localhost:3000`.

### Usage


The application provides both a web interface and API endpoints:

# Web Interface Overview

- **Create Short URLs**:  
  Access the homepage at `/` to generate new short URLs.  

- **View Shortened URL Results**:  
  Visit `/shortened-url-result?id={unique-id}` to view the details of a specific short URL. This page is automatically displayed after a new short URL is created.  

- **Redirect to Original URL**:  
  Visit the short URL path (e.g., `/abc123`) to be redirected to the original long URL.

- **User Authentication**:  
  - Login: `/users/sign_in`  
  - Register: `/users/sign_up`  

- **View URL History**:  
  Access `/history` to see a list of all shortened URLs created by the user.

---

### API Endpoints

#### Encode URL
```bash
curl -X POST http://localhost:3000/encode \
  -H "Content-Type: application/json" \
  -d '{"url": {"original_url": "https://example.com", "short_code": "custom123"}}'
```

#### Decode URL
```bash
curl -X POST http://localhost:3000/decode \
  -H "Content-Type: application/json" \
  -d '{"url": {"short_code": "abc123"}}'
```


### Security Considerations

#### Potential Attack Vectors

1. **SQL Injection:**
    - Use parameterized queries to prevent SQL injection attacks.
    - Validate and sanitize all user inputs.

2. **Cross-Site Scripting (XSS):**
    - Use Rails' built-in helpers to escape HTML.
    - Validate and sanitize user inputs.

3. **Cross-Site Request Forgery (CSRF):**
    - Enable CSRF protection in Rails.
    - Use authenticity tokens in forms.

4. **Rate Limiting:**
    - Implement rate limiting to prevent abuse of the service.
    - Use gems like `rack-attack` to throttle requests.

5. **Data Validation:**
    - Validate URLs to ensure they are well-formed.
    - Check for malicious URLs that could be used for phishing or malware distribution.

### Scalability and Collision Handling

1. **Scalability:**
    - Use a distributed database or a cloud-based database service to handle increased load.
    - Implement caching mechanisms to reduce database load.
    - Use background jobs for tasks that can be processed asynchronously.

2. **Collision Handling:**
    - Use a sufficiently large character set and length for short codes to minimize the risk of collisions.
    - Implement a retry mechanism to generate a new short code if a collision is detected.
    - Use a hash function to generate unique short codes based on the original URL.

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
    - Deploy the application to a cloud service like Heroku, AWS, or DigitalOcean.
    - Set up environment variables and database configurations as needed.

### Testing

- **Run the test suite:**
    ```sh
    bin/rails test
    ```

### Contributing

- Fork the repository.
- Create a new branch for your feature or bug fix.
- Write tests for your changes.
- Submit a pull request.

### License

This project is licensed under the MIT License. See the LICENSE file for details.

---

This README provides detailed instructions on how to set up, use, and deploy the URL shortening service, along with considerations for security, scalability, and collision handling.