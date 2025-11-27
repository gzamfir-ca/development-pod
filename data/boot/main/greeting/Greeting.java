package com.me.demo.greeting;

import java.time.LocalDateTime;

public record Greeting(Long id, String msg, LocalDateTime time) {

}
