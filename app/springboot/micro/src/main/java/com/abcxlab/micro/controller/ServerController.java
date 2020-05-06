package com.abcxlab.micro.controller;


import java.net.InetAddress;
import java.net.UnknownHostException;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class ServerController {

  @RequestMapping("/")
  public String getHostName() throws UnknownHostException {
    return "You've hit " + InetAddress.getLocalHost().getHostName();
  }

}
