package com.example.unipet.model;

import java.util.ArrayList;
import java.util.List;
import lombok.*;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class AiRecommendRequest {

    private List<Content> contents;
    private GenerationConfig generationConfig;

    @Getter @Setter
    public static class Content {
        private Parts parts;
    }

    @Getter @Setter
    public static class Parts {
        private String text;
    }

    @Getter @Setter
    public static class GenerationConfig {
        private int candidateCount;
        private int maxOutputTokens;
        private double temperature;
        private String responseMimeType;
    }

    public AiRecommendRequest(String prompt) {
        this.contents = new ArrayList<>();

        Content content = new Content();
        Parts parts = new Parts();

        parts.setText(prompt);
        content.setParts(parts);

        this.contents.add(content);

        this.generationConfig = new GenerationConfig();
        
        this.generationConfig.setCandidateCount(1);
        this.generationConfig.setMaxOutputTokens(2000);
        this.generationConfig.setTemperature(0.7);
        this.generationConfig.setResponseMimeType("application/json");
    }
}