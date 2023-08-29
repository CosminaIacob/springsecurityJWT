package com.easybytes.controller;

import com.easybytes.model.Notice;
import com.easybytes.repository.NoticeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.CacheControl;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import java.util.concurrent.TimeUnit;

@RestController
@RequiredArgsConstructor
public class NoticesController {

    private final NoticeRepository noticeRepository;

    @GetMapping("/notices")
    public ResponseEntity<List<Notice>> getNotices() {
        var notices = noticeRepository.findAllActiveNotices();
        // cache related info
        // telling to the frontend:
        // whatever notices details that I'm sending please use that for next 60 seconds
        // which means, if the user is trying to reload my notices page within 60 seconds
        // the rest api call will not happen from the UI app
        // rather it will try to use the notices details that it already has inside the cache
        // the cache will be valid up to 60 sec
        return ResponseEntity.ok()
                .cacheControl(CacheControl.maxAge(60, TimeUnit.SECONDS))
                .body(notices);
    }
}
