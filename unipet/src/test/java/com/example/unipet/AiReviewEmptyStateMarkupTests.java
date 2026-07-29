package com.example.unipet;

import static org.assertj.core.api.Assertions.assertThat;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;

import org.junit.jupiter.api.Test;

class AiReviewEmptyStateMarkupTests {

    private static final String EMPTY_REVIEW_CONDITION = "v-else-if=\"Number(reviewCount) === 0\"";
    private static final String EMPTY_REVIEW_MESSAGE = "작성된 리뷰가 없어 AI 요약이 제공되지 않습니다.";
    private static final String MISSING_SUMMARY_MESSAGE = "AI 리뷰 요약을 준비 중입니다.";

    @Test
    void productReviewShowsAiSummaryCardWhenThereAreNoReviews() throws IOException {
        String markup = readMarkup("src/main/webapp/WEB-INF/product/productView.jsp");

        assertThat(markup)
                .contains(EMPTY_REVIEW_CONDITION)
                .contains(EMPTY_REVIEW_MESSAGE);
    }

    @Test
    void storeReviewShowsAiSummaryCardWhenThereAreNoReviews() throws IOException {
        String markup = readMarkup("src/main/webapp/WEB-INF/reservation/storeDetail.jsp");

        assertThat(markup)
                .contains(EMPTY_REVIEW_CONDITION)
                .contains(EMPTY_REVIEW_MESSAGE);
    }

    @Test
    void productReviewKeepsAiSummaryCardWhileSummaryIsBeingPrepared() throws IOException {
        String markup = readMarkup("src/main/webapp/WEB-INF/product/productView.jsp");

        assertThat(markup)
                .contains("<div class=\"product-review-ai-summary empty\" v-else>")
                .contains(MISSING_SUMMARY_MESSAGE);
    }

    @Test
    void storeReviewKeepsAiSummaryCardWhileSummaryIsBeingPrepared() throws IOException {
        String markup = readMarkup("src/main/webapp/WEB-INF/reservation/storeDetail.jsp");

        assertThat(markup)
                .contains("<div class=\"ai-review-summary empty\" v-else>")
                .contains(MISSING_SUMMARY_MESSAGE);
    }

    private String readMarkup(String relativePath) throws IOException {
        return Files.readString(Path.of(relativePath));
    }
}
