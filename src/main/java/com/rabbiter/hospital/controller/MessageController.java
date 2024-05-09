package com.rabbiter.hospital.controller;

import com.rabbiter.hospital.service.ApiService;
import com.rabbiter.hospital.utils.ResponseData;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

/**
 * 消息控制器
 *
 * @author XUEW
 */
@RestController
@RequestMapping("/message")
public class MessageController {

    @Autowired
    private ApiService apiService;

    /**
     * 发送消息
     */
    @PostMapping("/query")
    public ResponseData query(@RequestBody String content) {
        String result = apiService.query(content);
        return ResponseData.success(result);
    }
}
