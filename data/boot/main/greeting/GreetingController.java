package com.me.demo.greeting;

import java.time.LocalDateTime;
import java.util.concurrent.atomic.AtomicLong;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class GreetingController {

  private final AtomicLong counter = new AtomicLong();

  private Long id() {
    return counter.incrementAndGet();
  }

  private String msg(String name) {
    return String.format("Hi there, %s!", name);
  }

  private LocalDateTime time() {
    return LocalDateTime.now();
  }

  @GetMapping("/greeting")
  public Greeting greeting(@RequestParam(value = "name") String name) {
    return new Greeting(id(), msg(name), time());
  }
}
