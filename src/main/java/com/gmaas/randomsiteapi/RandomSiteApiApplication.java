package com.example.randomsiteapi;

import java.util.HashMap;
import java.util.Map;
import java.util.Random;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

@SpringBootApplication
@RestController
public class RandomSiteApiApplication {

    private final RestTemplate restTemplate = new RestTemplate();

    // List of sites
    private final String[] sites = {
            "https://www.example.com",
            "https://www.wikipedia.org",
            "https://www.github.com",
            "https://www.stackoverflow.com",
            "https://www.oracle.com"
    };

    public static void main(String[] args) {
        SpringApplication.run(RandomSiteApiApplication.class, args);
    }

    @GetMapping("/example")
    public Map<String, Object> getExampleContent() {
        long startTime = System.currentTimeMillis();
        String randomSite = sites[new Random().nextInt(sites.length)];
        
        // Faz a requisição
        ResponseEntity<String> response = restTemplate.getForEntity(randomSite, String.class);
        
        long responseTime = System.currentTimeMillis() - startTime;

        Map<String, Object> responseInfo = new HashMap<>();
        responseInfo.put("url", randomSite);
        responseInfo.put("statusCode", response.getStatusCodeValue());
        responseInfo.put("responseTime", responseTime + " ms");
        responseInfo.put("contentLength", response.getBody() != null ? response.getBody().length() : 0);

        return responseInfo;
    }
}