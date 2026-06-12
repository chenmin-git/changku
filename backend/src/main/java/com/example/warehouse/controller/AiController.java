package com.example.warehouse.controller;

import com.example.warehouse.common.ApiResponse;
import com.example.warehouse.dto.AiRequest;
import com.example.warehouse.service.AiService;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.mvc.method.annotation.SseEmitter;

import java.io.IOException;
import java.util.Map;

@RestController
@RequestMapping("/api/ai")
public class AiController {
    private final AiService aiService;

    public AiController(AiService aiService) {
        this.aiService = aiService;
    }

    @PostMapping("/warehouse-assistant")
    public ApiResponse<Map<String, Object>> assistant(@RequestBody AiRequest request) {
        return ApiResponse.ok(aiService.ask(request));
    }

    @GetMapping("/context")
    public ApiResponse<Map<String, Object>> context() {
        return ApiResponse.ok(aiService.contextPayload());
    }

    @PostMapping(value = "/warehouse-assistant/stream", produces = MediaType.TEXT_EVENT_STREAM_VALUE)
    public SseEmitter stream(@RequestBody AiRequest request) {
        SseEmitter emitter = new SseEmitter(120_000L);
        Thread.startVirtualThread(() -> {
            try {
                String answer = aiService.buildStreamingAnswer(request);
                for (String part : splitForStreaming(answer)) {
                    if (!part.isBlank()) {
                        emitter.send(SseEmitter.event().name("delta").data(part));
                        Thread.sleep(35);
                    }
                }
                emitter.send(SseEmitter.event().name("done").data("[DONE]"));
                emitter.complete();
            } catch (Exception ex) {
                try {
                    emitter.send(SseEmitter.event().name("error").data("AI 生成失败：" + ex.getMessage()));
                } catch (IOException ignored) {
                }
                emitter.completeWithError(ex);
            }
        });
        return emitter;
    }

    private String[] splitForStreaming(String text) {
        return text.split("(?<=[。；;！？?\\n])|(?=\\d+\\.\\s)|(?=-\\s)");
    }
}
