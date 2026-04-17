package com.example.unipet.model;

import java.util.List;

import lombok.*;

@Data
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class ChatResponse {

    private List<Candidate> candidates;

    @Getter
    @Setter
    public static class Candidate {
        private Content content;
        private String finishReason;
        private int index;
        private List<SafetyRating> safetyRatings;
    }

    @Getter @Setter
    public static class Content {
        private List<Parts> parts;
        private String role;
    }

    @Getter @Setter
    public static class Parts {
        private String text;
    }

    @Getter @Setter
    public static class SafetyRating {
        private String category;
        private String probability;
    }
}