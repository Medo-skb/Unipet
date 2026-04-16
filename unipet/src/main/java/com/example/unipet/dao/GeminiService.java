package com.example.unipet.dao;

import java.io.IOException;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.example.unipet.config.GeminiConfig;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;

@Service
public class GeminiService {

    @Autowired
    private GeminiConfig geminiConfig;

    public String getApiKeyTest() {
        return geminiConfig.getApiKey();
    }

    public String callGeminiTest(String prompt) throws IOException, InterruptedException {
        String apiKey = geminiConfig.getApiKey();

        String url = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent";

        String escapedPrompt = prompt
                .replace("\\", "\\\\")
                .replace("\"", "\\\"")
                .replace("\n", "\\n");

        String requestBody = """
            {
              "contents": [
                {
                  "parts": [
                    {
                      "text": "%s"
                    }
                  ]
                }
              ]
            }
            """.formatted(escapedPrompt);

        HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create(url))
                .header("Content-Type", "application/json")
                .header("x-goog-api-key", apiKey)
                .POST(HttpRequest.BodyPublishers.ofString(requestBody))
                .build();

        HttpClient client = HttpClient.newHttpClient();
        HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());

        System.out.println("Gemini 응답 코드: " + response.statusCode());
        System.out.println("Gemini 응답 바디: " + response.body());

        return response.body();
    }
    
    public String callGeminiTextOnly(String prompt) throws IOException, InterruptedException {
        String responseBody = callGeminiTest(prompt);

        JsonObject root = JsonParser.parseString(responseBody).getAsJsonObject();
        JsonArray candidates = root.getAsJsonArray("candidates");

        if (candidates == null || candidates.size() == 0) {
            return "응답 없음";
        }

        JsonObject firstCandidate = candidates.get(0).getAsJsonObject();
        JsonObject content = firstCandidate.getAsJsonObject("content");
        JsonArray parts = content.getAsJsonArray("parts");

        if (parts == null || parts.size() == 0) {
            return "응답 없음";
        }

        JsonObject firstPart = parts.get(0).getAsJsonObject();

        return firstPart.get("text").getAsString();
    }
}